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
