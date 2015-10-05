//
//  ASLink.m
//  HW_46_47
//
//  Created by MD on 05.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASLink.h"

@implementation ASLink


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        /*
         @property (strong, nonatomic) NSString* urlString;
         @property (strong, nonatomic) NSString* title;
        */
        self.urlString = [[responseObject objectForKey:@"link"] objectForKey:@"url"];
        self.title     = [[responseObject objectForKey:@"link"] objectForKey:@"title"];
    }
    return self;
    
}


@end
