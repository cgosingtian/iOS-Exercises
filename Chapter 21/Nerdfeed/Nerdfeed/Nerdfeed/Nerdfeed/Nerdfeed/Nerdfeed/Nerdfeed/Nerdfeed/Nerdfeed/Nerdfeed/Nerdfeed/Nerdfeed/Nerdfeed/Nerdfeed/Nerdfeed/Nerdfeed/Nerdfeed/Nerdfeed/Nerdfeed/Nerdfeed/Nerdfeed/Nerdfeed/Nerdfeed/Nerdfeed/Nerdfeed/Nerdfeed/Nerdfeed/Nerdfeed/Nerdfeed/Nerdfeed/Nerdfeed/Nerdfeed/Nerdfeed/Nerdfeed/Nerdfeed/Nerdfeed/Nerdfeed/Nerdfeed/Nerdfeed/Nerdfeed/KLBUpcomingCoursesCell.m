//
//  KLBUpcomingCoursesCell.m
//  Nerdfeed
//
//  Created by Chase Gosingtian on 8/11/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBUpcomingCoursesCell.h"

@implementation KLBUpcomingCoursesCell

//@synthesize courseLabel,upcomingLabel;

//- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    if (self)
//    {
//        upcomingLabel.text = @"coming soon";
//        courseLabel.text = @"course";
//    }
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        NSLog(@"initiating klb cell");
    }
    return self;
}

@end
