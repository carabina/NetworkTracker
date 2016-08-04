//
//  TrackerManager.h
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerManager : NSObject

+ (instancetype)shareInstance;
- (void)enable;

@end
