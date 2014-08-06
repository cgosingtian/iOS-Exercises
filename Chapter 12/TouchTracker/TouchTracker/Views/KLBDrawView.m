//
//  KLBDrawView.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDrawView.h"
#import "KLBLine.h"

@interface KLBDrawView ()

@property (nonatomic,strong) KLBLine *currentLine;
@property (nonatomic,strong) NSMutableArray *finishedLines;

@end

@implementation KLBDrawView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super init];
    
    if (self)
    {
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}

@end
