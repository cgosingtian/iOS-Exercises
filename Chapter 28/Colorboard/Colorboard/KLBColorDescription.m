//
//  KLBColorDescription.m
//  Colorboard
//
//  Created by Chase Gosingtian on 8/13/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBColorDescription.h"

@implementation KLBColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0
                                 green:0
                                  blue:1
                                 alpha:1];
        _name = @"Blue";
    }
    return self;
}

@end
