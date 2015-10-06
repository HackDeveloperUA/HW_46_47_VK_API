//
//  ASFriend.m
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASFriend.h"

@implementation ASFriend

-(instancetype) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [[responseObject objectForKey:@"id"] stringValue];
        
        self.status  =   [responseObject objectForKey:@"status"];
        self.cityID  = [[[responseObject objectForKey:@"city"] objectForKey:@"id"] integerValue];
        self.city    = [[responseObject objectForKey:@"city"]objectForKey:@"title"];
        
        int online  = [[responseObject objectForKey:@"online"] integerValue];
    
      
        online == (1) ? (self.isOnline = @"Online") : (self.isOnline = @"offline");
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}


@end
