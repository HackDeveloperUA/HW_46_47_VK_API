//
//  ASWall.h
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASUser;
@class ASGroup;

@interface ASWall : NSObject


@property (strong, nonatomic) NSString* type;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* date;


@property (strong, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* likes;
@property (strong, nonatomic) NSString* reposts;

@property (strong, nonatomic) NSString* fromID;
@property (strong, nonatomic) NSString* ownerID;


@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSURL*    urlPhoto;

@property (strong, nonatomic) NSMutableArray* attachments;


@property (strong, nonatomic) ASUser* user;
@property (strong, nonatomic) ASGroup* group;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
