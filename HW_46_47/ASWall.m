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
                        
                        
                      }
                 }
       //////
        
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
                }
                
            }
           
        }
  
        
        if (!self.type) {
            self.type = [responseObject objectForKey:@"post_type"];
        }
        
    }
 
    return self;
}



/*  ---- // SIMPLE ATTACHMENT // -----
 
     {
     attachments =     (
             {
             photo =             {
             "access_key" = c6326c20fa03f7735b;
             "album_id" = "-7";
             date = 1444041297;
             height = 640;
             id = 381842436;
             "owner_id" = 201621080;
             "photo_130" = "https://pp.vk.me/c623627/v623627080/4cfb1/3JVJozQqgE8.jpg";
             "photo_604" = "https://pp.vk.me/c623627/v623627080/4cfb2/akCd_3wiBXI.jpg";
             "photo_75" = "https://pp.vk.me/c623627/v623627080/4cfb0/uq_XUKGIj0Q.jpg";
             "photo_807" = "https://pp.vk.me/c623627/v623627080/4cfb3/u8rMYE6h6JQ.jpg";
             "post_id" = 773;
             text = "";
             width = 640;
             };
             type = photo;
             }
             );
     "can_delete" = 1;
     "can_edit" = 1;
     "can_pin" = 1;
     comments =     {
     "can_post" = 1;
     count = 0;
     };
     date = 1444041300;
     "from_id" = 201621080;
     id = 773;
     likes =     {
     "can_like" = 1;
     "can_publish" = 0;
     count = 0;
     "user_likes" = 0;
     };
     "owner_id" = 201621080;
     "post_source" =     {
     type = vk;
     };
     "post_type" = post;
     reposts =     {
     count = 0;
     "user_reposted" = 0;
     };
     text = "";
     }
 
 
*/

/*
-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
 
    self = [super init];
    if (self) {
 
        self.type = [[responseObject objectForKey:@"attachment"] objectForKey:@"type"];
 
        if (!self.type) {
            self.type = [responseObject objectForKey:@"post_type"];
        }
 
 
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date   = [dateFormater stringFromDate:dateTime];
        self.date        = date;
        self.text        = [responseObject objectForKey:@"text"];
 
        self.comments = [[[responseObject objectForKey:@"comments"] objectForKey:@"count"] stringValue];
        self.likes    = [[[responseObject objectForKey:@"likes"]    objectForKey:@"count"] stringValue];
        self.reposts  = [[[responseObject objectForKey:@"reposts"]  objectForKey:@"count"] stringValue];
        
        
        
        if ([self.type isEqualToString:@"graffiti"]) {
            
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"graffiti"] objectForKey:@"src_big"];
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
        }
        
        
        if ([self.type isEqualToString:@"photo"]) {
            
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"photo"] objectForKey:@"src_big"];
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
        }
        
        
        if ([self.type isEqualToString:@"video"]) {
            
            self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"video"] objectForKey:@"title"];
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"video"] objectForKey:@"image_big"];
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
            
        }
        
        
        if ([self.type isEqualToString:@"link"]) {
            
            //self.text  = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"description"];
            //self.text2 = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"url"];
            self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"title"];
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"image_src"];
            
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
        }
        
        
        if ([self.type isEqualToString:@"doc"]) {
            // NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"doc" ]objectForKey:@"url"];
            // self.urlLink = [NSURL URLWithString:urlString];
        }
        
        
        if ([self.type isEqualToString:@"album"]) {
            
            self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"album"] objectForKey:@"description"];
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"album"] objectForKey:@"image_src"];
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
            
        }
        
    }
    
    return self;
    
}*/


@end
