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


-(instancetype) initFromResponseWallGet:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        /*
         photo =     {
             "access_key" = 516e727c7e75ab232c;
             "album_id" = "-8";
             date = 1443207639;
             height = 960;
             id = 383169142;
        ->// "owner_id" = "-58860049";
                 "photo_1280" = "https://pp.vk.me/c625227/v625227028/4a947/84hApk03fFA.jpg";
                 "photo_130" = "https://pp.vk.me/c625227/v625227028/4a944/GzxIazTxwq4.jpg";
                 "photo_604" = "https://pp.vk.me/c625227/v625227028/4a945/XympqwtaL5c.jpg";
                 "photo_75" = "https://pp.vk.me/c625227/v625227028/4a943/72iuFwPJHdI.jpg";
                 "photo_807" = "https://pp.vk.me/c625227/v625227028/4a946/FQgt8T30e_c.jpg";
             text = "";
             "user_id" = 32063028;
             width = 1280;
         };
         type = photo;
         */
        
        NSDictionary* dict = [responseObject objectForKey:@"photo"];
        
        self.owner_id = [[dict objectForKey:@"owner_id"] stringValue];
        self.albumID  = [dict  objectForKey:@"album_id"];
        
        self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[dict objectForKey:@"date"]];
        
        self.height = [[dict objectForKey:@"height"] integerValue];
        self.width  = [[dict objectForKey:@"width"]  integerValue];
        
        self.photo_75URL   = [NSURL URLWithString:[dict objectForKey:@"photo_75"]];
        self.photo_130URL  = [NSURL URLWithString:[dict objectForKey:@"photo_130"]];
        self.photo_604URL  = [NSURL URLWithString:[dict objectForKey:@"photo_604"]];
        self.photo_807URL  = [NSURL URLWithString:[dict objectForKey:@"photo_807"]];
        self.photo_1280URL = [NSURL URLWithString:[dict objectForKey:@"photo_1280"]];
        
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
