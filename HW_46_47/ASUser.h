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


@property (strong, nonatomic) NSString* countryID;
@property (strong, nonatomic) NSString* cityID;

@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;

@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) BOOL online;


@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSURL*    mainImageURL;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

-(void) superDescripton;


@end
