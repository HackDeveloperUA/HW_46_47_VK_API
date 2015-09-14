//
//  ASLoginVC.h
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASAccessToken;

typedef void(^ASLoginCompletionBlock)(ASAccessToken* token);

@interface ASLoginVC : UIViewController


- (id) initWithCompletionBlock:(ASLoginCompletionBlock) completionBlock;

@end
