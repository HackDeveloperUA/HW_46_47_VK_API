//
//  ASPhoto.m
//  HW_46_47
//
//  Created by MD on 19.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASPhoto.h"

@implementation ASPhoto

-(void) description {
    
    NSLog(@"owner_id = %@",self.owner_id);
    NSLog(@"postID = %@",self.postID);

    NSLog(@"albumID = %@",self.albumID);
    NSLog(@"date = %@",self.date);
    NSLog(@"commentsCount = %@",self.commentsCount);
    NSLog(@"likesCount = %@",self.likesCount);
    
    NSLog(@"height = %f",self.height);
    NSLog(@"width = %f",self.width);
    
    NSLog(@"photo_75URL = %@",self.photo_75URL);
    NSLog(@"photo_130URL = %@",self.photo_130URL);
    NSLog(@"photo_604URL = %@",self.photo_604URL);
    
    NSLog(@"photo_807URL = %@",self.photo_807URL);
    NSLog(@"photo_1280URL = %@",self.photo_1280URL);
    NSLog(@"----------------\n");

}
-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        
 
      self.owner_id = [[responseObject objectForKey:@"owner_id"] stringValue];
      self.postID   = [[responseObject objectForKey:@"post_id"]  stringValue];
      self.albumID  = [responseObject  objectForKey:@"album_id"];
        
      self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[responseObject objectForKey:@"date"]];
        
        
      self.commentsCount = [[responseObject objectForKey:@"comments"] objectForKey:@"count"];
      self.likesCount    = [[responseObject objectForKey:@"likes"]    objectForKey:@"count"];
       
      self.canComment    = [[responseObject objectForKey:@"can_comment"] boolValue];
        
        
      self.height = [[responseObject objectForKey:@"height"] integerValue];
      self.width  = [[responseObject objectForKey:@"width"]  integerValue];
        
        if (self.width == 0 || self.width == NULL) {
            self.width = 304;
            self.height = 304;
        }
        
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
        

        
        NSDictionary* dict = [responseObject objectForKey:@"photo"];
        
        self.owner_id = [[dict objectForKey:@"owner_id"] stringValue];
        self.albumID  = [dict  objectForKey:@"album_id"];
        
        self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[dict objectForKey:@"date"]];
        
        self.height = [[dict objectForKey:@"height"] integerValue];
        self.width  = [[dict objectForKey:@"width"]  integerValue];
        
        // Заруб
        if (self.width == 0 || self.width == NULL) {
            self.width = 304;
            self.height = 304;
        }
        
        
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
