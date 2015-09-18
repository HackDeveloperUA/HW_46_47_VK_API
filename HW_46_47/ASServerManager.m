//
//  ASServerManager.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASServerManager.h"
#import "AFNetworking.h"
#import "ASLoginVC.h"
#import "ASAccessToken.h"

#import "ASUser.h"
#import "ASGroup.h"
#import "ASWall.h"


static NSString* kToken = @"kToken";
static NSString* kExpirationDate = @"kExpirationDate";
static NSString* kUserId = @"kUserId";



@interface ASServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) ASAccessToken* accessToken;

@end

@implementation ASServerManager


+ (ASServerManager*) sharedManager {
    
    static ASServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ASServerManager alloc] init];
    });
    
    return manager;
}


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method/"]];
        self.accessToken = [[ASAccessToken alloc]init];
        [self loadSettings];
    }
    return self;
}

- (void)saveSettings:(ASAccessToken *)token {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token.token forKey:kToken];
    [userDefaults setObject:token.expirationDate forKey:kExpirationDate];
    [userDefaults setObject:token.userID forKey:kUserId];
    [userDefaults synchronize];
}

- (void)loadSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken.token = [userDefaults objectForKey:kToken];
    self.accessToken.expirationDate = [userDefaults objectForKey:kExpirationDate];
    self.accessToken.userID = [userDefaults objectForKey:kUserId];
    
}


- (void)authorizeUser:(void(^)(ASUser* user))completion {
    
    if ([self.accessToken.expirationDate compare:[NSDate date]] == NSOrderedDescending) {
        
        [self getUsersInfoUserID:self.accessToken.userID onSuccess:^(ASUser *user) {
            if (completion) {
                completion(user);
            }
        } onFailure:^(NSError *error, NSInteger statusCode) {
            if (completion) {
                completion(nil);
            }
        }];
        
        
    } else {
        
        ASLoginVC* vc = [[ASLoginVC alloc] initWithCompletionBlock:^(ASAccessToken *token) {
            
            [self saveSettings:token];
            self.accessToken = token;
            
            if (token) {
                
                [self getUsersInfoUserID:self.accessToken.userID onSuccess:^(ASUser *user) {
                    if (completion) {
                        completion(user);
                    }
                } onFailure:^(NSError *error, NSInteger statusCode) {
                    if (completion) {
                        completion(nil);
                    }
                }];
                
            } else if (completion) {
                completion(nil);
            }
            
        }];
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        
        [mainVC presentViewController:nav animated:YES completion:nil];
        
    }
}


// --- USER --- //

- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(ASUser* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    //photo_max_orig,status,sex,bdate,city, online
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"user_ids",
                            @"sex,"
                            "bdate,"
                            "city,"
                            "country,"
                            "photo_max_orig,"
                            "online,"
                            "photo_id,"
                            "can_post,"
                            "can_write_private_message,"
                            "status,"
                            "last_seen,"
                            "counters,"
                            "friend_status,"
                            "personal",  @"fields",
                            @"nom",      @"name_case",
                            @"5.37",     @"v",
                            self.accessToken.token, @"access_token",nil];
    
    
    
    [self.requestOperationManager GET:@"users.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSLog(@"JSON: %@",responseObject);
                                  

                                  NSArray* responceArray = [responseObject objectForKey:@"response"];
                                  ASUser* user = nil;
                                  
                                  for (NSDictionary* dict in responceArray) {
                                      user = [[ASUser alloc] initWithServerResponse:dict];
                                  }
                                  
                                  
                              if (success) {
                                  success(user);
                              }
                          }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}




- (void)getCounteresInfoByID:(NSString *)ids
                   onSuccess:(void (^) (NSString *country)) success
                   onFailure:(void (^) (NSError *error)) failure {
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"country_ids", nil];
    
    [self.requestOperationManager GET:@"database.getCountriesById" parameters:paramDictionary
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSArray *objects =   [responseObject objectForKey:@"response"];
                                  NSString* country = [[objects firstObject] objectForKey:@"name"];
                                  
                                  success(country);
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  failure(error);
                              }];
    
}


- (void)getCityInfoByID:(NSString *)ids
              onSuccess:(void (^) (NSString *city)) success
              onFailure:(void (^) (NSError *error)) failure {
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"city_ids", nil];
    
    [self.requestOperationManager GET:@"database.getCitiesById" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        NSString* city = [[objects firstObject] objectForKey:@"name"];
        
        success(city);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}


// --- GROUP --- //

- (void) getGroupInfoID:(NSString*) groupId
              onSuccess:(void(^)(ASGroup* group)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    

    // accessToket тут не нужен . Он вредит
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            groupId,                @"group_id",
                            @"status,activity,can_post,members_count,counters,description", @"fields",
                            @"5.37", @"v",
                            self.accessToken.token, @"access_token" ,nil];
    
    
    [self.requestOperationManager GET:@"groups.getById"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSLog(@"JSON: %@",responseObject);
                                  
                                  NSArray* friendsArray = [responseObject objectForKey:@"response"];
                                  ASGroup* group = nil;
                                  
                                  for (NSDictionary* dict in friendsArray) {
                                      group = [[ASGroup alloc] initWithServerResponse:dict];
                                  }
                                  
                                  
                                  if (success) {
                                      success(group);
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
  
}





- (void) getGroupWall:(NSString*) groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
        
        if (![groupID hasPrefix:@"-"]) {
            groupID = [@"-" stringByAppendingString:groupID];
        }
        
        NSDictionary* params =
        [NSDictionary dictionaryWithObjectsAndKeys:
         groupID,       @"owner_id",
         @(count),      @"count",
         @(offset),     @"offset",
         @"all",        @"filter", nil];
        
        
        [self.requestOperationManager  GET:@"wall.get"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
             
                                     NSLog(@"JSON: %@", responseObject);
             
                                     /*
                                     NSArray* dictsArray = [responseObject objectForKey:@"response"];
                                     
                                     if ([dictsArray count] > 1) {
                                         dictsArray = [dictsArray subarrayWithRange:NSMakeRange(1, (int)[dictsArray count] - 1)];
                                     } else {
                                         dictsArray = nil;
                                     }
                                     
                                     NSMutableArray* objectsArray = [NSMutableArray array];
                                     
                                     for (NSDictionary* dict in dictsArray) {
                                         ASPost* user = [[ASPost alloc] initWithServerResponse:dict];
                                         [objectsArray addObject:user];
                                     }
                                     */
                                       
                                       NSArray* wallArray = [responseObject objectForKey:@"response"];
                                       NSMutableArray* objectsArray = [NSMutableArray array];
                                       
                                       
                                       if (wallArray) {
                                           
                                           //-1
                                           for (int i=1; i<[wallArray count]-1; i++) {
                                               
                                               NSDictionary* dict = [wallArray objectAtIndex:i];
                                               NSLog(@"responce Object = %@",dict);
                                               
                                               ASWall* wall = [[ASWall alloc] initWithServerResponse:dict];
                                               [objectsArray addObject:wall];
                                           }
                                       }
                                       
                                       
                                       
                                     if (success) {
                                         success(objectsArray);
                                     }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             if (failure) {
                 failure(error, operation.response.statusCode);
             }
         }];
    }




@end
