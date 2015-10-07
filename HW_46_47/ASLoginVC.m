//
//  ASLoginVC.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASLoginVC.h"
#import "ASAccessToken.h"



@interface ASLoginVC ()  <UIWebViewDelegate>

@property (copy, nonatomic) ASLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation ASLoginVC


- (id) initWithCompletionBlock:(ASLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    self.navigationItem.title = @"Login";
    
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=5067030&"
    "scope=405790&"     //2 4 8 16 131072 256 8192 262144 4096
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.37&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
     webView.delegate = self;
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{  [super didReceiveMemoryWarning]; }

- (void) dealloc
{  self.webView.delegate = nil;  }



#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) item {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}



#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSLog(@"[[request URL] description] = %@",[[request URL] description]);
    
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        
        ASAccessToken* token = [[ASAccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        
        [self dismissViewControllerAnimated:YES  completion:nil];
        
        return NO;
    }
    
    return YES;
}


@end
