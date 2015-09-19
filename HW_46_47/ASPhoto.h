//
//  ASPhoto.h
//  HW_46_47
//
//  Created by MD on 19.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPhoto : NSObject



@property (strong, nonatomic) NSString* owner_id;
@property (strong, nonatomic) NSString* postID;
@property (strong, nonatomic) NSString* albumID;

@property (strong, nonatomic) NSString* date;


@property (strong, nonatomic) NSString* commentsCount;
@property (strong, nonatomic) NSString* likesCount;
@property (assign, nonatomic) BOOL      canComment;


@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;


@property (strong, nonatomic) NSURL* photo_75URL;
@property (strong, nonatomic) NSURL* photo_130URL;
@property (strong, nonatomic) NSURL* photo_604URL;
@property (strong, nonatomic) NSURL* photo_807URL;
@property (strong, nonatomic) NSURL* photo_1280URL;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end
