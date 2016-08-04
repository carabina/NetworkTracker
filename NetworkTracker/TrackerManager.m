//
//  TrackerManager.m
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import "TrackerManager.h"
#import "ProxyDelegate.h"
#import <objc/runtime.h>

@interface NSURLConnection (xzj_networkTracker)
@property (nonatomic, strong) ProxyDelegate *proxyDelegate;
@end
@implementation NSURLConnection(xzj_networkTracker)

- (void)setProxyDelegate:(ProxyDelegate *)proxyDelegate {
    objc_setAssociatedObject(self, @selector(proxyDelegate), proxyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ProxyDelegate *)proxyDelegate {
    ProxyDelegate *proxyDelegate = objc_getAssociatedObject(self, _cmd);
    return proxyDelegate;
}

- (void)xzj_start {
    [self xzj_start];
}

- (nullable instancetype)xzj_initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    self.proxyDelegate = [ProxyDelegate new];
    self.proxyDelegate.hookDelegate = delegate;
    return [self xzj_initWithRequest:request delegate:self.proxyDelegate];
}

- (nullable instancetype)xzj_initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    self.proxyDelegate = [ProxyDelegate new];
    self.proxyDelegate.hookDelegate = delegate;
    return [self xzj_initWithRequest:request delegate:self.proxyDelegate startImmediately:startImmediately];
}
//+ (nullable NSURLConnection*)be_connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate {
//    
//}
@end



@implementation TrackerManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TrackerManager *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[TrackerManager alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    if (self = [super init]) {

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
    [self swizzleSEL:@selector(start) withSEL:@selector(xzj_start) withClass:[NSURLConnection class]];
    [self swizzleSEL:@selector(initWithRequest:delegate:) withSEL:@selector(xzj_initWithRequest:delegate:) withClass:[NSURLConnection class]];
    [self swizzleSEL:@selector(initWithRequest:delegate:startImmediately:) withSEL:@selector(xzj_initWithRequest:delegate:startImmediately:) withClass:[NSURLConnection class]];
}
@end


