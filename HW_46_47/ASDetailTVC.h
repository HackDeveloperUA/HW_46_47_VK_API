//
//  ASDetailTVC.h
//  HW_46_47
//
//  Created by MD on 02.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASGroup;
@class ASUser;
@class ASWall;

@interface ASDetailTVC : UITableViewController

@property (strong, nonatomic) NSString* groupID;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* postID;

@property (strong,nonatomic)  ASGroup *group;
@property (strong,nonatomic)  ASUser  *user;
@property (strong,nonatomic)  ASWall  *wall;


- (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width;

@end
