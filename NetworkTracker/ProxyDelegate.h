//
//  ProxyDelegate.h
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProxyDelegate : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, weak) id hookDelegate;
@end
