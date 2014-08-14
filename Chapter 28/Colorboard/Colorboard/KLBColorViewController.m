//
//  KLBColorViewController.m
//  Colorboard
//
//  Created by Chase Gosingtian on 8/13/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBColorViewController.h"

@interface KLBColorViewController ()
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISlider *redSlider;
@property (nonatomic, weak) IBOutlet UISlider *greenSlider;
@property (nonatomic, weak) IBOutlet UISlider *blueSlider;
@end

@implementation KLBColorViewController

- (void)viewDidLoad
{
    [self changeColor:self];
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
}

- (IBAction)changeColor:(id)sender
{
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    NSLog(@"Values R %f G %f B %f",red,green,blue);
    UIColor *newColor = [UIColor colorWithRed:red
                                        green:green
                                         blue:blue
                                        alpha:1.0];
    self.view.backgroundColor = newColor;
}

@end
