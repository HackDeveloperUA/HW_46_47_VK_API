//
//  ASUser.h
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUser : NSObject


/*
 response =     (
 {
 "can_post" = 1;
 "can_write_private_message" = 1;
 city =             {
 id = 208;
 title = "San Francisco";
 };
 counters =             {
 albums = 1;
 audios = 201;
 followers = 17;
 friends = 53;
 gifts = 1;
 groups = 196;
 notes = 0;
 "online_friends" = 11;
 pages = 90;
 photos = 199;
 subscriptions = 1;
 "user_photos" = 0;
 "user_videos" = 0;
 videos = 77;
 };
 country =             {
 id = 9;
 title = "\U0421\U0428\U0410";
 };
 "first_name" = Hack;
 id = 201621080;
 "last_name" = Developer;
 "last_seen" =             {
         platform = 7;
         time = 1442492060;
         };
 online = 1;
 personal =             {
 langs =                 (
 "\U0905\U0935\U0927\U0940"
 );
 };
 "photo_id" = "201621080_368519366";
 sex = 1;
 status = MHFacebookImageViewer;
 }
 );
 
 */

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
@property (strong, nonatomic) NSURL*    mainImageURL;


// buttons

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
