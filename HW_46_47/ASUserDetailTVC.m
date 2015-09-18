//
//  ASUserDetailTVC.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUserDetailTVC.h"

// Model
#import "ASUser.h"
#import "ASWall.h"
#import "ASFriend.h"
#import "ASGroup.h"


// Collection View
#import "ASInfoMemberCollectionCell.h"
#import "ASInfoMemberFlowLayout.h"

#import "ASPhotosCollectionCell.h"
#import "ASPhotosFlowLayout.h"

// Custom Cell
#import "ASMainUserCell.h"
#import "ASPhotoUserCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"


static NSString* identifierMainUser    = @"ASMainUserCell";
static NSString* identifierPhotos      = @"ASPhotoUserCell";
static NSString* identifierSegmentPost  = @"ASSegmentPost";
static NSString* identifierGray         = @"ASGrayCell";



@interface ASUserDetailTVC () /*<UITableViewDataSource,      UITableViewDelegate ,
                                UICollectionViewDataSource, UICollectionViewDelegate,
                                UIScrollViewDelegate>*/

@property (strong, nonatomic) NSString* groupID;

@property (strong,nonatomic)  ASGroup *currentGroup;
@property (strong,nonatomic)  ASUser *currentUser;

@property (strong, nonatomic) NSMutableArray* arrrayWall;
@property (strong, nonatomic) NSArray* arrayDataCountres;

@property (assign,nonatomic)  BOOL loadingData;
@property (assign, nonatomic) BOOL firstTimeAppear;


@end

@implementation ASUserDetailTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.currentUser  = [ASUser new];
    self.currentGroup = [ASGroup new];
    
    self.arrrayWall  = [NSMutableArray array];
    
    self.loadingData = YES;
    self.firstTimeAppear = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:1.000];
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[ASServerManager sharedManager] authorizeUser:^(ASUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
            [self getUserFromServer];
        }];
        
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Get Friends From Server

-(void)  getUserFromServer {
    

    [[ASServerManager sharedManager] getUsersInfoUserID:@"201621080"
                                              onSuccess:^(ASUser *user) {
                                                  
                                                  self.currentUser = user;
                                                  [self.tableView reloadData];
                                              }
     
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"errpr = %@ statsus %d",[error localizedDescription],statusCode);
                                              }];
    
}



#pragma mark - Get Wall From Server

-(void)  getWallFromServer {
    

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/



@end
