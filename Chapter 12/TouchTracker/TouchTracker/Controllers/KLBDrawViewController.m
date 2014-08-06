//
//  KLBDrawViewController.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDrawViewController.h"
#import "KLBDrawView.h"

@implementation KLBDrawViewController

- (void)loadView
{
    self.view = [[KLBDrawView alloc] initWithFrame:CGRectZero];
}

@end
