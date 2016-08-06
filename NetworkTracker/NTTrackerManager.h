//
//  TrackerManager.h
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTHTTPModel;
@interface NTTrackerManager : NSObject

+ (instancetype)shareInstance;
- (void)enable;

- (void)addHTTPModel:(NTHTTPModel *)model;

@end
