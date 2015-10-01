//
//  ASImageViewGallery.h
//  HW_46_47
//
//  Created by MD on 01.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ASPhoto;


@interface ASImageViewGallery : UIView



@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *framesArray;

- (instancetype) initWithImageArray:(NSArray *)imageArray startPoint:(CGPoint)point;

@end

