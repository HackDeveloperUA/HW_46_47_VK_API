//
//  ASWallTextImageCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWall.h"

@interface ASWallAttachmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *textPost;


@property (weak, nonatomic) IBOutlet UIView *attachmentsView;
@property (weak, nonatomic) IBOutlet UIView *sharedView;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *repostLabel;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;

//+(CGFloat) heightForTextInWall:(NSString*) text;
//+(CGFloat) heightForTextInWall:(NSString*) text andWidthTextCell:(CGFloat) widthCellText;
//+(CGFloat) heightForTextInWall:(NSString*) text withPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText;


/*
+(CGFloat) heightForTextWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText andViewFrame:(UIView*) superView;
+(CGFloat) heightForAttachmentsWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText;


+(CGFloat) heightImageAttachemts:(NSArray*) attachments andAttachmentView:(UIView*) attachmentView;
*/

+(CGFloat) heightForTextWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText;

@end
