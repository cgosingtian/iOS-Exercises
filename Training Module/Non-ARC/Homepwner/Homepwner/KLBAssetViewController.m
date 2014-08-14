//
//  KLBAssetViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/12/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAssetViewController.h"
#import "KLBItemStore.h"
#import "KLBAssetTypeViewController.h"

@interface KLBAssetViewController () <UITextFieldDelegate>

@end

@implementation KLBAssetViewController

@synthesize addButton,assetLabel,source;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [assetLabel becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addAsset:(id)sender {
    [[KLBItemStore sharedStore] addAssetType:assetLabel.text forKey:@"label"];
    [self dismissViewControllerAnimated:YES completion:^()
    {
        [source.tableView reloadData];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addAsset:self];
    return YES;
}

@end
