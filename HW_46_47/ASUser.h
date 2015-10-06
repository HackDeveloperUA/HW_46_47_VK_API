//
//  ASUser.h
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUser : NSObject


@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;

@property (strong, nonatomic) NSString* bdate;
@property (strong, nonatomic) NSString* lastSeen;


@property (strong, nonatomic) NSString* countryID;
@property (strong, nonatomic) NSString* cityID;

@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;

@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) BOOL online;


@property (strong, nonatomic) NSString* userID;

@property (strong, nonatomic) NSURL* mainImageURL;
@property (strong, nonatomic) NSURL* photo_50URL;
@property (strong, nonatomic) NSURL* photo_100URL;

// buttons
@property (assign, nonatomic) int  friendStatus;

@property (assign, nonatomic) BOOL enableSendMessageButton;
@property (assign, nonatomic) BOOL enableWritePostButton;
@property (assign, nonatomic) BOOL enableAddFriendButton;

@property (strong, nonatomic) NSString* titleAddFriendButton;

// counteres

@property (strong, nonatomic) NSString* albums;
@property (strong, nonatomic) NSString* audios;
@property (strong, nonatomic) NSString* followers;
@property (strong, nonatomic) NSString* friends;
@property (strong, nonatomic) NSString* groups;
@property (strong, nonatomic) NSString* pages;
@property (strong, nonatomic) NSString* photos;
@property (strong, nonatomic) NSString* videos;
@property (strong, nonatomic) NSString* subscriptions;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

-(void) superDescripton;


@end
