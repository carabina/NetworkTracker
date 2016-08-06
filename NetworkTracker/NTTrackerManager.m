//
//  TrackerManager.m
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import "NTTrackerManager.h"
#import "NTProxyDelegate.h"
#import <objc/runtime.h>

@interface NSURLConnection (xzj_networkTracker)

@property (nonatomic, strong) NTProxyDelegate *proxyDelegate;

@end

@implementation NSURLConnection(xzj_networkTracker)

- (void)setProxyDelegate:(NTProxyDelegate *)proxyDelegate {
    objc_setAssociatedObject(self, @selector(proxyDelegate), proxyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NTProxyDelegate *)proxyDelegate {
    NTProxyDelegate *proxyDelegate = objc_getAssociatedObject(self, _cmd);
    return proxyDelegate;
}

- (void)xzj_start {
    self.proxyDelegate.httpModel.startTime = [NSDate date].timeIntervalSince1970;
    [self xzj_start];
}

- (nullable instancetype)xzj_initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    self.proxyDelegate = [NTProxyDelegate new];
    self.proxyDelegate.hookDelegate = delegate;
    [self.proxyDelegate.httpModel setRequset:request];
    return [self xzj_initWithRequest:request delegate:self.proxyDelegate];
}

- (nullable instancetype)xzj_initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    self.proxyDelegate = [NTProxyDelegate new];
    self.proxyDelegate.hookDelegate = delegate;
    [self.proxyDelegate.httpModel setRequset:request];
    return [self xzj_initWithRequest:request delegate:self.proxyDelegate startImmediately:startImmediately];
}

+ (nullable NSData*)xzj_sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse *__autoreleasing  _Nullable *)response error:(NSError * _Nullable __autoreleasing *)error {
    
    NTProxyDelegate *proxyDelegate = [NTProxyDelegate new];
    proxyDelegate.httpModel.startTime = [NSDate date].timeIntervalSince1970;
    [proxyDelegate.httpModel setRequset:request];
    
    __autoreleasing NSURLResponse *xzj_response;
    NSData *resultData;

    resultData = [self xzj_sendSynchronousRequest:request returningResponse:&xzj_response error:error];
    [proxyDelegate.httpModel setResponse:(NSHTTPURLResponse *)xzj_response];
    proxyDelegate.httpModel.endTime = [NSDate date].timeIntervalSince1970;
    [proxyDelegate.httpModel setData:resultData];
    [[NTTrackerManager shareInstance]addHTTPModel:proxyDelegate.httpModel];
    
    *response = xzj_response;
    
    return resultData;
}

+ (void)xzj_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse * _Nullable, NSData * _Nullable, NSError * _Nullable))handler {
    
    NTProxyDelegate *proxyDelegate = [NTProxyDelegate new];
    proxyDelegate.httpModel.startTime = [NSDate date].timeIntervalSince1970;
    [proxyDelegate.httpModel setRequset:request];
    
    void (^xzj_completionHandler)(NSURLResponse * _Nullable, NSData * _Nullable, NSError * _Nullable) = ^void(NSURLResponse *response, NSData *data, NSError *error) {
        proxyDelegate.httpModel.endTime = [NSDate date].timeIntervalSince1970;
        [proxyDelegate.httpModel setResponse:(NSHTTPURLResponse *)response];
        [proxyDelegate.httpModel setData:data];
        [[NTTrackerManager shareInstance]addHTTPModel:proxyDelegate.httpModel];
        handler(response, data, error);
    };
    
    return [self xzj_sendAsynchronousRequest:request queue:queue completionHandler:xzj_completionHandler];
}

@end


@interface NTTrackerManager ()

@property (nonatomic, strong) NSMutableArray *HTTPModels;

@end

@implementation NTTrackerManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static NTTrackerManager *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTTrackerManager alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    if (self = [super init]) {
        _HTTPModels = [NSMutableArray array];
    }
    return self;
}

- (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL withClass:(Class)class {
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)enable {
    [self swizzleSEL:@selector(start)
             withSEL:@selector(xzj_start)
           withClass:[NSURLConnection class]];
    
    [self swizzleSEL:@selector(initWithRequest:delegate:)
             withSEL:@selector(xzj_initWithRequest:delegate:)
           withClass:[NSURLConnection class]];
    
    [self swizzleSEL:@selector(initWithRequest:delegate:startImmediately:)
             withSEL:@selector(xzj_initWithRequest:delegate:startImmediately:)
           withClass:[NSURLConnection class]];
    
    [self swizzleSEL:@selector(sendSynchronousRequest:returningResponse:error:)
             withSEL:@selector(xzj_sendSynchronousRequest:returningResponse:error:)
           withClass:objc_getMetaClass("NSURLConnection")];
    
    [self swizzleSEL:@selector(sendAsynchronousRequest:queue:completionHandler:)
             withSEL:@selector(xzj_sendAsynchronousRequest:queue:completionHandler:)
           withClass:objc_getMetaClass("NSURLConnection")];
}

- (void)addHTTPModel:(NTHTTPModel *)model {
    [_HTTPModels addObject:model];
    
}
@end


