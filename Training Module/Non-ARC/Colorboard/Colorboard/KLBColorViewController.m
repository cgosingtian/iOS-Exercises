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
    [super viewDidLoad];
    if (_existingColor)
    {
        _textField.text = _colorDescription.name;
        
        float red,green,blue,alpha;
        
        [_colorDescription.color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        [self applyColorRed:red
                      green:green
                       blue:blue
                      alpha:alpha];
    }
    else
    {
        [self changeColor:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_existingColor)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.colorDescription.name = self.textField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
}

- (IBAction)changeColor:(id)sender
{
    [self applyColorRed:self.redSlider.value
                  green:self.greenSlider.value
                   blue:self.blueSlider.value
                  alpha:1.0];
}

- (void)applyColorRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    UIColor *newColor = [UIColor colorWithRed:red
                                        green:green
                                         blue:blue
                                        alpha:alpha];
    self.view.backgroundColor = newColor;
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
}

@end
