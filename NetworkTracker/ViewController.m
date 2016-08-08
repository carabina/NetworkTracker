//
//  ViewController.m
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

#pragma clang diagnostic ignored "-Wunused-variable"  

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _url = [NSURL URLWithString:@"http://www.oschina.net/action/api/news_list"];
    _request = [NSURLRequest requestWithURL:_url];
    
    NSURLRequest *webViewRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://github.com"]];
    [_webView loadRequest:webViewRequest];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (IBAction)connection_sendAsy:(id)sender {

    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSLog(@"%@",data);
        }
    }];
}

- (IBAction)connection_sendSyn:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response = nil;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    });
}
- (IBAction)connection_initConnection:(id)sender {
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:_request delegate:self];
//    [NSURLConnection connectionWithRequest:_request delegate:self];
}
#pragma clang diagnostic pop

- (IBAction)URLsession:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlsession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *datatask =[urlsession dataTaskWithURL:url];
    [datatask resume];
}
- (IBAction)URLSessionWithHandler:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlsession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    //    NSURLSession *urlsession = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *datatask = [urlsession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"error: %@", error);
        }
        else {
            NSLog(@"Success");
        }
    }];
    [datatask resume];
}

- (IBAction)downloadSession:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://xmind-dl.oss-cn-qingdao.aliyuncs.com/xmind-7-update1-macosx.dmg"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlsession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    
    NSURLSessionDownloadTask *downloadTask = [urlsession downloadTaskWithURL:url];
    [downloadTask resume];
    
}

- (void)dealloc {
    NSLog(@"ViewController dealloc");
}
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
}

- (nullable NSCachedURLResponse*)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    
    NSLog(@"123");
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [session finishTasksAndInvalidate];
//    session = nil;
//    task = nil;
}

@end
