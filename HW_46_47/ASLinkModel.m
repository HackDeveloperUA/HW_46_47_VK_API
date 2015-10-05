//
//  ASLinkModel.m
//  HW_46_47
//
//  Created by MD on 05.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASLinkModel.h"

@implementation ASLinkModel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"initWithFrame");
        
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"LinkXib" owner:self options:nil];
        UIView* uuview = [xib objectAtIndex:0];
        
        uuview.frame = frame;
        
        [self addSubview:uuview];
        //self.frame = frame;
        //self.backgroundColor = [UIColor  redColor];
        // [self addSubview:myView];
        
    }
    return self;
}



- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"init");
    }
    return self;
}

@end
