//
//  KLBReminderViewController.m
//  HypnoNerd
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBReminderViewController.h"

@interface KLBReminderViewController ()
@property (nonatomic, unsafe_unretained) IBOutlet UIDatePicker *datePicker;
@end

@implementation KLBReminderViewController

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    [note release];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        //tab bar item's title
        self.tabBarItem.title = @"Reminder";
        
        //uiimage
        UIImage *image = [UIImage imageNamed:@"Time.png"];
        
        self.tabBarItem.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    NSLog(@"KLBReminderViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"override appear");
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
//    [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:60]];
}

@end
