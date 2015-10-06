//
//  ASSubscriptionTVC.m
//  HW_46_47
//
//  Created by MD on 06.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

// Controller
#import "ASSubscriptionTVC.h"
#import "ASUserTVC.h"
#import "ASGroupTVC.h"

// Model
#import "ASUser.h"
#import "ASFriend.h"
#import "ASSubscription.h"


// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"



@interface ASSubscriptionTVC ()  <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* arraySubscription;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation ASSubscriptionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arraySubscription = [NSMutableArray array];
    self.loadingData = YES;
    
    [self getSubscriptionFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Server

-(void) getSubscriptionFromServer{
    
    
    [[ASServerManager sharedManager] getSubscriptionsWithId:self.currentUser.userID
                                                   onOffSet:[self.arraySubscription count]
                                                      count:50
                                                  onSuccess:^(NSArray *subcriptions) {
                                                      
                                                     
                                      
                                      if ([subcriptions count] > 0) {
                                          
                                          NSLog(@"подгружаю");
                                          
                                          [self.arraySubscription addObjectsFromArray:subcriptions];
                                          
                                          NSMutableArray* newPaths = [NSMutableArray array];
                                          
                                          for (int i = (int)[self.arraySubscription count] - (int)[subcriptions count]; i < [self.arraySubscription count]; i++){
                                              [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                          }
                                          
                                          
                                          [self.tableView beginUpdates];
                                          [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                          [self.tableView endUpdates];
                                          
                                          self.loadingData = NO;
                    
                                      }
                                              
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                      
                                                  }];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            NSLog(@"scrollViewDidScroll");
            self.loadingData = YES;
            [self getSubscriptionFromServer];
        }
    }
    
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ASSubscription*  subscription = self.arraySubscription[indexPath.row];
    ASGroupTVC* groupVC = (ASGroupTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASGroupTVC"];
    
    groupVC.superGroupID = subscription.groupID;
    
    [self.navigationController pushViewController:groupVC animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arraySubscription count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    cell.textLabel.text       = @"моска";
    
    ASSubscription* subscription = self.arraySubscription[indexPath.row];
    
    cell.textLabel.text       = subscription.fullName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"members count %@", subscription.memberCount];
    cell.detailTextLabel.textColor  = [UIColor grayColor];
      
    CALayer *imageLayer = cell.imageView.layer;
    [imageLayer setCornerRadius:25];
    [imageLayer setBorderWidth:3];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];
    
    
    [cell.imageView setImageWithURL:subscription.mainImageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
    
    return cell;
}



@end
