//
//  ASFriendTVC.m
//  HW_46_47
//
//  Created by MD on 06.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//


// Controllers
#import "ASFriendTVC.h"
#import "ASUserTVC.h"

// Model
#import "ASUser.h"
#import "ASFriend.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"


@interface ASFriendTVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) NSMutableArray* arrayFriends;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation ASFriendTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayFriends = [NSMutableArray array];
    self.loadingData = YES;
    
    [self getFriendsFromServer];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server


-(void) getFriendsFromServer{
    
    [[ASServerManager sharedManager] getFriendsWithOffset:self.currentUser.userID
                                               withOffset:[self.arrayFriends count]
                                                withCount:50
                                                onSuccess:^(NSArray *friends) {
                                        
                                                    
                                                    
                                    if ([friends count] > 0) {
                                        
                                        NSLog(@"подгружаю");
                                        
                                        [self.arrayFriends addObjectsFromArray:friends];
                                        
                                        NSMutableArray* newPaths = [NSMutableArray array];
                                        
                                        for (int i = (int)[self.arrayFriends count] - (int)[friends count]; i < [self.arrayFriends count]; i++){
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
            [self getFriendsFromServer];
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
    
    ASFriend*  friend = self.arrayFriends[indexPath.row];
    ASUserTVC* userVC = (ASUserTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASUserDetailTVC"];
    
    userVC.superUserID = friend.userID;

    
    [self.navigationController pushViewController:userVC animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString* identifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    
    ASFriend* friend = self.arrayFriends[indexPath.row];
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
    cell.detailTextLabel.text = friend.isOnline;
   
    CALayer *imageLayer = cell.imageView.layer;
    [imageLayer setCornerRadius:25];
    [imageLayer setBorderWidth:3];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];

    
    [cell.imageView setImageWithURL:friend.imageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
  
    return cell;
}



@end
