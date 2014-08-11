//
//  KLBWebViewController.h
//  Nerdfeed
//
//  Created by Chase Gosingtian on 8/11/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBWebViewController : UIViewController

@property (nonatomic) NSURL *URL;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *enableButton;

@end
