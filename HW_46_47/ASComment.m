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
        
        /*
         
         {
         id: 116,
         from_id: 201621080,
         can_edit: 1,
         date: 1443806689,
         text: 'first comment',
         likes: {
         count: 0,
         user_likes: 0,
         can_like: 1

        */
        
        
        /*
        
         {
         date = 1443707501;
         "from_id" = 135781463;
         id = 78923;
         likes =                 {
         "can_like" = 1;
         count = 0;
         "user_likes" = 0;
         };
         text = "\U041f\U043e\U0437\U0434\U0440\U0430\U0432\U043b\U044f\U044e! \U0421\U043f\U0430\U0441\U0438\U0431\U043e)";
         },
        */
        self.text = [responseObject objectForKey:@"text"];
        
       
        self.likes     = [[[responseObject objectForKey:@"likes"]    objectForKey:@"count"] stringValue];
        self.canLike   = [[[responseObject objectForKey:@"likes"]    objectForKey:@"can_like"]boolValue];
        
        
        self.postID  = [responseObject objectForKey:@"id"];
        self.fromID  = [[responseObject objectForKey:@"from_id"]  stringValue];
        //self.ownerID = [[responseObject objectForKey:@"owner_id"] stringValue];
        
        
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
           // self.type = [responseObject objectForKey:@"post_type"];
           self.type =  @"comment";
        }
        
    }
    
    return self;
}

-(void) description {
    
    
    /*
    @property (strong, nonatomic) NSString* type;
    @property (strong, nonatomic) NSString* postID;
    
    @property (strong, nonatomic) NSString* text;
    @property (strong, nonatomic) NSString* date;
    
    
    @property (strong, nonatomic) NSString* comments;
    @property (strong, nonatomic) NSString* likes;
    @property (strong, nonatomic) NSString* reposts;
    
    
    @property (assign, nonatomic) BOOL canPost;
    @property (assign, nonatomic) BOOL canLike;
    @property (assign, nonatomic) BOOL canRepost;
    
    
    
    
    @property (strong, nonatomic) NSString* fromID;
    @property (strong, nonatomic) NSString* ownerID;
    
    
    @property (strong, nonatomic) NSString* fullName;
    @property (strong, nonatomic) NSURL*    urlPhoto;
    
    @property (strong, nonatomic) NSMutableArray* attachments;
    
    
    @property (strong, nonatomic) ASUser* user;
    @property (strong, nonatomic) ASGroup* group;
    */
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
