//
//  ProxyDelegate.h
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTHTTPModel.h"

@interface NTProxyDelegate : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) id hookDelegate;
@property (nonatomic, strong) NTHTTPModel *httpModel;
@property (nonatomic, strong) NSURLRequest *requset;
@property (nonatomic, strong) NSHTTPURLResponse *response;

@end
