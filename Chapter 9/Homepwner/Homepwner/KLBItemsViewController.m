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

@interface KLBItemsViewController ()
@property (nonatomic, strong) IBOutlet UIView *headerView; //strong because top-level view; weak otherwise
@end

@implementation KLBItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {\
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[KLBItemStore sharedStore] allItems] count];
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
    NSArray *items = [[KLBItemStore sharedStore] allItems];
    KLBItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    [self.tableView setBackgroundView:bg];
}

- (void)addRandomItem
{
    KLBItem *newItem = [[KLBItemStore sharedStore] createItem];
    
    //We could just tell the table to refresh itself...
    //[(UITableView *)self.view reloadData];
    
    ///...or we could have the table animate the insertion of the new item:
    
    // Figure out where that item is in the array
    NSInteger lastRow = [[[KLBItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    // Insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
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

- (UIView *)headerView
{
    // If you have not loaded the headerView yet...
    if (!_headerView) {
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    
    if (!_headerView) NSLog(@"nullll");
    return _headerView;
}

- (IBAction)addNewItem:(id)sender
{
    [self addRandomItem];
}

- (IBAction)toggleEditingMode:(id)sender
{
    // If you are currently in editing mode...
    if (self.isEditing) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}

@end
