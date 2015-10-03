//
//  ASGroup.h
//  HW_46_47
//
//  Created by MD on 14.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGroup : NSObject

//status,activity,can_post,members_count,counters,description

@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSString* groupID;

@property (strong, nonatomic) NSURL* mainImageURL;
@property (strong, nonatomic) NSURL* photo_50URL;
@property (strong, nonatomic) NSURL* photo_100URL;
@property (strong, nonatomic) NSURL* mainCommunityImageURL;


@property (strong, nonatomic) NSString* members;
@property (strong, nonatomic) NSString* topics;
@property (strong, nonatomic) NSString* docs;
@property (strong, nonatomic) NSString* photos;
@property (strong, nonatomic) NSString* videos;
@property (strong, nonatomic) NSString* albums;

@property (strong, nonatomic) NSString* titleJoinButton;
@property (assign, nonatomic) BOOL      isEnablePostButton;
@property (strong, nonatomic) NSString* typeCommunity;
@property (strong, nonatomic) NSString* descriptionCommunity;
@property (strong, nonatomic) NSString* status;



@property (assign, nonatomic) BOOL      isMember;
@property (assign, nonatomic) BOOL      isClosed;
@property (assign, nonatomic) BOOL      isCanPost;




-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;
-(void) description;

@end
