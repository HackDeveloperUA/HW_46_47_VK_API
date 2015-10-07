//
//  ASSubscription.m
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASSubscription.h"

@implementation ASSubscription

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        
   
        NSString* typeSubscription = [responseObject objectForKey:@"type"];

        if ([typeSubscription isEqualToString:@"page"] || [typeSubscription isEqualToString:@"group"]) {
        
            
            self.fullName  = [responseObject objectForKey:@"name"];
            self.groupID   = [[responseObject objectForKey:@"id"] stringValue];
            
            self.memberCount = [[responseObject objectForKey:@"members_count"] stringValue];
            
            NSString* urlString = [responseObject objectForKey:@"photo_100"];
           
            if (urlString) {
                self.mainImageURL = [NSURL URLWithString:urlString];
            }
        
        }
    
         
    }

    return self;
}


@end
