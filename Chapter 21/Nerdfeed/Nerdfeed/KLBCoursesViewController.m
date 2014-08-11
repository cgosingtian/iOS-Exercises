//
//  KLBCoursesViewController.m
//  Nerdfeed
//
//  Created by Chase Gosingtian on 8/8/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBCoursesViewController.h"
#import "KLBWebViewController.h"
#import "KLBUpcomingCoursesCell.h"

@interface KLBCoursesViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation KLBCoursesViewController

- (instancetype) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.navigationItem.title = @"KLB Courses";
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        _session = [NSURLSession sessionWithConfiguration:config
//                                                 delegate:nil
//                                            delegateQueue:nil];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        [self fetchFeed];
    }
    return self;
}

- (void)fetchFeed
{
//    NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
//         NSString *json = [[NSString alloc] initWithData:data
//                                                encoding:NSUTF8StringEncoding];
//         NSLog(@"%@", json);
         
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:nil];
         //NSLog(@"%@",jsonData);
         
         _courses = jsonData[@"courses"];
         
         NSLog(@"%@",_courses);
         
         dispatch_async(dispatch_get_main_queue(), ^
         {
             [self.tableView reloadData];
         });
     }];
    [dataTask resume];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //return 0;
    NSLog(@"Courses count: %d",_courses.count);
    return _courses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return nil;
    
    NSDictionary *course = _courses[indexPath.row];
    NSArray *upcoming = course[@"upcoming"];
    
    if (upcoming.count == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        cell.textLabel.text = course[@"title"];
        
        return cell;
    }
    else
    {
        KLBUpcomingCoursesCell *upCell = [tableView dequeueReusableCellWithIdentifier:@"KLBUpcomingCoursesCell"
                                                                         forIndexPath:indexPath];
        
        upCell.courseLabel.text = course[@"title"];
        //upCell.textLabel.text = @"KLBUpcomingCoursesCell FAILED TO LOAD";
        upCell.upcomingLabel.text = [NSString stringWithFormat:@"%@",upcoming[1][@"start_date"]];
        
        return upCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = _courses[indexPath.row];
    NSURL *url = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = url;
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

    [self.tableView registerClass:[KLBUpcomingCoursesCell class]
           forCellReuseIdentifier:@"KLBUpcomingCoursesCell"];
    
  //    [self.tableView registerNib:[UINib nibWithNibName:@"KLBUpcomingCoursesCell" bundle:nil] forCellReuseIdentifier:@"KLBUpcomingCoursesCell"];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:
(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *cred =
    [NSURLCredential credentialWithUser:@"BigNerdRanch"
                               password:@"AchieveNerdvana"
                            persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}
@end
