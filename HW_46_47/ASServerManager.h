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
@class ASAccessToken;

@interface ASServerManager : NSObject

@property (strong, nonatomic, readonly) ASUser* currentUser;



#pragma mark - INIT SINGLETONE

//  INIT SINGLETONE

+ (ASServerManager*) sharedManager;



#pragma mark - SETTING

- (void)saveSettings:(ASAccessToken *)token;

- (void)loadSettings;

- (void)authorizeUser:(void(^)(ASUser* user)) completion;



#pragma mark - GET USER INFO

//  GET USER INFO

- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(ASUser* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



#pragma mark - GET USER PHOTOS

//  GET USER PHOTOS

-(void) getPhotoUserID:(NSString*) userID
            withOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSArray* photos)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



#pragma mark - GET COUNTERES

//  GET COUNTERES

- (void)getCounteresInfoByID:(NSString *)ids
                   onSuccess:(void (^) (NSString *country)) success
                   onFailure:(void (^) (NSError *error)) failure;



//  GET CITY BY ID

- (void)getCityInfoByID:(NSString *)ids
              onSuccess:(void (^) (NSString *city)) success
              onFailure:(void (^) (NSError *error)) failure;









#pragma mark - GET GROUP INFO


//  GET GROUP INFO

- (void) getGroupInfoID:(NSString*) groupId
              onSuccess:(void(^)(ASGroup* group)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



#pragma mark - ADD POST ON WALL  / GET WALL


//   ADD POST

-(void) addPostOnWall:(NSString*) ownerID
          withMessage:(NSString*) message
            onSuccess:(void(^)(NSDictionary* result)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;




//   GET WALL

- (void)  getWall:(NSString*) ownerID
       withDomain:(NSString*) domain
       withFilter:(NSString*) filter
       withOffset:(NSInteger) offset
        typeOwner:(NSString*) typeOwner
            count:(NSInteger) count
        onSuccess:(void(^)(NSArray* posts)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;









#pragma mark - ADD LIKE ON POST / DELETE LIKE FROM POST


//  ADD LIKE

- (void) postAddLikeOnWall:(NSString*)ownerID
                    inPost:(NSString*)postID
                      type:(NSString *)type
                 typeOwner:(NSString*) typeOwner
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


//  DELETE LIKE

- (void) postDeleteLikeOnWall:(NSString*)ownerID
                       inPost:(NSString*)postID
                         type:(NSString *)type
                    typeOwner:(NSString*) typeOwner
                    onSuccess:(void(^)(NSDictionary* result))success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;












#pragma mark - REPOST

//  REPOST

- (void)repostOnMyWall:(NSString*)ownerID
                inPost:(NSString*)postID
           withMessage:(NSString*)message
             typeOwner:(NSString*) typeOwner
             onSuccess:(void(^)(NSDictionary* result))success
             onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;









#pragma mark - GET COMMENTS


//  GET COMMENTS

-(void) getCommentFromPost:(NSString*) ownerID
                    inPost:(NSString*) postID
                 typeOwner:(NSString*) typeOwner
                withOffset:(NSInteger) offset
                     count:(NSInteger) count
                 onSuccess:(void(^)(NSArray* comments)) success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;






#pragma mark - JOIN IN GROUP / LEAVE FROM GROUP


//  JOIN IN GROUP


-(void) joinToGroup:(NSString*) groupID
          onSuccess:(void(^)(NSDictionary* result))success
          onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;




//  LEAVE FROM GROUP

-(void) leaveFromGroup:(NSString*) groupID
             onSuccess:(void(^)(NSDictionary* result))success
             onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;




#pragma mark - ADD FRIENDS / DELETE FREIENDS

//  ADD FRIENDS

-(void) addToFriends:(NSString*) userId
           onSuccess:(void(^)(NSDictionary* result))success
           onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;



//  DELETE FRIENDS

-(void) deleteFromFriends:(NSString*) userId
                onSuccess:(void(^)(NSDictionary* result))success
                onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;








#pragma mark - GET FRIENDS / SUBSCRIPTION


//  GET FRIENDS

- (void) getFriendsWithOffset:(NSString*) userId
                   withOffset:(NSInteger) offset
                    withCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



//  GET SUBSCRIPTION

- (void) getSubscriptionsWithId:(NSString*) userId
                       onOffSet:(NSInteger) offset
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSArray* subcriptions)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;






/*

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


- (void)  getWall:(NSString*) ownerID
               withDomain:(NSString*) domain
               withFilter:(NSString*) filter
               withOffset:(NSInteger) offset
                typeOwner:(NSString*) typeOwner
                    count:(NSInteger) count
                onSuccess:(void(^)(NSArray* posts)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


// --- LIKE / REPOST / COMMENT --- //


- (void) postAddLikeOnWall:(NSString*)ownerID
                    inPost:(NSString*)postID
                      type:(NSString *)type
                 typeOwner:(NSString*) typeOwner
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


- (void) postDeleteLikeOnWall:(NSString*)ownerID
                       inPost:(NSString*)postID
                         type:(NSString *)type
                    typeOwner:(NSString*) typeOwner
                    onSuccess:(void(^)(NSDictionary* result))success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


- (void)repostOnMyWall:(NSString*)ownerID
                inPost:(NSString*)postID
           withMessage:(NSString*)message
             typeOwner:(NSString*) typeOwner
             onSuccess:(void(^)(NSDictionary* result))success
             onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;


-(void) getCommentFromPost:(NSString*) ownerID
                    inPost:(NSString*) postID
                 typeOwner:(NSString*) typeOwner
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


// --- ADD IN FRIENDS --- //

-(void) addToFriends:(NSString*) userId
          onSuccess:(void(^)(NSDictionary* result))success
          onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

-(void) deleteFromFriends:(NSString*) userId
           onSuccess:(void(^)(NSDictionary* result))success
           onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

// ---- GET FRIENDS ---- //

- (void) getFriendsWithOffset:(NSString*) userId
                   withOffset:(NSInteger) offset
                    withCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



- (void) getSubscriptionsWithId:(NSString*) userId
                       onOffSet:(NSInteger) offset
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSArray* subcriptions)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


-(void) addPostOnWall:(NSString*) ID
          withMessage:(NSString*) message
            onSuccess:(void(^)(NSDictionary* result)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

*/


@end






















