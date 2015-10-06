//
//  ASGroup.m
//  HW_46_47
//
//  Created by MD on 14.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASGroup.h"

@implementation ASGroup


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        //status,activity,can_post,members_count,counters,description
        /*
         
         response =     (
         {
         activity = "\U041e\U0442\U043a\U0440\U044b\U0442\U0430\U044f \U0433\U0440\U0443\U043f\U043f\U0430";
         "can_post" = 1;
         counters =             {
         albums = 2;
         docs = 120;
         photos = 50;
         topics = 160;
         videos = 143;
         };
         description = "iOS: Swift \U0438 Objective-C";
         id = 58860049;
         "is_admin" = 0;
         "is_closed" = 0;
         "is_member" = 1;
         "members_count" = 7373;
         name = "iOS Development Course";
         "photo_100" = "https://pp.vk.me/c617418/v617418116/cf02/-aSwbdLzWQc.jpg";
         "photo_200" = "https://pp.vk.me/c617418/v617418116/cf00/bwO158JfT-U.jpg";
         "photo_50" = "https://pp.vk.me/c617418/v617418116/cf03/qs1WrpGUk3A.jpg";
         "screen_name" = iosdevcourse;
         status = "\U041a\U043e\U043f\U0438\U0440\U043e\U0432\U0430\U043d\U0438\U0435 \U043c\U0430\U0442\U0435\U0440\U0438\U0430\U043b\U043e\U0432 \U0433\U0440\U0443\U043f\U043f\U044b \U0437\U0430\U043f\U0440\U0435\U0449\U0430\U0435\U0442\U0441\U044f, \U0440\U0435\U043f\U043e\U0441\U0442\U044b \U043f\U0440\U0438\U0432\U0435\U0442\U0441\U0442\U0432\U0443\U044e\U0442\U0441\U044f, \U043f\U0438\U0440\U0430\U0442\U0441\U043a\U0438\U0435 \U0441\U0441\U044b\U043b\U043a\U0438 \U043a\U0430\U0440\U0430\U044e\U0442\U0441\U044f";
         type = group;
         }
         );
     */
        
        
        self.fullName = [responseObject objectForKey:@"name"];
        
        self.groupID              = [[responseObject objectForKey:@"id"]stringValue];
        self.members              = [[responseObject objectForKey:@"members_count"]stringValue];
        self.descriptionCommunity = [responseObject objectForKey:@"description"];

        NSArray* counteres = [responseObject objectForKey:@"counters"];
        
        if ([counteres count]>0) {
          
            self.topics  = [[[responseObject objectForKey:@"counters"] objectForKey:@"topics"] stringValue];
            self.docs    = [[[responseObject objectForKey:@"counters"] objectForKey:@"docs"]   stringValue];
            self.photos  = [[[responseObject objectForKey:@"counters"] objectForKey:@"photos"] stringValue];
            self.videos  = [[[responseObject objectForKey:@"counters"] objectForKey:@"videos"] stringValue];
            self.albums  = [[[responseObject objectForKey:@"counters"] objectForKey:@"albums"] stringValue];
        }
        
       

        if (!self.topics) {
            _topics = @"0";
        }
        if (!self.docs) {
            _docs = @"0";
        }
        if (!self.photos) {
            _photos = @"0";
        }
        if (!self.videos) {
            _videos = @"0";
        }
        if (!self.albums) {
            _albums = @"0";
        }
        
        BOOL isMember  = [[responseObject objectForKey:@"is_member"] boolValue];
        BOOL isClosed  = [[responseObject objectForKey:@"is_closed"] boolValue];
        BOOL isCanPost = [[responseObject objectForKey:@"can_post"]  boolValue];
        
        
        self.titleJoinButton = isMember ? @"Join community" : @"You are a member";
        self.typeCommunity   = isClosed ? @"Closed community" : @"Open community";
       // self.typeCommunity   = [responseObject objectForKey:@"activity"];
        self.isEnablePostButton = isCanPost;
        
        self.isMember = isMember;
        self.isClosed = isClosed;
        self.isCanPost = isCanPost;
        
       self.status    = [responseObject objectForKey:@"status"];
    

        self.photo_50URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.photo_100URL = [NSURL URLWithString:[responseObject objectForKey:@"photo_100"]];
        

        NSString* urlString = [responseObject objectForKey:@"photo_200"];
        
        if (urlString) {
            self.mainCommunityImageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
    
}
/*
 @property (strong, nonatomic) NSString* fullName;
 @property (strong, nonatomic) NSString* groupID;
 
 @property (strong, nonatomic) NSURL* mainImageURL;
 @property (strong, nonatomic) NSURL* photo_50URL;
 @property (strong, nonatomic) NSURL* photo_100URL;
 @property (strong, nonatomic) NSURL* mainCommunityImageURL;
 
 
 @property (strong, nonatomic) NSString* members;
 @property (strong, nonatomic) NSString* topics;
 @property (strong, nonatomic) NSString* docs;
 @property (strong, nonatomic) NSString* photos;
 @property (strong, nonatomic) NSString* videos;
 @property (strong, nonatomic) NSString* albums;
 
 @property (strong, nonatomic) NSString* titleJoinButton;
 @property (assign, nonatomic) BOOL      isEnablePostButton;
 @property (strong, nonatomic) NSString* typeCommunity;
 @property (strong, nonatomic) NSString* descriptionCommunity;
 @property (strong, nonatomic) NSString* status;

 
 */

-(void) description {
    
    NSLog(@"fullName %@",self.fullName);
    NSLog(@"groupID %@",self.groupID);
    
    NSLog(@"mainImageURL %@",self.mainImageURL);
    
    
    NSLog(@"photo_50URL %@",self.photo_50URL);
    
    NSLog(@"photo_100URL %@",self.photo_100URL);
    
    NSLog(@"mainCommunityImageURL %@",self.mainCommunityImageURL);
    
    NSLog(@"isEnablePostButton %hhd",self.isEnablePostButton);
    
    NSLog(@"titleJoinButton %@",self.titleJoinButton);
  
    NSLog(@"isMember %hhd",self.isMember);
    NSLog(@"isClosed %hhd",self.isClosed);
    NSLog(@"isCanPost %hhd",self.isCanPost);

}


@end
