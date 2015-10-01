//
//  ASWallTextImageCell.m
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASWallAttachmentCell.h"
#import "ASPhoto.h"


static CGSize CGResizeHeight(CGSize size,  float targetHeight) {
    
    //CGFloat targetHeight = 65.0f;
    CGFloat scaleFactor = targetHeight / size.height;
    CGFloat targetWidth = size.width * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}


static CGSize CGResizeWidth(CGSize size, float targetWidth) {
    
    //CGFloat targetWidth  = 65.0f;
    CGFloat scaleFactor  = targetWidth / size.width;
    CGFloat targetHeight = size.height * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}



@implementation ASWallAttachmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(CGFloat) heightForTextWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText {
    
    
    CGFloat offset = 8.0;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    shadow = nil;
    
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    // - 2 * offset
    CGRect rect = [wall.text boundingRectWithSize:CGSizeMake(widthCellText - 2*offset , CGFLOAT_MAX)
                                          options:   NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil];
    
    return CGRectGetHeight(rect) - 2 * offset;
}




/*
+(CGFloat) heightImageAttachemts:(NSArray*) attachments andAttachmentView:(UIView*) attachmentView{
    
    

    if ([attachments count]>=1) {
        
        ASPhoto* photo = attachments[0];
        
        if (photo.height < 225 || photo.width < 225) {
            return photo.height;
        } else{
            
            if (photo.width > photo.height) {
                
                CGSize oldSize = CGSizeMake(photo.width, photo.height);
                CGSize newSize = CGResizeWidth(oldSize, CGRectGetWidth(attachmentView.bounds));
                
                return newSize.height;
            } else {
                
                return CGRectGetHeight(attachmentView.bounds);
            }
            
        }
        
        
    }
    return 10.f;
    
}




+(CGFloat) heightForTextWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText {
//+(CGFloat) heightForTextWithPostModel:(ASWall*) wall andWidthTextCell:(CGFloat) widthCellText andViewFrame:(UIView*) superView{
    

   // NSLog(@"frame %@",NSStringFromCGRect(superView.frame));
   // NSLog(@"bound %@",NSStringFromCGRect(superView.bounds));

    
    CGFloat offset = 8.0;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    shadow = nil;
    
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    // - 2 * offset
    CGRect rect = [wall.text boundingRectWithSize:CGSizeMake(widthCellText - 2*offset , CGFLOAT_MAX)
                                     options:   NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) - 2 * offset;
}*/



@end
