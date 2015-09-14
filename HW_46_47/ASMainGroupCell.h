//
//  ASMainGroupCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMainGroupCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *fullNameGroup;
@property (weak, nonatomic) IBOutlet UILabel *typeGroup;
@property (weak, nonatomic) IBOutlet UILabel *statusGroup;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (CGFloat) heightForText:(NSString*) text;
+ (CGFloat) heightForLabel:(UILabel*) label;

@end
