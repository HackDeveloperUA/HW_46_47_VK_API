//
//  ASFriend.h
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFriend : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;

@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) long long int cityID;
@property (strong, nonatomic) NSString* city;


@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSURL*    imageURL;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end
