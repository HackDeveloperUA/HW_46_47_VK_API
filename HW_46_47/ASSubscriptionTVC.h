//
//  ASSubscriptionTVC.h
//  HW_46_47
//
//  Created by MD on 06.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ASUser;
@class ASGroup;

@interface ASSubscriptionTVC : UITableViewController

@property (strong, nonatomic) ASUser*  currentUser;
@property (strong, nonatomic) ASGroup* currentGroup;



@end
