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


- (void)  getNewGroupWall:(NSString*) groupID
               withDomain:(NSString*) domain
               withFilter:(NSString*) filter
               withOffset:(NSInteger) offset
                    count:(NSInteger) count
                onSuccess:(void(^)(NSArray* posts)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


// --- LIKE / REPOST / COMMENT --- //


- (void) postAddLikeOnWall:(NSString*)groupID
                    inPost:(NSString*)postID
                      type:(NSString *)type
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


- (void) postDeleteLikeOnWall:(NSString*)groupID
                       inPost:(NSString*)postID
                         type:(NSString *)type
                    onSuccess:(void(^)(NSDictionary* result))success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


- (void)repostOnMyWall:(NSString*)groupID
                inPost:(NSString*)postID
           withMessage:(NSString*)message
             onSuccess:(void(^)(NSDictionary* result))success
             onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


-(void) getCommentFromPost:(NSString*) groupID
                    inPost:(NSString*) postID
                withOffset:(NSInteger) offset
                     count:(NSInteger) count
                 onSuccess:(void(^)(NSArray* comments)) success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


// --- JOIN TO GROUP / LEAVE FROM GROUP ---/


-(void) joinToGroup:(NSString*) groupID
          onSuccess:(void(^)(NSDictionary* result))success
          onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

-(void) leaveFromGroup:(NSString*) groupID
             onSuccess:(void(^)(NSDictionary* result))success
             onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


@end






















