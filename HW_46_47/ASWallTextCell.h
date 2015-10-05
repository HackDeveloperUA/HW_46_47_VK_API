//
//  ASWallTextCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWall.h"

@interface ASWallTextCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *textPost;


@property (weak, nonatomic) IBOutlet UIView *sharedView;


@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@property (weak, nonatomic) IBOutlet UIView *repostView;
@property (weak, nonatomic) IBOutlet UILabel *repostLabel;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;


@property (weak, nonatomic) IBOutlet UIButton *openOwnerPage;

+(CGFloat) heightForAttachmentsWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText;

@end
