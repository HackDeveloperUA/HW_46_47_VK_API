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
#import "ASMainGroupCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"



@interface ASUserDetailTVC ()

@end

@implementation ASUserDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
