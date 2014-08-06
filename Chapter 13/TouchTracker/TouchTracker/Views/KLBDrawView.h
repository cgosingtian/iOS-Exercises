//
//  KLBDrawView.h
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBDrawView : UIView

- (NSArray *)finishedLinesImmutable;
- (void)loadLines:(NSMutableArray *)lines;
- (void)emptyLines;

@end
