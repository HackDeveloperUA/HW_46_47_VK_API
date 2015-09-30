//
//  ASServerManager.h
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASUser;
@class ASGroup;

@interface ASServerManager : NSObject

@property (strong, nonatomic, readonly) ASUser* currentUser;



+ (ASServerManager*) sharedManager;


- (void) authorizeUser:(void(^)(ASUser* user)) completion;


// --- USER --- //


- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(ASUser* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


- (void)getCounteresInfoByID:(NSString *)ids
                   onSuccess:(void (^) (NSString *country)) success
                   onFailure:(void (^) (NSError *error)) failure;


- (void)getCityInfoByID:(NSString *)ids
              onSuccess:(void (^) (NSString *city)) success
              onFailure:(void (^) (NSError *error)) failure;


-(void) getPhotoUserID:(NSString*) userID
            withOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSArray* photos)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

// --- GROUP --- //

- (void) getGroupInfoID:(NSString*) groupId
                  onSuccess:(void(^)(ASGroup* group)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



- (void) getGroupWall:(NSString*) groupID
           withDomain:(NSString*) domain
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


// --- GET INFO WALL --- //

- (void) getInfoUserFromWall:(NSString*) userId
                   onSuccess:(void(^)(NSDictionary* infoUser)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
    
// --- NEW !!! WALL & INFO


- (void)  getNewGroupWall:(NSString*) groupID
               withDomain:(NSString*) domain
               withOffset:(NSInteger) offset
                    count:(NSInteger) count
                onSuccess:(void(^)(NSArray* posts)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
