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
            
            self.name  = [responseObject objectForKey:@"name"];
            NSString* member = [responseObject objectForKey:@"members_count"];
            if (member) {
                self.memberCount = [NSString stringWithFormat:@"Members count : %@",member];
            }
            
            NSLog(@"self.memmeber = %@",self.memberCount);
        }
        
        
        if ([typeSubscription isEqualToString:@"profile"]) {
            
            self.name  = [NSString stringWithFormat:@"%@ %@",[responseObject objectForKey:@"first_name"],[responseObject objectForKey:@"last_name"]];
            self.memberCount = [responseObject objectForKey:@"status"];
        }
        
        
        
        
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        if (urlString) {
            self.mainPhotoURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}


@end
