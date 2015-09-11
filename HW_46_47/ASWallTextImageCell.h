//
//  ASWallTextImageCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASWallTextImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *fullName;

@property (weak, nonatomic) IBOutlet UILabel *date;


@property (weak, nonatomic) IBOutlet UILabel *textPost;

@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
@property (weak, nonatomic) IBOutlet UIView *parentViewForLikeCommentRepost;



@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;



@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@property (weak, nonatomic) IBOutlet UILabel *repostLabel;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;



@end
