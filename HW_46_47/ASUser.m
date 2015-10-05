//
//  ASUser.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUser.h"

@implementation ASUser


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        //photo_max_orig,status,sex,bdate,city, online
        
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [[responseObject objectForKey:@"id"] stringValue];
        
        self.status    = [responseObject objectForKey:@"status"];
        
   
     self.bdate = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[responseObject objectForKey:@"date"]];
     self.lastSeen = [self parseDataWithDateFormetter:@"EEEE HH:mm" andDate:[[responseObject objectForKey:@"last_seen"] objectForKey:@"time"]];
        
        
        self.city    = [[responseObject objectForKey:@"city"]    objectForKey:@"title"];
        self.country = [[responseObject objectForKey:@"country"] objectForKey:@"title"];
        self.online  = [[responseObject objectForKey:@"online"] boolValue];
    
        
        NSString* urlString = [responseObject objectForKey:@"photo_max_orig"];
        if (urlString) {
            self.mainImageURL = [NSURL URLWithString:urlString];
        }
        
        self.photo_50URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.photo_100URL = [NSURL URLWithString:[responseObject objectForKey:@"photo_100"]];

        // counteres
        
        self.albums     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"albums"] stringValue];
        self.audios     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"audios"] stringValue];
        self.followers  = [[[responseObject objectForKey:@"counters"]  objectForKey:@"followers"] stringValue];
        self.friends    = [[[responseObject objectForKey:@"counters"]  objectForKey:@"friends"] stringValue];
        self.groups     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"groups"] stringValue];
        self.pages      = [[[responseObject objectForKey:@"counters"]  objectForKey:@"pages"] stringValue];
        self.photos     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"photos"] stringValue];
        self.videos     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"videos"] stringValue];
        self.subscriptions = [[[responseObject objectForKey:@"counters"]  objectForKey:@"subscriptions"] stringValue];
        
        
        // buttons
        
        self.enableSendMessageButton = [[responseObject objectForKey:@"can_write_private_message"] boolValue];
        self.enableWritePostButton   = [[responseObject objectForKey:@"can_post"] boolValue];
        
        int friendStatus   = [[responseObject objectForKey:@"friend_status"] integerValue];
        
        if (friendStatus == 0) {
            self.enableAddFriendButton = YES;
            self.titleAddFriendButton  = @"Add to Friends";
        }
        else
            if (friendStatus == 1) {
                self.enableAddFriendButton = NO;
                self.titleAddFriendButton  = @"You Follow";
            }
            else
                if (friendStatus == 2) {
                    self.enableAddFriendButton = YES;
                    self.titleAddFriendButton  = @"Approve request";
                }
                else
                    if (friendStatus == 3) {
                        self.enableAddFriendButton = NO;
                        self.titleAddFriendButton  = @"In Friends";
                    }        
    }
    
    return self;
    
}

-(NSString*) parseDataWithDateFormetter:(NSString*)dateFormat andDate:(NSString*) date {
    
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:dateFormat];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    NSString *parseDate = [dateFormater stringFromDate:dateTime];
    
    return parseDate;
}



-(void) description {
    
    
    NSLog(@"\n\n\n\n\n\n");
    NSLog(@"First Name = %@",self.firstName);
    NSLog(@"Last Name  = %@",self.lastName);
    
    NSLog(@"bdate = %@",self.bdate);
    NSLog(@"country = %@",self.country);
    NSLog(@"city  = %@",self.city);
    NSLog(@"status = %@",self.status);
    
    NSLog(@"online = %hhd",self.online);
    NSLog(@"userID = %@",self.userID);
    NSLog(@"mainImage URL = %@",self.mainImageURL);
}

@end
