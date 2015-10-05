//
//  ASLink.h
//  HW_46_47
//
//  Created by MD on 05.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLink : NSObject

@property (strong, nonatomic) NSString* urlString;
@property (strong, nonatomic) NSString* title;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
