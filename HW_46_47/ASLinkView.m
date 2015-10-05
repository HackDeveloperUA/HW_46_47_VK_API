//
//  ASLinkView.m
//  HW_46_47
//
//  Created by MD on 05.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASLinkView.h"

@implementation ASLinkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"initWithFrame");
        
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"ASLinkXib" owner:self options:nil];
        UIView* parentView = [xib objectAtIndex:0];
        
        parentView.frame = frame;

        [self addSubview:parentView];
        
        
    }
    return self;
}



- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"init");
      //  self.labelTitle.text = @"dd";
      // self.labelURL.text = @"dd";;
      //  [self.openURLButton setTitle:@"f" forState:UIControlStateNormal];

        
    }
    return self;
}
@end