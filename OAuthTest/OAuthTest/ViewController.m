//
//  ViewController.m
//  OAuthTest
//
//  Created by kfurue on 2013/08/13.
//  Copyright (c) 2013年 kfurue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *authorizationCode;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated {
  
  UIViewController *viewController = [[UIViewController alloc] init];
  UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  viewController.view = webView;
  
  NSString *urlString = @"https://accounts.google.com/o/oauth2/auth?"
  "client_id=CLIENT_ID&" // replace to your Client ID
  "redirect_uri=";
  NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob&";
  //  NSString *redirectURI = @"http%3A%2F%2Flocalhost%2Foauth2callback&";
  urlString = [urlString stringByAppendingString:redirectURI];
  urlString = [urlString stringByAppendingString:
               @"scope=https://www.googleapis.com/auth/youtube&"
               "response_type=code&"
               "access_type=offline"];
  NSURL *url = [NSURL URLWithString:urlString];
  //  [[UIApplication sharedApplication] openURL:url];
  
  webView.delegate = self;
  [self presentViewController:viewController animated:YES completion:^{
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('title')[0].innerHTML"];
  if ([title hasPrefix:@"Success"]) {
    self.authorizationCode = [title substringFromIndex:8];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:
                                [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"]
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSString *bodyString = [self.authorizationCode stringByAppendingString:@"&"
                            "client_id=CLIENT_ID&" // replace to your own ID
                            "client_secret=CLIENT_SECRET&" // replace to your own secret
                            "redirect_uri=urn:ietf:wg:oauth:2.0:oob&"
                            "grant_type=authorization_code"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [req setValue:@"application/x-www-form-urlencoded"                 forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:bodyData];
    //    [req setHTTPShouldHandleCookies:YES];
    self.connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"%@", dataString);
}

@end
