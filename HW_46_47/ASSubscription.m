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
        
        /*
         
         {
         "admin_level" = 3;
         id = 74634853;
         "is_admin" = 1;
         "is_closed" = 0;
         "is_member" = 1;
         "members_count" = 775;
         name = "\U041e\U043a\U043e\U043b\U043eXcod\U0430 | Xcode";
         "photo_100" = "https://pp.vk.me/c629412/v629412080/12556/ysRPhWTQHVE.jpg";
         "screen_name" = okoloxcoda;
         status = "\U0412\U0434\U043e\U0445\U043d\U043e\U0432\U0435\U043d\U0438\U0435 \U0434\U043b\U044f \U0440\U0430\U0437\U0440\U0430\U0431\U043e\U0442\U0447\U0438\U043a\U043e\U0432 \U043d\U0430 \U043a\U0430\U0436\U0434\U044b\U0439 \U0434\U0435\U043d\U044c";
         type = page;
         }
         
        */
        
        
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
