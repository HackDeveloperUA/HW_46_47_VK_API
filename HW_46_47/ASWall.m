//
//  ASWall.m
//  HW_46_47
//
//  Created by MD on 12.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASWall.h"
#import "ASPhoto.h"
#import "ASLink.h"

#import "ASAudio.h"


@implementation ASWall


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
  
    if (self) {
        
        
        self.text = [responseObject objectForKey:@"text"];
                
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date   = [dateFormater stringFromDate:dateTime];
        
        self.date        = date;
        self.comments = [[[responseObject objectForKey:@"comments"] objectForKey:@"count"] stringValue];
        self.likes    = [[[responseObject objectForKey:@"likes"]    objectForKey:@"count"] stringValue];
        self.reposts  = [[[responseObject objectForKey:@"reposts"]  objectForKey:@"count"] stringValue];
        
         self.canPost   = [[[responseObject objectForKey:@"comments"] objectForKey:@"can_post"]boolValue];
         self.canLike   = [[[responseObject objectForKey:@"likes"]    objectForKey:@"can_like"]boolValue];
         self.canRepost = [[[responseObject objectForKey:@"reposts"]  objectForKey:@"user_reposted"]boolValue];
        
        
        self.canRepost = ([[[responseObject objectForKey:@"reposts"]  objectForKey:@"user_reposted"]boolValue] == NO)  ? (self.canRepost=YES) : (self.canRepost=NO);
        
        
        self.postID  = [responseObject objectForKey:@"id"];
        self.fromID  = [[responseObject objectForKey:@"from_id"]  stringValue];
        self.ownerID = [[responseObject objectForKey:@"owner_id"] stringValue];
        
        
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
                                
                                if ([[dict objectForKey:@"type"]  isEqual: @"link"]) {
                                    ASLink* link = [[ASLink alloc] initWithServerResponse:dict];
                                    [self.attachments addObject:link];
                                }
                                
                                
                                if ([[dict objectForKey:@"type"]  isEqual: @"audio"]) {
                                    ASAudio* audio = [[ASAudio alloc] initWithServerResponse:dict];
                                    [self.attachments addObject:audio];
                                }
                       }
                 }

     // если attachment == nil , смотрим , может быть он находиться в репосте
        
     if (attachmentsDict == nil) {

          attachmentsDict = [[responseObject objectForKey:@"copy_history"] firstObject];
         
            if (![attachmentsDict isEqual:nil]) {
                
                for (NSDictionary* dict in [attachmentsDict objectForKey:@"attachments"]) {
                    
                    self.fromID  = [[attachmentsDict objectForKey:@"from_id"]  stringValue];
                    self.ownerID = [[attachmentsDict objectForKey:@"owner_id"] stringValue];
                    self.text    = [attachmentsDict objectForKey:@"text"];
                    
                    if ([[dict objectForKey:@"type"]  isEqual: @"photo"]) {
                        ASPhoto* photo = [[ASPhoto alloc] initFromResponseWallGet:dict];
                        [self.attachments addObject:photo];
                    }
                    
                    if ([[dict objectForKey:@"type"]  isEqual: @"link"]) {
                        ASLink* link = [[ASLink alloc] initWithServerResponse:dict];
                        [self.attachments addObject:link];
                    }
                    
                    if ([[dict objectForKey:@"type"]  isEqual: @"audio"]) {
                        ASAudio* audio = [[ASAudio alloc] initWithServerResponse:dict];
                        [self.attachments addObject:audio];
                    }
     
                    
                }
                
            }
           
        }
  
        
        if (!self.type) {
            self.type = [responseObject objectForKey:@"post_type"];
        }
        
    }
 
    return self;
    
}



@end
