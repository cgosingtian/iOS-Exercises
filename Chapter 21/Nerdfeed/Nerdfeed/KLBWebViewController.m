//
//  KLBWebViewController.m
//  Nerdfeed
//
//  Created by Chase Gosingtian on 8/11/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBWebViewController.h"

@interface KLBWebViewController ()

@property bool enableButtons;

@end

@implementation KLBWebViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc]init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void) setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL)
    {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStyleBordered target:self action:@selector(goForward)];
        UIBarButtonItem *enableButton = [[UIBarButtonItem alloc] initWithTitle:@"Enable" style:UIBarButtonItemStyleBordered target:self action:@selector(activateButtons)];
        [enableButton setTag:1];
        
        [self setToolbarItems:@[backButton,forwardButton,enableButton]];
        _enableButtons = true;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void) goBack
{
    UIWebView *webView = (UIWebView *)self.view;
    [webView goBack];
}
- (void) goForward
{
    UIWebView *webView = (UIWebView *)self.view;
    [webView goForward];
}
- (void) activateButtons
{
    for (UIBarButtonItem *item in self.toolbarItems)
    {
        if (item.tag == 1)
        {
            [item setTitle:_enableButtons ? @"Disable" : @"Enable"];
        }
        else
        {
            [item setEnabled:_enableButtons ? NO : YES];
        }
    }
    
    _enableButtons = !_enableButtons;
}
@end
