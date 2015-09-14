//
//  ASFollower.m
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASFollower.h"

@implementation ASFollower

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        
        NSString* firstName = [responseObject objectForKey:@"first_name"];
        NSString* lastName  = [responseObject objectForKey:@"last_name"];
        
        self.fullName  = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        self.status    = [responseObject objectForKey:@"status"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.userPhotoURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}




@end
