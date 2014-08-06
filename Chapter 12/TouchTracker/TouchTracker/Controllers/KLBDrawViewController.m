//
//  KLBDrawViewController.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDrawViewController.h"
#import "KLBDrawView.h"
#import "KLBLine.h"

@implementation KLBDrawViewController

- (void)loadView
{
    self.view = [[KLBDrawView alloc] initWithFrame:CGRectZero];
}

- (void)saveLines
{
}

- (void)loadLines
{
}

- (void)emptyLines
{
    KLBDrawView *drawView = (KLBDrawView *)self.view;
    [drawView emptyLines];
}

@end
