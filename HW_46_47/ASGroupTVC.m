 //
//  ASGroupTVC.m
//  HW_46_47
//
//  Created by MD on 10.09.15.
//  Copyright (c) 2015 MD. All rights reserved.


#import "ASGroupTVC.h"

// Model
#import "ASUser.h"
#import "ASWall.h"
#import "ASFriend.h"
#import "ASGroup.h"
#import "ASPhoto.h"
#import "ASLink.h"
#import "ASAudio.h"

// Collection View
#import "ASInfoMemberCollectionCell.h"
#import "ASInfoMemberFlowLayout.h"

//#import "ASPhotosCollectionCell.h"
#import "ASPhotosFlowLayout.h"

// Custom Cell
#import "ASMainGroupCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"
#import "ASWallAttachmentCell.h"
#import "ASWallTextCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

// HEX
#import "UIColor+HEX.h"

// Controllers
#import "ASImageViewGallery.h"
#import "ASDetailTVC.h"
#import "ASUserTVC.h"
#import "ASFriendTVC.h"
#import "ASWritePostTVC.h"



static NSString* identifierMainGroup     = @"ASMainGroupCell";
static NSString* identifierSegmentPost   = @"ASSegmentPost";
static NSString* identifierGray          = @"ASGrayCell";
static NSString* identifierWall          = @"ASWallCell";
static NSString* identifierWallTextOnly  = @"ASWallTextCell";


static NSInteger allPostWallFilter   = 0;
static NSInteger ownerPostWallFilter = 1;



static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    
    size.width *= height / size.height;
    size.height = height;
    
    return size;
}



@interface ASGroupTVC () <UITableViewDataSource,      UITableViewDelegate ,
                          UICollectionViewDataSource, UICollectionViewDelegate,
                          UIScrollViewDelegate>



@property (strong, nonatomic) NSString* groupID;
@property (strong, nonatomic) NSString* wallFilter;

@property (strong,nonatomic)  ASGroup *currentGroup;
@property (strong, nonatomic) NSMutableArray* arrrayWall;
@property (strong, nonatomic) NSArray* arrayDataCountres;

@property (assign,nonatomic)  BOOL loadingData;
@property (assign, nonatomic) BOOL firstTimeAppear;

@property (strong,nonatomic)  UIRefreshControl *refresh;

@property (strong,nonatomic)  NSMutableArray *imageViewSize;
@property (assign, nonatomic) NSInteger indexPathWallForRepost;
@end



@implementation ASGroupTVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //58860049 10639516,
    // california 32422548
    // cp 33393308
    
    if ([self.superGroupID length]<1) {
        self.superGroupID = @"32422548";
    }
    
    self.wallFilter = @"all";

    self.currentGroup = [[ASGroup alloc] init];
    
    
    self.arrrayWall     = [NSMutableArray array];
    self.imageViewSize  = [NSMutableArray array];

    self.loadingData     = YES;
    self.firstTimeAppear = YES;

    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshWall:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
    

    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:1.000];
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[ASServerManager sharedManager] authorizeUser:^(ASUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
         
            [self getInfoFromServer];
            [self getWallFromServer];
      
        }];
        
    }

}

#pragma mark - GET-InfoServer

-(void)  getWallFromServer {
    
    //58860049 iosdevcourse clfrn


    
    [[ASServerManager sharedManager] getWall:self.superGroupID
                                          withDomain:@""
                                          withFilter:self.wallFilter
                                          withOffset:[self.arrrayWall count]
                                           typeOwner:@"group"
                                               count:20
                                           onSuccess:^(NSArray *posts) {
                                               
                      
               if ([posts count] > 0) {
                 
                   

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            
                   

                   NSMutableArray* arrPath = [NSMutableArray array];

                   for (NSInteger i= [self.arrrayWall count]; i<=[posts count]+[self.arrrayWall count]-1; i++) {
                
                       [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                   }
                   
                   
                    [self.arrrayWall addObjectsFromArray:posts];
               
                   
                    for (int i = (int)[self.arrrayWall count] - (int)[posts count]; i < [self.arrrayWall count]; i++) {
        
               
                   CGSize newSize = [self setFramesToImageViews:nil imageFrames:[[self.arrrayWall objectAtIndex:i] attachments]
                               toFitSize:CGSizeMake(self.view.frame.size.width-16, self.view.frame.size.width-16)];
                     
                        
                        NSLog(@"111 newSize = %@",NSStringFromCGSize(newSize));
                        [self.imageViewSize addObject:[NSNumber numberWithFloat:roundf(newSize.height)]];

                   }
                    
                       

                   dispatch_sync(dispatch_get_main_queue(), ^{

                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:arrPath withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];

          
                       
                    self.loadingData = NO;
                       
                   });
                       
                   });

               }
    
                                               
                                           } onFailure:^(NSError *error, NSInteger statusCode) {
                                               
                                           }];
    
    
    
}



-(void)  getInfoFromServer {

    //58860049 iosdevcourse clfrn
   // [[ASServerManager sharedManager] getGroupInfoID:@"iosdevcourse" onSuccess:^(ASGroup *group) {
   
    [[ASServerManager sharedManager] getGroupInfoID:self.superGroupID onSuccess:^(ASGroup *group) {
    
            self.arrayDataCountres = [NSArray array];
            self.navigationItem.title = group.fullName;
        
            self.groupID = group.groupID;
            self.currentGroup = group;
        
            _arrayDataCountres = @[_currentGroup.members, _currentGroup.topics, _currentGroup.docs, _currentGroup.photos, _currentGroup.videos, _currentGroup.albums];
        
            [self.tableView reloadData];
            self.loadingData = NO;
        
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];

}



#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    
    if ([UITableView isSubclassOfClass:[UIScrollView class]]) {
        
        UITableView* tableView = (UITableView*)scrollView;

        if (tableView.tag == 300) {
           
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if (!self.loadingData)
                {
                    self.loadingData = YES;
                    NSLog(@"Подгружаю !");
                    
                    [self getWallFromServer];
                }
            }
            
        }
    }
    
    
    
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ASMainGroupCell class]]) {
      
       return  (208+[ASMainGroupCell heightForText:self.currentGroup.status])-21;
       
    }
    
    if ([cell isKindOfClass:[ASSegmentPost class]]) {
        return 44.f;
    }
    
    if ([cell isKindOfClass:[ASGrayCell class]]) {
        return 16.f;
    }
    

    // Заруб
    
    if ([cell isKindOfClass:[ASWallAttachmentCell class]]) {


        ASWall* wall = self.arrrayWall[indexPath.row];
        float height = 0;

        
        height = height + [[self.imageViewSize objectAtIndex:indexPath.row]floatValue];
        
        NSLog(@"height = %f",height);
        
        return 67 + 8 + height + [ASWallAttachmentCell heightForTextWithPostModel:wall andWidthTextCell:self.view.frame.size.width-16] + 8 + 15 + 33;
       
    }
    
    
    if ([cell isKindOfClass:[ASWallTextCell class]]) {
    
        ASWall* wall = self.arrrayWall[indexPath.row];

        static float heightPhoto  = 60.f;
        static float heightShared = 33.f;
               float heightText   = 36.f;
        
        static float offsetBeforePhoto                = 8.f;
        static float offsetBetweenPhotoAndText        = 9.f;
        static float offsetBetweenTextAndShared       = 20.f;
        static float offsetAfterShared                = 9.f;
    
        heightText = [ASWallTextCell heightForAttachmentsWithPostModel:wall andWidthTextCell:self.view.frame.size.width-16];
        return (offsetBeforePhoto + heightPhoto) + (offsetBetweenPhotoAndText + heightText) + (offsetBetweenTextAndShared + heightShared + offsetAfterShared);
    
    }
    
    
    return 10.f;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }
    
    if (section == 1) {
        return [self.arrrayWall count];
    }
    
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        
        
        
        if (indexPath.row == 0) {
            
            #pragma mark ASMainGroupCell
            
            ASMainGroupCell* cell = (ASMainGroupCell*)[tableView dequeueReusableCellWithIdentifier:identifierMainGroup];
            
            if (!cell) {
              cell = [[ASMainGroupCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identifierMainGroup];
            }
            
            __weak ASMainGroupCell *weakCell = cell;
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.currentGroup.mainCommunityImageURL];

            
            [cell.mainImageGroup setImageWithURLRequest:request
                                       placeholderImage:nil
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    
                                                    weakCell.mainImageGroup.image = image;
                                                    
                                                    CALayer *imageLayer = weakCell.mainImageGroup.layer;
                                                    [imageLayer setCornerRadius:40];
                                                    [imageLayer setBorderWidth:3];
                                                    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
                                                    [imageLayer setMasksToBounds:YES];
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                    
                                                }];
            

            
            
            cell.fullNameGroup.text = self.currentGroup.fullName;
            cell.typeGroup.text     = self.currentGroup.typeCommunity;
            cell.statusGroup.text   = self.currentGroup.status;
            
            //@"Join community" : @"You are a member"
            [cell.followButton addTarget:self
                                action:@selector(followButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            
            if (self.currentGroup.isMember == YES) {
                [cell.followButton setTitle:@"You are a member" forState: UIControlStateNormal];
                cell.followButton.backgroundColor = [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:1.000];
            } else {
                [cell.followButton setTitle:@"Join community" forState: UIControlStateNormal];
                [cell.followButton setBackgroundColor:[UIColor colorWithRed:1 green:0.176 blue:0.333 alpha:1]];
            }
            
            cell.collectionView.collectionViewLayout = (UICollectionViewLayout*)[ASInfoMemberFlowLayout initFlowLayout];
            return cell;
        }
        
        
        
        
        
        
        if (indexPath.row == 1) {

            #pragma mark ASGrayCell

            ASGrayCell* cell = (ASGrayCell*)[tableView dequeueReusableCellWithIdentifier:identifierGray];
            
            if (!cell) {
            cell = [[ASGrayCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifierGray];
            }
            return cell;
         }
        
        
        
        
        if (indexPath.row == 2) {

            #pragma mark ASSegmentPost

            ASSegmentPost* cell = (ASSegmentPost*)[tableView dequeueReusableCellWithIdentifier:identifierSegmentPost];
            
            if (!cell) {
               cell = [[ASSegmentPost alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSegmentPost];
            }
        
                if ([self.wallFilter isEqualToString:@"all"]) {
                    cell.postSegmentControl.selectedSegmentIndex = allPostWallFilter;
                
                } else if ([self.wallFilter isEqualToString:@"owner"]) {
                    cell.postSegmentControl.selectedSegmentIndex = ownerPostWallFilter;
                  }
            
            
            [cell.postSegmentControl addTarget:self
                                        action:@selector(changeWallFilter:)
                               forControlEvents: UIControlEventValueChanged];
            
            [cell.createPost addTarget:self
                                action:@selector(createPostAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    
    
    
    if (indexPath.section == 1) {

        ASWall* wall = self.arrrayWall[indexPath.row];

        
        if ([wall.attachments count] > 0) {
            
        
            #pragma mark ASWallAttachmentCell

            ASWallAttachmentCell* cell = (ASWallAttachmentCell*)[tableView dequeueReusableCellWithIdentifier:identifierWall];
            
            if (!cell) {
                cell = [[ASWallAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifierWall];
            }
          
        
            if ([cell viewWithTag:11]) [[cell viewWithTag:11] removeFromSuperview];

            if (wall.user) {
                cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
                [cell.ownerPhoto setImageWithURL:wall.user.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            } else if (wall.group) {
                
                cell.fullName.text = wall.group.fullName;
                [cell.ownerPhoto setImageWithURL:wall.group.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            }
            
            cell.textPost.text = wall.text;
            cell.date.text     = wall.date;
            
            
            CGPoint point = CGPointZero;
       
            float sizeText = [self heightLabelOfTextForString:cell.textPost.text fontSize:14.f widthLabel:CGRectGetWidth(self.view.bounds)-2*8];
            point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame),sizeText+60+16);

            
            float offSet = 8.f;
            CGSize sizeAttachment = CGSizeMake(CGRectGetWidth(self.view.bounds)-2*offSet, CGRectGetWidth(self.view.bounds)-2*offSet);
           
            ASImageViewGallery *galery = [[ASImageViewGallery alloc]initWithImageArray:wall.attachments startPoint:point withSizeView:sizeAttachment];
            galery.tag = 11;
            [cell addSubview:galery];
            
     
            cell.commentLabel.text = ([wall.comments length]>3) ? ([NSString stringWithFormat:@"%@k",[wall.comments substringToIndex:1]]) : (wall.comments);
            cell.likeLabel.text    = ([wall.likes length]>3)    ? ([NSString stringWithFormat:@"%@k",[wall.likes substringToIndex:1]])    : (wall.likes);
            cell.repostLabel.text  = ([wall.reposts length]>3)  ? ([NSString stringWithFormat:@"%@k",[wall.reposts substringToIndex:1]])  : (wall.reposts);

    
            
            [cell.likeButton     addTarget:self action:@selector(addLikeOnPost:) forControlEvents:UIControlEventTouchUpInside];
             cell.likeButton.tag = indexPath.row;
           
            [cell.repostButton     addTarget:self action:@selector(addRepost:) forControlEvents:UIControlEventTouchUpInside];
            cell.repostButton.tag = indexPath.row;
            
            [cell.commentButton addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentButton.tag = indexPath.row;

            
            [cell.openOwnerPage addTarget:self action:@selector(openOwnerPageAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.openOwnerPage.tag = indexPath.row;

            
            
            if (wall.canLike == NO) {
               cell.likeView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
            } else {
                cell.likeView.backgroundColor = [UIColor clearColor];
                  }
            
            
           
            if (wall.canRepost == NO) {
                cell.repostView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
            } else {
                cell.repostView.backgroundColor = [UIColor clearColor];
            }
            
        
            return cell;
      
            
        } else {
            
            #pragma mark ASWallTextCell

            ASWallTextCell* cell = (ASWallTextCell*)[tableView dequeueReusableCellWithIdentifier:identifierWallTextOnly];
            
            if (!cell) {
                cell = [[ASWallTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identifierWallTextOnly];
            }
          
            if (wall.user) {
                cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
            
            } else if (wall.group) {
                
                cell.fullName.text = wall.group.fullName;
            }
            cell.textPost.text = wall.text;
            cell.date.text     = wall.date;

            
            
            cell.commentLabel.text = ([wall.comments length]>3) ? ([NSString stringWithFormat:@"%@k",[wall.comments substringToIndex:1]]) : (wall.comments);
            cell.likeLabel.text    = ([wall.likes length]>3)    ? ([NSString stringWithFormat:@"%@k",[wall.likes substringToIndex:1]])    : (wall.likes);
            cell.repostLabel.text  = ([wall.reposts length]>3)  ? ([NSString stringWithFormat:@"%@k",[wall.reposts substringToIndex:1]])  : (wall.reposts);
            
            [cell.openOwnerPage addTarget:self action:@selector(openOwnerPageAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.openOwnerPage.tag = indexPath.row;

            [cell.likeButton     addTarget:self action:@selector(addLikeOnPost:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeButton.tag = indexPath.row;
            
            if (wall.canLike == NO) {
                cell.likeView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
            } else {
                cell.likeView.backgroundColor = [UIColor clearColor];
            }
            
            
            [cell.repostButton     addTarget:self action:@selector(addRepost:) forControlEvents:UIControlEventTouchUpInside];
            cell.repostButton.tag = indexPath.row;
            
            if (wall.canRepost == NO) {
                cell.repostView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
            } else {
                cell.repostView.backgroundColor = [UIColor clearColor];
            }
            
            [cell.commentButton addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentButton.tag = indexPath.row;

        
            __weak ASWallTextCell *weakCell = cell;
            
            NSURL* url = [[NSURL alloc] init];
            if (wall.user.photo_100URL) {
                url = wall.user.photo_100URL;
            } else {
                url = wall.group.photo_100URL;
            }
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];

            [cell.ownerPhoto setImageWithURLRequest:request
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                
                                                weakCell.ownerPhoto.image = image;
                                                
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                
                                            }];
            
             return cell;

        }
        
    
        
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* arrayCounteres = @[@"members", @"topics", @"docs", @"photos", @"videos", @"albums"];
 
    static NSString *identifier = @"ASInfoMemberCollectionCell";
    ASInfoMemberCollectionCell *cell = (ASInfoMemberCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.firstLabel.text = _arrayDataCountres[indexPath.row];
    cell.seconLabel.text =  arrayCounteres[indexPath.row];
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ASInfoMemberCollectionCell";
    ASInfoMemberCollectionCell *cell = (ASInfoMemberCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    
    if ([cell.seconLabel.text isEqualToString:@"members"]) {
        
    }
    else
      if ([cell.seconLabel.text isEqualToString:@"topics"]) {
       
          
    }
    else
      if ([cell.seconLabel.text isEqualToString:@"docs"]) {
         
          
    } else
        if ([cell.seconLabel.text isEqualToString:@"photos"]) {
           
            
    } else
        if ([cell.seconLabel.text isEqualToString:@"videos"]) {
            
            
    } else
        if ([cell.seconLabel.text isEqualToString:@"albums"]) {
                
        }
}




#pragma mark - Action

- (void)changeWallFilter:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    NSLog(@"selectedSegment = %d",selectedSegment);
    
    if (selectedSegment == allPostWallFilter) {
        self.wallFilter = @"all";
        sender.selectedSegmentIndex = 0;
    
    } else if (selectedSegment == ownerPostWallFilter) {
        self.wallFilter = @"owner";
        sender.selectedSegmentIndex = 1;
    }
    
    [self updateOnlyWall:sender];
}




-(void) createPostAction:(UIButton*) sender {

    
    UIStoryboard*   storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASWritePostTVC* writeVC = (ASWritePostTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASWritePostTVC"];
    
    
    NSString* ownerGroupID = self.currentGroup.groupID;
    if (![ownerGroupID hasPrefix:@"-"]) {
            ownerGroupID = [@"-" stringByAppendingString:ownerGroupID];
        }
        
     writeVC.currentOwnerID = ownerGroupID;
    
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:writeVC];
    
    
    [self presentViewController:navController animated:YES completion:nil];


}



-(void) followButtonAction:(UIButton*) sender {
    
    
    if (self.currentGroup.isMember == YES) {
        [[ASServerManager sharedManager] leaveFromGroup:self.currentGroup.groupID
                                              onSuccess:^(NSDictionary *result) {
                                               
                             
                                          int success = [[result objectForKey:@"response"] integerValue];
                                         
                                          if (success == 1) {
                                              self.currentGroup.isMember = NO;
                                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                              
                                              [self.tableView beginUpdates];
                                              [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                              [self.tableView endUpdates];
                                          }
                                          
                                       
   
                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  
                                              }];
    } else {
        
        [[ASServerManager sharedManager] joinToGroup:self.currentGroup.groupID
                                           onSuccess:^(NSDictionary *result) {
                                           
                                   int success = [[result objectForKey:@"response"] integerValue];
                                   
                                   if (success == 1) {
                                       self.currentGroup.isMember = YES;
                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

                               [self.tableView beginUpdates];
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                               [self.tableView endUpdates];
                                   }
                                               
                                           }
                                           onFailure:^(NSError *error, NSInteger statusCode) {
                                               
                                           }];
        
    }
    
    
}



-(void) addLikeOnPost:(UIButton*) sender {
    
    ASWall* wall = self.arrrayWall[sender.tag];
    
 
    if (wall.canLike) {
    
        [[ASServerManager sharedManager] postAddLikeOnWall:self.superGroupID inPost:wall.postID type:wall.type typeOwner:@"group" onSuccess:^(NSDictionary *result) {
           
            NSDictionary* response = [result objectForKey:@"response"];
            
            wall.canLike = NO;
            wall.likes   = [[response objectForKey:@"likes"] stringValue];
            [self.tableView reloadData];
            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            
        }];
        
  
    } else {
    
    
        [[ASServerManager sharedManager] postDeleteLikeOnWall:self.superGroupID inPost:wall.postID type:wall.type typeOwner:@"group" onSuccess:^(NSDictionary *result) {
            
            NSDictionary* response = [result objectForKey:@"response"];
            
            wall.canLike = YES;
            wall.likes   = [[response objectForKey:@"likes"] stringValue];
            [self.tableView reloadData];

            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            
        }];
        
  
    }
}



-(void) addRepost:(UIButton*) sender {


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add your comment" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 12;
    
    [alert show];
    self.indexPathWallForRepost = sender.tag;
    
}


-(void) showComment:(UIButton*) sender {
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    ASDetailTVC* detailVC = (ASDetailTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASDetailTVC"];
   
    detailVC.group  = self.currentGroup;
    

    ASWall* wall = [[ASWall alloc] init];
    wall = self.arrrayWall[sender.tag];
    wall.group = self.currentGroup;
    wall.imageViewSize = [[self.imageViewSize objectAtIndex:sender.tag] floatValue];
    
    detailVC.whence = @"group";
    detailVC.wall   = wall;
    detailVC.postID = [[self.arrrayWall objectAtIndex:sender.tag] postID];
    
    [self.navigationController pushViewController:detailVC animated:YES];

    
}


- (void)refreshWall:(id)sender {
    
    if (self.loadingData != YES) {
        self.loadingData = YES;
        

            if ([self.arrrayWall count] > 0) {
                
                [self.arrrayWall removeAllObjects];
                [self.imageViewSize removeAllObjects];
                
                self.currentGroup = nil;
                
                [self getInfoFromServer];
                [self getWallFromServer];
                
                [self.refresh endRefreshing];
                [self.tableView reloadData];
              
                self.loadingData = NO;
            }
        
    }
    
}

- (void) updateOnlyWall:(id)sender {

    if (self.loadingData != YES) {
        self.loadingData = YES;
        
        
        if ([self.arrrayWall count] > 0) {
            
            [self.arrrayWall removeAllObjects];
            [self.imageViewSize removeAllObjects];
            
            [self getWallFromServer];
            [self.refresh endRefreshing];
            [self.tableView reloadData];

            self.loadingData = NO;
        }
        
    }
}


-(void) openOwnerPageAction:(UIButton*) sender {
    
    
    ASWall* wall = [[ASWall alloc] init];
    wall = self.arrrayWall[sender.tag];

    
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASUserTVC*     userVC     = (ASUserTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASUserDetailTVC"];
    
    userVC.superUserID = wall.user.userID;
    [self.navigationController pushViewController:userVC animated:YES];
  
}




#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
       
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSLog(@"username: %@", textfield.text);
            
            ASWall* wall = self.arrrayWall[self.indexPathWallForRepost];
            
            
            
            [[ASServerManager sharedManager] repostOnMyWall:wall.ownerID inPost:wall.postID withMessage:textfield.text
                                                  typeOwner:@"group"
                                                  onSuccess:^(NSDictionary *result) {
                                                      
                                                      
                                                      NSDictionary* response = [result objectForKey:@"response"];
                                                      
                                                      wall.canRepost = NO;
                                                      wall.reposts   = [[response objectForKey:@"reposts_count"] stringValue];
                                                      [self.tableView reloadData];
                                                      
                                                      self.indexPathWallForRepost = NULL;
                                                      
                                                      
                                                  } onFailure:^(NSError *error, NSInteger statusCode) {
                                                      
                                                  }];
        
        }
    }
}



#pragma mark - TextImageConfigure

- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageFrames.count;
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[ASLink class]]) {
            N--;
        }
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[ASAudio class]]) {
            N--;
        }
    }
    
    
    
    CGRect newFrames[N];
    
    float ideal_height = MAX(frameSize.height, frameSize.width) / N;
    float seq[N];
    float total_width = 0;
    
    ////
    ////
    ////
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[ASPhoto class]]) {
            ASPhoto *image = [imageFrames objectAtIndex:i];
            CGSize size = CGSizeMake(image.width, image.height);
            CGSize newSize = CGSizeResizeToHeight(size, ideal_height);
            newFrames[i] = (CGRect) {{0, 0}, newSize};
            seq[i] = newSize.width;
            total_width += seq[i];
        }
        
        
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}




- (CGRect)heightTextView:(UITextView *)view {
    
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    if (newSize.height > 200) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth),150);
    } else {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    }
    
    return newFrame;
}



- (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width {
    
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, paragraph, NSParagraphStyleAttributeName,shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes
                                        context:nil];
    
    return rect.size.height;
}






@end
