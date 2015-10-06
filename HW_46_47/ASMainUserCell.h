//
//  ASMainUserCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMainUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ownerMainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenORonline;
@property (weak, nonatomic) IBOutlet UILabel *cityORcountry;

@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMember;


@end
