//
//  KLBHypnosisViewController.m
//  HypnoNerd
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHypnosisViewController.h"
#import "KLBHypnosisView.h"

@interface KLBHypnosisViewController () <UITextFieldDelegate>

@end

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
    
    //EXERCISE 7 START
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    // Setting the border style on the text field will allow us to see it more easily
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me!";
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    [backgroundView addSubview:textField];
    //EXERCISE 7 END
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
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    return [[self alloc] init];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%@", textField.text);
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""])
    {
        [self drawHypnoticMessage:textField.text];
        [textField setText:@""];
        return YES;
    }
    else return NO;
}

- (void)drawHypnoticMessage:(NSString *)message
{
    for (int i = 0; i < 20; i++)
    {
        UILabel *messageLabel = [[UILabel alloc]init];
        
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        
        [messageLabel sizeToFit];

        int width = self.view.frame.size.width - messageLabel.bounds.size.width;
        int x = arc4random() % width;
        int height = self.view.frame.size.height - messageLabel.bounds.size.height;
        int y = arc4random() % height;
        
        [messageLabel setFrame:CGRectMake(x, y, messageLabel.bounds.size.width, messageLabel.bounds.size.height)];
        
        UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @-25;
        motionEffect.maximumRelativeValue = @25;
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @-25;
        motionEffect.maximumRelativeValue = @25;
        [messageLabel addMotionEffect:motionEffect];
        
        [self.view addSubview:messageLabel];
    }
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    //[coder encodeObject:self.datePicker.date forKey:@"date"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    //NSDate *dateDecoded = [coder decodeObjectForKey:@"date"];
    //self.datePicker.date = dateDecoded;
    [super decodeRestorableStateWithCoder:coder];
}
@end
