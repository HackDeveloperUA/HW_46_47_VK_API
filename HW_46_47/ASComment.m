//
//  ASComment.m
//  HW_46_47
//
//  Created by MD on 02.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASComment.h"
#import "ASPhoto.h"
#import "ASUser.h"
#import "ASGroup.h"

@implementation ASComment



-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        
   
        self.text = [responseObject objectForKey:@"text"];
        
       
        self.likes     = [[[responseObject objectForKey:@"likes"]    objectForKey:@"count"] stringValue];
        self.canLike   = [[[responseObject objectForKey:@"likes"]    objectForKey:@"can_like"]boolValue];
        
        self.postID  = [responseObject objectForKey:@"id"];
        self.fromID  = [[responseObject objectForKey:@"from_id"]  stringValue];
        
        
        NSDictionary* attachmentsDict = [responseObject objectForKey:@"attachments"];
        self.attachments = [NSMutableArray array];
        
        if (![attachmentsDict isEqual:nil]) {
            
            
            for (NSDictionary* dict in [responseObject objectForKey:@"attachments"]) {
                
                
                if ([[dict objectForKey:@"type"]  isEqual: @"photo"]) {
                    ASPhoto* photo = [[ASPhoto alloc] initFromResponseWallGet:dict];
                    [self.attachments addObject:photo];
                }
                
                if ([[dict objectForKey:@"type"]  isEqual: @"video"]) {
                    
                }
                
            }
        }
        
        if (!self.type) {
           self.type =  @"comment";
        }
        
    }
    
    return self;
}

-(void) description {
    

    NSLog(@"\n\n");
    NSLog(@" type     = %@",self.type);
    NSLog(@" postID   = %@",self.postID);
    NSLog(@" text     = %@",self.text);
    NSLog(@" likes    = %@",self.likes);
    NSLog(@" fromID   = %@",self.fromID);
    NSLog(@" ownerID  = %@",self.ownerID);
    NSLog(@" fullName = %@",self.fullName);
    NSLog(@" urlPhoto = %@",self.urlPhoto);
    NSLog(@" user = %@ %@",self.user.firstName,self.user.lastName);
    NSLog(@"\n\n\n\n");
    
}
@end
