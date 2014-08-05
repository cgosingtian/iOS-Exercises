//
//  KLBItemsViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBItemsViewController.h"
#import "KLBItem.h"
#import "KLBItemStore.h"

@implementation KLBItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[KLBItemStore sharedStore] createItem];
        }
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Value > 50";
    if(section == 1)
        return @"Value <= 50";
    return @"-";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[[KLBItemStore sharedStore] allItems] count];
    NSArray *itemz = nil;
    if (section == 0)
    {
        itemz = [[KLBItemStore sharedStore] filteredItemsWithValueInDollarGreaterThan:50];
        return [itemz count];
    }
    else
    {
        itemz = [[KLBItemStore sharedStore] filteredItemsWithValueInDollarLessThanEqualTo:50];
        return [itemz count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an instance of UITableViewCell, with default appearance
//    UITableViewCell *cell =
//    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                           reuseIdentifier:@"UITableViewCell"];
    
    // Get a new or recycled cell
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    @try
    {
//        KLBItem *i = [[KLBItem alloc]initWithItemName:@"test"
//                          valueInDollars:55
//                                         serialNumber:@"123"];
//        KLBItem *ii = [[KLBItem alloc] initWithItemName:@"test2"
//                                           valueInDollars:40
//                                             serialNumber:@"456"];
//        NSArray *testAr = @[i,
//                            ii];
//        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.valueInDollars > 50"];
//        NSArray *items = [testAr filteredArrayUsingPredicate:filter];
//        NSLog(@"%@",items);
        NSArray *items = nil;
    if (indexPath.section == 0)
    {
        items = [[KLBItemStore sharedStore] filteredItemsWithValueInDollarGreaterThan:50];
    }
    else
    {
        items = [[KLBItemStore sharedStore] filteredItemsWithValueInDollarLessThanEqualTo:50];
    }
        KLBItem *item = [items objectAtIndex:indexPath.row];
        cell.textLabel.text = [item description];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.tableView setBackgroundView:bg];
}

- (void)addRandomItem
{
    [[KLBItemStore sharedStore] createItem];
    [self reloadInputViews];
    NSLog(@"touch");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [[[KLBItemStore sharedStore] allItems] count] - 1)
    {
        return 44.0;
    }
    else return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [[[KLBItemStore sharedStore] allItems] count] - 1)
    {
        [[cell textLabel] setFont:[UIFont fontWithName:nil size:20]];
    }
}

@end
