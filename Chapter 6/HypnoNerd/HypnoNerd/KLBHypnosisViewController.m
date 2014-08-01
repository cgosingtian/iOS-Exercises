//
//  KLBHypnosisViewController.m
//  HypnoNerd
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHypnosisViewController.h"
#import "KLBHypnosisView.h"

@implementation KLBHypnosisViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    KLBHypnosisView *backgroundView = [[KLBHypnosisView alloc]initWithFrame:frame];
    
    self.view = backgroundView;
}

@end
