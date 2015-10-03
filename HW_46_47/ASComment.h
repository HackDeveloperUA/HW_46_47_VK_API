//
//  ASComment.h
//  HW_46_47
//
//  Created by MD on 02.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASUser;
@class ASGroup;


@interface ASComment : NSObject


@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* postID;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* date;


@property (strong, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* likes;
@property (strong, nonatomic) NSString* reposts;


@property (assign, nonatomic) BOOL canPost;
@property (assign, nonatomic) BOOL canLike;
@property (assign, nonatomic) BOOL canRepost;




@property (strong, nonatomic) NSString* fromID;
@property (strong, nonatomic) NSString* ownerID;


@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSURL*    urlPhoto;

@property (strong, nonatomic) NSMutableArray* attachments;


@property (strong, nonatomic) ASUser* user;
@property (strong, nonatomic) ASGroup* group;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;
-(void) description;
@end
