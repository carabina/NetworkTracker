//
//  ViewController.m
//  NetworkTracker
//
//  Created by xzj on 16/8/4.
//  Copyright © 2016年 xzj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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






#pragma mark - NSURLConnectionDalegate
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
@end
