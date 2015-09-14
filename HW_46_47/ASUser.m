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
        self.userID    = [responseObject objectForKey:@"uid"];
        
        self.status    = [responseObject objectForKey:@"status"];
        
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        
        self.bdate     = date;
        self.cityID    = [responseObject objectForKey:@"city"];
        self.countryID = [responseObject objectForKey:@"country"];
        
        
        self.online  = [[responseObject objectForKey:@"online"] boolValue];
        
        NSString* urlString = [responseObject objectForKey:@"photo_max_orig"];
        
        if (urlString) {
            self.mainImageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
    
}

-(void) superDescripton {
    
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
