//
//  KLBHypnosisView.m
//  Hypnosister
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHypnosisView.h"

@implementation KLBHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
//    float radius = MIN(bounds.size.width, bounds.size.height) / 2.0;
    float radius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //[path addArcWithCenter:center radius:radius startAngle:0.0 endAngle:2.0*M_PI clockwise:YES];
    
    for (float f = radius;f > 0; f -= 25.0)
    {
        // "lifts the pencil to this point"
        [path moveToPoint:CGPointMake(center.x + f, center.y)];
        // "draw circle where pencil is"
        [path addArcWithCenter:center radius:f startAngle:0.0 endAngle:2.0*M_PI clockwise:YES];
    }
    
    // "all strokes hereafter will be light gray"
    [[UIColor lightGrayColor] setStroke];
    
    [path setLineWidth:10];
    [path stroke];
    
    [[UIImage imageNamed:@"logo.png"] drawInRect:bounds];
    
}


@end
