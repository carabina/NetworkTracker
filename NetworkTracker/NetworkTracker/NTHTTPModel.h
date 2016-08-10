//
//  HTTPModel.h
//  NetworkTracker
//
//  Created by xzj on 16/8/5.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTHTTPModel : NSObject

@property (nonatomic, strong, nullable) NSString *startDateString;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) NSTimeInterval DurationTime;

//request
@property (nonatomic, strong, nullable) NSString *requestURLString;
@property (nonatomic, strong, nullable) NSString *requestCachePolicy;
@property (nonatomic, assign) double requestTimeoutInterval;
@property (nonatomic, strong, nullable) NSString *requestHTTPMethod;
@property (nonatomic,nullable,strong) NSString *requestAllHTTPHeaderFields;
@property (nonatomic,nullable,strong) NSString *requestHTTPBody;

//response
@property (nonatomic, strong, nullable) NSString *responseMIMEType;
@property (nonatomic, strong, nullable) NSString * responseExpectedContentLength;
@property (nonatomic, strong, nullable) NSString *responseTextEncodingName;
@property (nonatomic, strong, nullable) NSString *responseSuggestedFilename;
@property (nonatomic, assign) NSInteger responseStatusCode;
@property (nonatomic, strong, nullable) NSString *responseAllHeaderFields;

//JSONData
@property (nonatomic, strong, nullable) NSString *receiveJSONData;


- (void)setRequset:(nonnull NSURLRequest *)request;
- (void)setResponse:(nonnull NSHTTPURLResponse *)response;
- (void)setData:(nonnull NSData *)data;

@end
