//
//  KLBHypnosisViewController.m
//  HypnoNerd
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHypnosisViewController.h"
#import "KLBHypnosisView.h"

@implementation KLBHypnosisViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    KLBHypnosisView *backgroundView = [[KLBHypnosisView alloc]initWithFrame:frame];
    
    self.view = backgroundView;
    
    UISegmentedControl *colorOptions = [[UISegmentedControl alloc] initWithItems:@[@"Red",@"Green",@"Blue"]];
    [colorOptions addTarget:self action:@selector(changeHypnosisViewColor:) forControlEvents:UIControlEventValueChanged];
    
    [colorOptions setBackgroundColor:[UIColor whiteColor]];
    //[colorOptions setTintColor:[UIColor whiteColor]];
    [colorOptions setFrame:CGRectMake(frame.origin.x+(frame.size.width/2.0)/2.0, frame.origin.y + 30.0, 150.0, 20.0)];
    
    [self.view addSubview:colorOptions];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        //tab bar item's title
        self.tabBarItem.title = @"Hypnotize";
        
        //uiimage
        UIImage *image = [UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    NSLog(@"KLBHypnosisViewController loaded its view.");
}

- (void)changeHypnosisViewColor:(id)sender
{
    KLBHypnosisView *hv = (KLBHypnosisView *)self.view;
    
    switch ([sender selectedSegmentIndex])
    {
        case 0:
            [hv setCircleColor:[UIColor redColor]];
            break;
        case 1:
            [hv setCircleColor:[UIColor greenColor]];
            break;
        case 2:
            [hv setCircleColor:[UIColor blueColor]];
            break;
    }
}
@end
