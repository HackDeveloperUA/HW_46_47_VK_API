//
//  ASAudio.m
//  HW_46_47
//
//  Created by MD on 07.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASAudio.h"

@implementation ASAudio

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
       /*
        @property (strong, nonatomic) NSString* title;
        @property (strong, nonatomic) NSString* artist;
        
        @property (strong, nonatomic) NSURL* urlAudio;
        
        @property (strong, nonatomic) NSString* ownerId;
        @property (strong, nonatomic) NSString* date;
        
        @property (strong, nonatomic) NSString* duration;

        */
  
        /*
         {
         audio =     {
         artist = "Hank Williams Jr.";
         date = 1444199485;
         duration = 79;
         "genre_id" = 2;
         id = 402744362;
         "lyrics_id" = 8040481;
         "owner_id" = 2000309537;
         title = Canyonero;
         url = "https://psv4.vk.me/c4703/u3242868/audios/0ecb8300244c.mp3?extra=TW9H6ZdjrVLi3laCEDKqPceBV83q7gMq6Vhble6_T6ZF1pswte8KgXi_7UuIbALrzsEqk9-xUsP3Zx93Tdb4mZjRTiyfnWdgeA";
         };
         type = audio;
         }
         
         
        */
     
        NSDictionary* audioDict = [responseObject objectForKey:@"audio"];
        
        self.title = [audioDict objectForKey:@"title"];
        self.artist = [audioDict objectForKey:@"artist"];
        
        self.title = [audioDict objectForKey:@"title"];
        self.title = [audioDict objectForKey:@"title"];

        if ([audioDict objectForKey:@"url"]) {
            self.urlAudio = [NSURL URLWithString:[audioDict objectForKey:@"url"]];
        }
        
        self.ownerId = [[audioDict objectForKey:@"owner_id"] stringValue];
        
        self.duration = [self parseDataWithDateFormetter:@"mm:ss" andDate:[audioDict objectForKey:@"duration"]];
        self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[audioDict objectForKey:@"date"]];

        
        self.ID = [[audioDict objectForKey:@"id"] stringValue];
        
        
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
