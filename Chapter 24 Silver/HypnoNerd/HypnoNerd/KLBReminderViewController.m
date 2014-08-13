//
//  KLBReminderViewController.m
//  HypnoNerd
//
//  Created by Chase Gosingtian on 8/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBReminderViewController.h"

@interface KLBReminderViewController ()
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@end

@implementation KLBReminderViewController

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        NSLog(@"init happening");
        //tab bar item's title
        self.tabBarItem.title = @"Reminder";
        
        //uiimage
        UIImage *image = [UIImage imageNamed:@"Time.png"];
        
        self.tabBarItem.image = image;
        
        //self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    NSLog(@"restoration id returned");
    return [[self alloc] init];
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

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *dateString = @"";
    
    // Convert Date to string
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    dateString = [dateFormat stringFromDate:self.datePicker.date];
    
    [coder encodeObject:dateString forKey:@"date"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *dateStringDecoded = [coder decodeObjectForKey:@"date"];
    
    // Convert string to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSDate *date = [dateFormat dateFromString:dateStringDecoded];
    
    [self.datePicker setDate:date animated:YES];
    [super decodeRestorableStateWithCoder:coder];
}
@end
