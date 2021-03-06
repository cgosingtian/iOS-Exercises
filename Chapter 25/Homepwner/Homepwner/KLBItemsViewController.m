//
//  KLBItemsViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDetailViewController.h"
#import "KLBItemsViewController.h"
#import "KLBItem.h"
#import "KLBItemStore.h"
#import "KLBItemCell.h"
#import "KLBImageStore.h"
#import "KLBImageViewController.h"

@interface KLBItemsViewController ()<UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (strong, nonatomic) UIPopoverController *imagePopover;
//@property (nonatomic, strong) IBOutlet UIView *headerView; //strong because top-level view; weak otherwise
@end

@implementation KLBItemsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem; //same idea here as getting self.navigationController
        navItem.title = NSLocalizedString(@"Homepwner",@"Homepwner Application Title");
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        //creates a button for you with selector that activates set editing
        navItem.leftBarButtonItem = self.editButtonItem;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        // Register for locale change notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
               selector:@selector(localeChanged:)
                   name:NSCurrentLocaleDidChangeNotification
                 object:nil];
        
//        for (int i = 0; i < 5; i++) {
//            [[KLBItemStore sharedStore] createItem];
//        }
        
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
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
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    KLBItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLBItemCell" forIndexPath:indexPath];

    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *items = [[KLBItemStore sharedStore] allItems];
    KLBItem *item = items[indexPath.row];
//    cell.textLabel.text = [item description];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    //cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    NSNumberFormatter *currencyFormatter//;
    //if (currencyFormatter == nil) {
    //currencyFormatter
    = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    //}
    
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    
    if (item.valueInDollars > 50)
        cell.valueLabel.textColor = [UIColor greenColor];
    else
        cell.valueLabel.textColor = [UIColor redColor];
    cell.thumbnailView.image = item.thumbnail;
    
    cell.orderLabel.text = [NSString stringWithFormat:@"%f",item.orderingValue];
    
    __weak KLBItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            // If there is no image, we don't need to display anything
            UIImage *img = [[KLBImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            KLBItemCell *strongCell = weakCell;
            
            // Make a rectangle for the frame of the thumbnail relative to
            // our table view
            // Note: there will be a warning on this line that we'll soon discuss
//            CGRect rect = [self.view convertRect:cell.thumbnailView.bounds fromView:cell.thumbnailView];
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                        fromView:strongCell.thumbnailView];
            
            // Create a new BNRImageViewController and set its image
            KLBImageViewController *ivc = [[KLBImageViewController alloc] init];
            //ivc.view.autoresizingMask = UIViewAutoresizingNone;
            ivc.image = img;
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc]
                                 initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };

    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"KLBItemCell" bundle:nil];
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"KLBItemCell"];
    
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
    
    [self.tableView setBackgroundView:bg];
    
    self.tableView.restorationIdentifier = @"KLBItemsViewControllerTableView";
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([indexPath row] == [[[KLBItemStore sharedStore] allItems] count] - 1)
//    {
//        return 44.0;
//    }
//    else return 60.0;
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row != [[[KLBItemStore sharedStore] allItems] count] - 1)
//    {
//        [[cell textLabel] setFont:[UIFont fontWithName:nil size:20]];
//    }
//}

//- (UIView *)headerView
//{
//    // If you have not loaded the headerView yet...
//    if (!_headerView) {
//        // Load HeaderView.xib
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    
//    if (!_headerView) NSLog(@"nullll");
//    return _headerView;
//}

- (IBAction)addNewItem:(id)sender
{
    KLBItem *newItem = [[KLBItemStore sharedStore] createItem];
    
    //We could just tell the table to refresh itself...
    //[(UITableView *)self.view reloadData];
    
    ///...or we could have the table animate the insertion of the new item:
    /*
     // Figure out where that item is in the array
     NSInteger lastRow = [[[KLBItemStore sharedStore] allItems] indexOfObject:newItem];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
     // Insert this new row into the table
     [self.tableView insertRowsAtIndexPaths:@[indexPath]
     withRowAnimation:UITableViewRowAnimationTop];
     */
    
    KLBDetailViewController *detailViewController =
    [[KLBDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:NULL];
}

//- (IBAction)toggleEditingMode:(id)sender
//{
//    // If you are currently in editing mode...
//    if (self.isEditing) {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        // Turn off editing mode
//        [self setEditing:NO animated:YES];
//    } else {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        // Enter editing mode
//        [self setEditing:YES animated:YES];
//    }
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[KLBItemStore sharedStore] allItems];
        KLBItem *item = items[indexPath.row];
        [[KLBItemStore sharedStore] removeItem:item];
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == [[[KLBItemStore sharedStore] allItems] count]-1)
//        return false;
//    else return true;
//}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    if (destinationIndexPath.row != [[[KLBItemStore sharedStore] allItems] count]-1)
//    {
        [[KLBItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                            toIndex:destinationIndexPath.row];
    [self.tableView reloadData];
//    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    //prevent user from moving an item to the last row that has "No more items!" message
//    if(proposedDestinationIndexPath.row == [[[KLBItemStore sharedStore] allItems] count]-1)
//    {
//        return sourceIndexPath;
//    }
//    else
//    {
//        return proposedDestinationIndexPath;
//    }
//}

//bronze challenge
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Remove",@"Delete Button Text");
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row != [[[KLBItemStore sharedStore] allItems] count]-1)
//    {
        //KLBDetailViewController *detailViewController = [[KLBDetailViewController alloc] init];
        
        KLBDetailViewController *detailViewController = [[KLBDetailViewController alloc] initForNewItem:NO];
    
        NSArray *items = [[KLBItemStore sharedStore] allItems];
        KLBItem *selectedItem = [items objectAtIndex:indexPath.row];
    
        detailViewController.item = selectedItem;
    
        // Push it onto the top of the navigation controller's stack
        [self.navigationController pushViewController:detailViewController
                                             animated:YES];
//    }
//    else
//    {
//        [self resignFirstResponder];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    //[self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    NSString *userSize =
    [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)path
                                            inView:(UIView *)view
{
    NSString *identifier = nil;
    if (path && view) {
        // Return an identifier of the given NSIndexPath,
        // in case next time the data source changes
        KLBItem *item = [[KLBItemStore sharedStore] allItems][path.row];
        identifier = item.itemKey;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier
                                                 inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    if (identifier && view) {
        NSArray *items = [[KLBItemStore sharedStore] allItems];
        for (KLBItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                int row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}
@end
