//
//  KLBPaletteViewControllerTableViewController.m
//  Colorboard
//
//  Created by Chase Gosingtian on 8/13/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPaletteViewControllerTableViewController.h"
#import "KLBColorViewController.h"
#import "KLBColorDescription.h"

@interface KLBPaletteViewControllerTableViewController ()

@end

@implementation KLBPaletteViewControllerTableViewController

@synthesize colors;

//- (void) dealloc
//{
//    [colors release];
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        colors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSLog(@"init with style");
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return self;
}

- (void)test
{
    KLBColorDescription *color1 = [[KLBColorDescription alloc] init];
    [colors addObject:color1];
    KLBColorDescription *color2 =[[KLBColorDescription alloc] init];
    [colors addObject:color2];
    
    NSLog(@"%@",colors);
    
//    [color1 release];
//    [color2 release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSLog(@"view will appear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    NSLog(@"view did load");
    [self test];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [colors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    KLBColorDescription *cd = (KLBColorDescription *)[colors objectAtIndex:indexPath.row];
    NSLog(@"cell name: %@",cd.name);
    cell.textLabel.text = cd.name;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"]) {
        NSLog(@"NEW COLOR");
        // If we are adding a new color, create an instance
        // and add it to the colors array
        KLBColorDescription *color = [[KLBColorDescription alloc] init];
        [self.colors addObject:color];
        // Then use the segue to set the color on the view controller
        UINavigationController *nc =
        (UINavigationController *)segue.destinationViewController;
        KLBColorViewController *mvc =
        (KLBColorViewController *)[nc topViewController];
        mvc.colorDescription = color;
        
        //[color release];
    }
    else if ([segue.identifier isEqualToString:@"ExistingColor"]) {
        NSLog(@"EXISTING COLOR");
        // For the push segue, the sender is the UITableViewCell
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        NSLog(@"1");
        KLBColorDescription *color = self.colors[ip.row];
        if (color == nil)
            NSLog(@"COLOR NIL 2");
        // Set the color, and also tell the view controller that this
        // is an existing color
        KLBColorViewController *cvc =
        (KLBColorViewController *)segue.destinationViewController;
        NSLog(@"3");
        cvc.colorDescription = color;
        NSLog(@"4");
        cvc.existingColor = YES;
        NSLog(@"%@",cvc.colorDescription.name);
    }
}


//#pragma mark - Getters and Setters
//- (NSMutableArray *)colors
//{
//    NSLog(@"1");
//    if (!colors)
//    {
//        NSLog(@"2");
//        colors = [[NSMutableArray alloc] init];
//        
//        KLBColorDescription *cd = [[KLBColorDescription alloc] init];
//        
//        [colors addObject:cd];
//    }
//    NSLog(@"Colors array has: %@",colors);
//    return colors;
//}

@end
