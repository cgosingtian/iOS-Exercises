//
//  KLBLine.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBLine.h"

@implementation KLBLine

@synthesize begin,end,thickness;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Begin: %f,%f/; End: %f,%f", begin.x,begin.y,end.x,end.y];
}

//-(void)encodeWithCoder:(NSCoder *)encoder{
//    [encoder encodeObject:[NSValue valueWithCGPoint:begin]forKey:@"begin"];
//    [encoder encodeObject:[NSValue valueWithCGPoint:end] forKey:@"end"];
//}
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    if (self = [super init]) {
//        //CGPoint begin,end;
//        NSValue *valBegin = [decoder decodeObjectForKey:@"begin"];
//        [valBegin getValue:&begin];
//        NSValue *valEnd = [decoder decodeObjectForKey:@"end"];
//        [valEnd getValue:&end];
//    }
//    return self;
//}

@end
