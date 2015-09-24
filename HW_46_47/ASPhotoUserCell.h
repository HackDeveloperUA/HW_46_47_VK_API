//
//  ASPhotoUserCell.h
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASPhotoUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *numberPhotoButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionUserCell;

-(void) superReloadDataWithPath:(NSArray*) arrayPath;
-(void) simpleReloadDataWithPath;
+(void) reloadDataWithCollectionViewCell:(UICollectionView*) collectionView;
@end
