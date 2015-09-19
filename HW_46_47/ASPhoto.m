//
//  ASPhoto.m
//  HW_46_47
//
//  Created by MD on 19.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASPhoto.h"

@implementation ASPhoto


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        /*
             {
            // "album_id" = "-7";
            // "can_comment" = 1;
           //  comments =                 {
             count = 0;
             };
         //    date = 1442581644;
         //    height = 647;
             id = 379567715;
         //    likes =                 {
             count = 1;
             "user_likes" = 0;
             };
         //    "owner_id" = 201621080;
             "photo_1280" = "https://pp.vk.me/c629412/v629412080/13974/inERWv43MMQ.jpg";
             "photo_130" = "https://pp.vk.me/c629412/v629412080/13971/JlzMbxnqZuY.jpg";
             "photo_604" = "https://pp.vk.me/c629412/v629412080/13972/8YfKofrFifQ.jpg";
             "photo_75" = "https://pp.vk.me/c629412/v629412080/13970/n_rVh3EnaVE.jpg";
             "photo_807" = "https://pp.vk.me/c629412/v629412080/13973/MB0E8onOElA.jpg";
             "post_id" = 734;
             tags =                 {
             count = 0;
             };
             text = "";
           //  width = 818;
             },
        */
        
 
      self.owner_id = [[responseObject objectForKey:@"owner_id"] stringValue];
      self.postID   = [[responseObject objectForKey:@"post_id"]  stringValue];
      self.albumID  = [responseObject  objectForKey:@"album_id"];
        
      self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[responseObject objectForKey:@"date"]];
        
        
      self.commentsCount = [[responseObject objectForKey:@"comments"] objectForKey:@"count"];
      self.likesCount    = [[responseObject objectForKey:@"likes"]    objectForKey:@"count"];
       
      self.canComment    = [[responseObject objectForKey:@"can_comment"] boolValue];
        
        
      self.height = [[responseObject objectForKey:@"height"] integerValue];
      self.width  = [[responseObject objectForKey:@"width"]  integerValue];
        
      self.photo_75URL   = [NSURL URLWithString:[responseObject objectForKey:@"photo_75"]];
      self.photo_130URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_130"]];
      self.photo_604URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_604"]];
      self.photo_807URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_807"]];
      self.photo_1280URL = [NSURL URLWithString:[responseObject objectForKey:@"photo_1280"]];

        
        
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


@end
