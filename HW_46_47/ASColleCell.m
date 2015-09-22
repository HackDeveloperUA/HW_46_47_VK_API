//
//  ASColleCell.m
//  HW_46_47
//
//  Created by MD on 21.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASColleCell.h"

@implementation ASColleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) superReloadData:(NSArray*) arrayPath {
    
    [self.collectionView reloadData];
    //[self.collectionView insertItemsAtIndexPaths:arrayPath];
    //[self.collectionView.collectionViewLayout invalidateLayout];
    
    
}

@end
