//
//  KLBDrawView.m
//  TouchTracker
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDrawView.h"
#import "KLBLine.h"

@interface KLBDrawView () <UIGestureRecognizerDelegate>

//@property (nonatomic,strong) KLBLine *currentLine;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, weak) KLBLine *selectedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic) CGFloat lineWidth;

@end

@implementation KLBDrawView

- (void)emptyLines
{
    [self.finishedLines removeAllObjects];
    NSLog(@"emptied");
}

- (NSArray *)finishedLinesImmutable
{
    return [self.finishedLines copy];
}
- (void)loadLines:(NSMutableArray *)lines
{
    NSLog(@"asdasds");
    if (lines)
    {
        NSLog(@"lines exist");
        self.finishedLines = lines;
    }
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.lineWidth = 10;
        self.finishedLines = [[NSMutableArray alloc] init];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRec.numberOfTapsRequired = 2;
        doubleTapRec.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRec];
        
        UITapGestureRecognizer *tapRec =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tap:)];
        tapRec.delaysTouchesBegan = YES;
        [tapRec requireGestureRecognizerToFail:doubleTapRec];
        [self addGestureRecognizer:tapRec];
        
        UILongPressGestureRecognizer *pressRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
    } else NSLog(@"Failing init");
    
    return self;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    self.lineWidth = abs(([gr velocityInView:self].x + [gr velocityInView:self].y) / 2);
    
    // If we have not selected a line, we do not do anything here
    if (!self.selectedLine) {
        return;
    }
    // When the pan recognizer changes its position... (and the menu is not visible)
    if (gr.state == UIGestureRecognizerStateChanged && ![[UIMenuController sharedMenuController] isMenuVisible]) {
        // How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        // Add the translation to the current beginning and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        // Set the new beginning and end points of the line
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        // Redraw the screen
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
    
    if (gr.state == UIGestureRecognizerStateEnded)
    {
        self.lineWidth = 10;
    }
}

- (void)longPress:(UIGestureRecognizer*)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)doubleTap:(UIGestureRecognizer*)gr
{
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine)
    {
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"Delete" action:@selector(deleteLine:)];
        
        menu.menuItems = @[deleteItem];
        
        [menu setTargetRect:CGRectMake(point.x, point.y, 0, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)deleteLine:(id)sender
{
    
    [self.finishedLines removeObject:self.selectedLine];
    self.selectedLine = nil;
    [self setNeedsDisplay];
}

- (KLBLine *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (KLBLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    // If nothing is close enough to the tapped point, then we did not select a line
    return nil;
}

- (void)strokeLine:(KLBLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = line.thickness;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}
- (void)drawRect:(CGRect)rect
{
#ifdef VIEW_DEBUG
    NSLog(@"DEBUG: Entering drawRect");
#endif
    if (self.selectedLine)
    {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
    for (KLBLine *line in self.finishedLines) {
        if (line != self.selectedLine)
        {
            int estimatedAngle = [self pointPairToBearingDegrees:line.begin secondPoint:line.end];
            
            if (estimatedAngle <= 90)
            {
                [[UIColor purpleColor] set];
            } else if (estimatedAngle <= 180)
            {
                [[UIColor orangeColor] set];
            } else if (estimatedAngle <= 270)
            {
                [[UIColor blueColor] set];
            } else if (estimatedAngle <= 360)
            {
                [[UIColor brownColor] set];
            } else
            {
                [[UIColor blackColor] set];
            }
            
            [self strokeLine:line];
        }
    }
    for (KLBLine *line in [self.linesInProgress allValues]) {
        // If there is a line currently being drawn, do it in red
        [[UIColor redColor] set];
        line.thickness = self.lineWidth;
        [self strokeLine:line];
    }
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
//    if ([touches count] == 2)
//    {
//        //draw circle
//    }else
//    {
        for (UITouch *t in touches)
        {
            // Get location of the touch in view's coordinate system
            CGPoint location = [t locationInView:self];
            KLBLine *line = [[KLBLine alloc] init];
            line.begin = location;
            line.end = location;
            line.thickness = self.lineWidth;
        
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            self.linesInProgress[key] = line;
        }
//    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
//    if ([touches count] == 2)
//    {
//        //draw circle
//    } else
//    {
        for (UITouch *t in touches)
        {
            CGPoint location = [t locationInView:self];
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            KLBLine *line = self.linesInProgress[key];
            line.end = location;
        }
//    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        KLBLine *line = self.linesInProgress[key];
        line.thickness = self.lineWidth;
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
//    self.currentLine = nil;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}
@end
