//
//  ASInfoMemberFlowLayout.m
//  HW_46_47
//
//  Created by MD on 14.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASInfoMemberFlowLayout.h"

@implementation ASInfoMemberFlowLayout


+(UICollectionViewFlowLayout*) initFlowLayout {
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing = 10.f;
    flowLayout.minimumInteritemSpacing = 5.f;
    flowLayout.itemSize = CGSizeMake(68.f, 48.f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    return flowLayout;
}




@end
