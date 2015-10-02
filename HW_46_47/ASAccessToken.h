//
//  ASAccessToken.h
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAccessToken : NSObject


@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate*   expirationDate;
@property (strong, nonatomic) NSString* userID;

@end
