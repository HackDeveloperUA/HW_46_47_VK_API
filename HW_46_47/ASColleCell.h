//
//  ASColleCell.h
//  HW_46_47
//
//  Created by MD on 21.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASColleCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
-(void) superReloadData:(NSArray*) arrayPath;

@end
