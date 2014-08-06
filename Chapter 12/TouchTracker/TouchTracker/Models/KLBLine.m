//
//  KLBLine.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBLine.h"

@implementation KLBLine

@synthesize begin,end;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Begin: %f,%f/; End: %f,%f", begin.x,begin.y,end.x,end.y];
}

@end
