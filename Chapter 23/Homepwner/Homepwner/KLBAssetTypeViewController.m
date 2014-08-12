//
//  KLBAssetTypeViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/12/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAssetTypeViewController.h"
#import "KLBItemStore.h"
#import "KLBItem.h"
#import "KLBAssetViewController.h"

@implementation KLBAssetTypeViewController

@synthesize item;

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem; //same idea here as getting self.navigationController
        navItem.title = @"Select Asset Type";
        
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewAsset:)];
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
    }
    
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UINib *nib = [UINib nibWithNibName:@"UITableViewCell" bundle:[NSBundle mainBundle]];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[KLBItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    NSArray *allAssets = [[KLBItemStore sharedStore] allAssetTypes];
    
    NSManagedObject *assetType = [allAssets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [assetType valueForKey:@"label"];
    
    // Checkmark the one that is currently selected
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[KLBItemStore sharedStore] allAssetTypes];
    
    NSManagedObject *assetType = [allAssets objectAtIndex:indexPath.row];
    
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

- (IBAction)addNewAsset:(id)sender
{
    KLBAssetViewController *avc = [[KLBAssetViewController alloc] init];
    avc.source = self;
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:avc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController
                       animated:YES
                     completion:^(){}];
}

@end
