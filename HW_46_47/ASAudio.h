//
//  ASAudio.h
//  HW_46_47
//
//  Created by MD on 07.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAudio : NSObject
/*
 
 
 
*/

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* artist;

@property (strong, nonatomic) NSURL* urlAudio;

@property (strong, nonatomic) NSString* ownerId;
@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSString* duration;



-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;
    
@end
