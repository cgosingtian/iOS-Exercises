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
@property (nonatomic, unsafe_unretained) UITextField *textField;
@end

@implementation KLBHypnosisViewController

- (void)loadView
{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    KLBHypnosisView *backgroundView = [[KLBHypnosisView alloc]initWithFrame:frame];
    
    self.view = backgroundView;
    [backgroundView release];
    
    UISegmentedControl *colorOptions = [[UISegmentedControl alloc] initWithItems:@[@"Red",@"Green",@"Blue"]];
    [colorOptions addTarget:self action:@selector(changeHypnosisViewColor:) forControlEvents:UIControlEventValueChanged];
    
    [colorOptions setBackgroundColor:[UIColor whiteColor]];
    //[colorOptions setTintColor:[UIColor whiteColor]];
    [colorOptions setFrame:CGRectMake(frame.origin.x+(frame.size.width/2.0)/2.0, frame.origin.y + 30.0, 150.0, 20.0)];
    
    [self.view addSubview:colorOptions];
    [colorOptions release];
    
    //EXERCISE 7 START
//    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    CGRect textFieldRect = CGRectMake(40, -30, 240, 30);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    // Setting the border style on the text field will allow us to see it more easily
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me!";
    textField.returnKeyType = UIReturnKeyDone;
    
    self.textField = textField;
    textField.delegate = self;
    
    [backgroundView addSubview:textField];
    [textField release];
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
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    NSLog(@"KLBHypnosisViewController loaded its view.");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0
                          delay:0.0
         usingSpringWithDamping:0.25
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         CGRect frame = CGRectMake(40, 70, 240, 30);
                         self.textField.frame = frame;
                     }
                     completion:NULL];
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
        
        // Set the label's initial alpha
        messageLabel.alpha = 0.0;
        // Animate the alpha to 1.0
//        [UIView animateWithDuration:0.5 animations:^{
//            messageLabel.alpha = 1.0;
//        }];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^{
                             messageLabel.alpha = 1.0;
                         }
                         completion:NULL];
        
        [UIView animateKeyframesWithDuration:1.0 delay:0.0
                                     options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
                messageLabel.center = self.view.center;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                int x = arc4random() % width;
                int y = arc4random() % height;
                messageLabel.center = CGPointMake(x, y);
            }];
        } completion:NULL];
        
        [messageLabel release];
    }
}
@end
