//
//  ProxyDelegate.m
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import "ProxyDelegate.h"

@implementation ProxyDelegate

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"ProxyDelegate init");
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(connection:didReceiveResponse:)) {
        return YES;
    }
    return [self.hookDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.hookDelegate methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.hookDelegate];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self.hookDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.hookDelegate connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([self.hookDelegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.hookDelegate connection:connection didReceiveData:data];
    }
}
@end
