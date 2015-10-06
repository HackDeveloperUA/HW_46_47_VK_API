//
//  ASUserDetailTVC.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUserTVC.h"

// Model
#import "ASUser.h"
#import "ASWall.h"
#import "ASFriend.h"
#import "ASGroup.h"
#import "ASPhoto.h"
#import "ASLink.h"

// Collection View
#import "ASInfoMemberCollectionCell.h"
#import "ASInfoMemberFlowLayout.h"

#import "ASCollectionPhotoCell.h"
#import "ASPhotosFlowLayout.h"

// Custom Cell
#import "ASMainUserCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"
#import "ASWallAttachmentCell.h"

#import "ASLinkView.h"
#import "testView.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

// Controller
#import "ASImageViewGallery.h"
#import "ASDetailTVC.h"
#import "ASGroupTVC.h"
#import "ASFriendTVC.h"


#import "ASLinkModel.h"


static NSString* identifierMainUser     = @"ASMainUserCell";
static NSString* identifierPhotos       = @"ASPhotoUserCell";
static NSString* identifierSegmentPost  = @"ASSegmentPost";
static NSString* identifierGray         = @"ASGrayCell";

static NSString* identifierWall         = @"ASWallCell";




static CGSize CGResizeFixHeight(CGSize size) {

    CGFloat targetHeight = 65.0f;
    CGFloat scaleFactor = targetHeight / size.height;
    //CGFloat targetWidth = size.width * scaleFactor;
    int targetWidth = size.width * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}


static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    
    size.width *= height / size.height;
    size.height = height;
    
    return size;
}

static float offset       = 8.f;

static float heightPhoto  = 60.f;
static float heightShared = 33.f;

static float offsetBeforePhoto                = 8.f;
static float offsetBetweenPhotoAndText        = 8.f;
static float offsetBetweenTextAndShared       = 16.f;
static float offsetAfterShared                = 10.f;


static NSInteger allPostWallFilter   = 0;
static NSInteger ownerPostWallFilter = 1;




@interface ASUserTVC () <UITableViewDataSource,      UITableViewDelegate,UICollectionViewDelegateFlowLayout,
                                UICollectionViewDataSource, UICollectionViewDelegate,
                                UIScrollViewDelegate>



@property (strong, nonatomic) NSString* groupID;

@property (strong,nonatomic)  ASGroup *currentGroup;
@property (strong,nonatomic)  ASUser *currentUser;
@property (strong,nonatomic)  ASUser *authorizedUser;


@property (strong, nonatomic) NSMutableArray* arrrayWall;
@property (strong,nonatomic)  NSMutableArray *imageViewSize;



@property (strong, nonatomic) NSArray* arrayNumberDataCountres;
@property (strong, nonatomic) NSArray* arrayTextDataCountres;


@property (assign,nonatomic)  BOOL loadingDataWall;
@property (assign,nonatomic)  BOOL loadingDataCollPhoto;
@property (assign, nonatomic) BOOL firstTimeAppear;

//
@property (strong, nonatomic) NSMutableArray* miniaturePhotoArray;
@property (strong, nonatomic) NSMutableArray* pathsArray;


// Коллекшен для фотографий юзера
@property (strong, nonatomic) UICollectionView* collectionViewPhoto;
@property (strong, nonatomic) UIButton* numberPhotoButton;

// для репоста записии
@property (assign, nonatomic) NSInteger indexPathWallForRepost;

// для работы с стеной
@property (strong, nonatomic) NSString* wallFilter;
@property (strong,nonatomic)  UIRefreshControl *refresh;


@end

@implementation ASUserTVC


- (void)viewDidLoad {
    [super viewDidLoad];

    
     float floatVal = 1.2345634534775;
     
  
     float roundedUpVal = ceil(floatVal);
     NSLog(@"%f",roundedUpVal);
     
   
    if ([self.superUserID length]<1) {
        self.superUserID = @"201621080";
    }
    
    // Levan 181192839
    // Hack 201621080
    // Олейгич 7213748
    // Алексей 26955116
  //  self.superUserID = @"201621080";
    
    self.wallFilter = @"all";
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshWall:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
    

    self.currentUser  = [ASUser new];
    self.currentGroup = [ASGroup new];
    
    self.arrrayWall     = [NSMutableArray array];
    self.imageViewSize  = [NSMutableArray array];

    
    
    self.arrayNumberDataCountres = [NSArray array];
    self.arrayTextDataCountres   = [NSArray array];
    self.miniaturePhotoArray     = [NSMutableArray array];
    
    self.pathsArray = [NSMutableArray array];
    
    self.loadingDataWall      = YES;
    self.loadingDataCollPhoto = NO;
    self.firstTimeAppear      = YES;
    

    self.navigationController.navigationBar.barStyle     = UIBarStyleBlackOpaque;
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
            //self.navigationItem.title = user.firstName;
            self.authorizedUser  = [ASUser new];
            self.authorizedUser = user;
            
            NSLog(@"%@ %@", user.firstName, user.lastName);
            [self getUserFromServer];
            [self getUserPhotoFromServer];
            [self getWallFromServer];
            
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - GetDataFromServer

-(void)  getUserFromServer {
    

    [[ASServerManager sharedManager] getUsersInfoUserID:self.superUserID
                                              onSuccess:^(ASUser *user) {
                                                  
                                                  self.currentUser = user;
                                                  self.navigationItem.title = user.firstName;
                                                  
                                                  [self setCounteresForCollectionView];
                                                  [self.tableView reloadData];
                                             
                                              }
     
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"errpr = %@ statsus %d",[error localizedDescription],statusCode);
                                              }];
    
}


-(void)  getUserPhotoFromServer {
   
    [[ASServerManager sharedManager] getPhotoUserID:self.superUserID
                                         withOffset:[self.miniaturePhotoArray count]
                                              count:20
                                          onSuccess:^(NSArray *photos) {
          
        //NSLog(@"А БРАТЬЕВ = %d",[self.miniaturePhotoArray count]);
        //NSLog(@"НАС %d",[photos count]);
       
 
      if ([photos count] > 0) {
          
          
          NSMutableArray* arrPath = [NSMutableArray array];
          

        
          for (NSInteger i= [self.miniaturePhotoArray count]; i<=[photos count]+[self.miniaturePhotoArray count]-1; i++) {
              
              //NSLog(@"Добавляем %ld",(long)i);
              [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
          }
  
          
          
          [self.miniaturePhotoArray addObjectsFromArray:photos];
          [self.collectionViewPhoto insertItemsAtIndexPaths:arrPath];

     
          self.loadingDataCollPhoto = NO;
          
      }

               } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  
                                              }];
    

    
}



-(void)  getWallFromServer {
    

    [[ASServerManager sharedManager] getWall:self.superUserID
                                  withDomain:@""
                                  withFilter:self.wallFilter
                                  withOffset:[self.arrrayWall count]
                                   typeOwner:@"user"
                                       count:20
                                   onSuccess:^(NSArray *posts) {
                                       
                                       
   if ([posts count] > 0) {
       
       
       
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
           
          
           NSMutableArray* arrPath = [NSMutableArray array];
           
           for (NSInteger i= [self.arrrayWall count]; i<=[posts count]+[self.arrrayWall count]-1; i++) {
               
               [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:2]];
           }
           
           
           [self.arrrayWall addObjectsFromArray:posts];

           
           
           for (int i = (int)[self.arrrayWall count] - (int)[posts count]; i < [self.arrrayWall count]; i++) {
               
               NSArray* arr = [[self.arrrayWall objectAtIndex:i] attachments];
               
               CGSize newSize = [self setFramesToImageViews:nil imageFrames:[[self.arrrayWall objectAtIndex:i] attachments]
                                                  toFitSize:CGSizeMake(self.view.frame.size.width-16, self.view.frame.size.width-16)];
               
               NSLog(@" getWallFromServer newSize = %@",NSStringFromCGSize(newSize));
               [self.imageViewSize addObject:[NSNumber numberWithFloat:roundf(newSize.height)]];
   
            }
           
           
           
           dispatch_sync(dispatch_get_main_queue(), ^{
               
               [self.tableView beginUpdates];
               [self.tableView insertRowsAtIndexPaths:arrPath withRowAnimation:UITableViewRowAnimationFade];
               [self.tableView endUpdates];
               
               
               
               self.loadingDataWall = NO;
               
           });
           
       });
       
   }
   
                                       
                                   } onFailure:^(NSError *error, NSInteger statusCode) {
                                       
                                   }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([UICollectionView isSubclassOfClass:[UIScrollView class]]) {
        
        UICollectionView* collectionView = (UICollectionView*)scrollView;
        

        if (collectionView.tag == 300) {

            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width) {


                if (self.loadingDataCollPhoto == NO)
                {

                    
                    NSLog(@"Подгружаю !");
                   
                    self.loadingDataCollPhoto = YES;
                    [self getUserPhotoFromServer];
                }
                
            }
        }
    }
    
    ////
    
    if ([UITableView isSubclassOfClass:[UIScrollView class]]) {
        
        UITableView* tableView = (UITableView*)scrollView;
        
        if (tableView.tag == 400) {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if (!self.loadingDataWall)
                {
                    self.loadingDataWall = YES;
                    NSLog(@"Подгружаю !");
                    
                    [self getWallFromServer];
                }
            }
            
        }
    }
    
    
}





#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section > 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ASMainUserCell class]]) {
        return 211.f;
    }
    
    if ([cell isKindOfClass:[ASGrayCell class]]) {
        return 16.f;
    }
    
    if ([cell isKindOfClass:[ASSegmentPost class]]) {
        return 44.f;
    }
    
    if ([cell isKindOfClass:[ASWallAttachmentCell class]]) {
        
       
    
        ASWall* wall = self.arrrayWall[indexPath.row];

        
        float height = 0;
        
        if (![wall.text isEqualToString:@""]) {
            height = height + (int)[self heightLabelOfTextForString:wall.text fontSize:14.f widthLabel:self.view.frame.size.width-(offset*2)];
        }
        
        
        if ([wall.attachments count] > 0) {
            height = height + [[self.imageViewSize objectAtIndex:indexPath.row]floatValue];
        }
        
        NSLog(@"IndexPath.row = %ld section =%d  size height = %f",(long)indexPath.row,indexPath.section,(offsetBeforePhoto + heightPhoto) + (offsetBetweenPhotoAndText + height) + (offsetBetweenTextAndShared + heightShared + offsetAfterShared));
        
        
        return (offsetBeforePhoto + heightPhoto) + (offsetBetweenPhotoAndText + height) + (offsetBetweenTextAndShared + heightShared + offsetAfterShared);
        
        
       
            
        }
    
    
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 100.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 95)];

    
    NSString* titleButton = [NSString stringWithFormat:@"%d photos",[self.miniaturePhotoArray count]];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // Потом разкоментить
    //[button addTarget:self  action:@selector(aMethod:)   forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:titleButton forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 5, 9, 5);

    button.frame = CGRectMake(0.f, 0.f, tableView.frame.size.width, 26.0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:button];
    button.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    //ASPhotosFlowLayout
    
    ASPhotosFlowLayout *layout = [ASPhotosFlowLayout initFlowLayout];
    

    CGRect rect =  CGRectMake(0, CGRectGetMaxY(button.bounds), CGRectGetWidth(tableView.frame), 95.f-CGRectGetHeight(button.bounds));
    UICollectionView* collectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView registerNib:[UINib nibWithNibName:@"CVPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"collectionPhotoCell"];
    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collectionView setTag:300];
    
    collectionView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    
    self.collectionViewPhoto = collectionView;
    [headerView addSubview:self.collectionViewPhoto];
    
    
    return headerView;
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return  [self.arrrayWall count];
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        
        
        
        if (indexPath.row == 0) {
            
            ASMainUserCell* cell = (ASMainUserCell*)[tableView dequeueReusableCellWithIdentifier:identifierMainUser];
         
            NSLog(@"ASMainUserCell");

            [cell.ownerMainPhoto setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            
            CALayer *imageLayer = cell.ownerMainPhoto.layer;
            [imageLayer setCornerRadius:40];
            [imageLayer setBorderWidth:3];
            [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
            [imageLayer setMasksToBounds:YES];
            
        
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",self.currentUser.firstName , self.currentUser.lastName];
            cell.cityORcountry.text = self.currentUser.city;
            
           // BOOL result = value ? YES : NO;
            self.currentUser.online == 0 ? (cell.lastSeenORonline.text = self.currentUser.lastSeen) :
                                          (cell.lastSeenORonline.text = @"Online");
            
             cell.sendMessageButton.enabled = self.currentUser.enableSendMessageButton;
       
            NSString* titleForButtonAddFriends;
            
            if ([self.currentUser.userID isEqualToString:self.authorizedUser.userID]) {
                cell.addFriendButton.tag = 1000;
                [cell.addFriendButton setTitle:@"Open friends" forState:UIControlStateNormal];
                [cell.addFriendButton addTarget:self action:@selector(openFriends:)forControlEvents:UIControlEventTouchUpInside];
                
            } else {
            cell.addFriendButton.tag = (NSInteger)self.currentUser.friendStatus;
              
                if (self.currentUser.friendStatus == 0) {
                    titleForButtonAddFriends  = @"Add to Friends";
                }
                else
                    if (self.currentUser.friendStatus == 1) {
                        titleForButtonAddFriends = @"You send request";
                    }
                    else
                        if (self.currentUser.friendStatus == 2) {
                            titleForButtonAddFriends = @"Add to Friends";
                        }
                        else
                            if (self.currentUser.friendStatus == 3) {
                                titleForButtonAddFriends = @"Remove friend";
                            }
                
                
            [cell.addFriendButton setTitle:titleForButtonAddFriends forState:UIControlStateNormal];
            [cell.addFriendButton addTarget:self action:@selector(addFriendAction:)forControlEvents:UIControlEventTouchUpInside];
            }
      
            
            [cell.sendMessageButton addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.collectionViewMember reloadData];
            return cell;
        }
    }
    
    
    
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            NSLog(@"ASGrayCell");

            ASGrayCell* cell = (ASGrayCell*)[tableView dequeueReusableCellWithIdentifier:identifierGray];
            if (!cell) {
                cell = [[ASGrayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierGray];
            }
            return cell;
        }
        
        
        
        
        if (indexPath.row == 1) {
            NSLog(@"ASSegmentPost");
 
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
    
    if (indexPath.section == 2) {

        
        ASWallAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierWall];
        NSLog(@"ASWallAttachmentCell");
        if (!cell) {
            cell = [[ASWallAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWall];
        }
        
        ASWall* wall = self.arrrayWall[indexPath.row];

        
        if (wall.user) {
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
            [cell.ownerPhoto setImageWithURL:wall.user.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
        } else if (wall.group) {
            
            cell.fullName.text = wall.group.fullName;
            [cell.ownerPhoto setImageWithURL:wall.group.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
        }
        
        
        cell.textPost.text = wall.text;
        cell.date.text     = wall.date;
        

        cell.commentLabel.text = ([wall.comments length]>3) ? ([NSString stringWithFormat:@"%@k",[wall.comments substringToIndex:1]]) : (wall.comments);
        cell.likeLabel.text    = ([wall.likes length]>3)    ? ([NSString stringWithFormat:@"%@k",[wall.likes substringToIndex:1]])    : (wall.likes);
        cell.repostLabel.text  = ([wall.reposts length]>3)  ? ([NSString stringWithFormat:@"%@k",[wall.reposts substringToIndex:1]])  : (wall.reposts);
        
        
        
        [cell.likeButton      addTarget:self action:@selector(addLikeOnPost2:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeButton.tag = indexPath.row;
        
        [cell.repostButton      addTarget:self action:@selector(addRepost:) forControlEvents:UIControlEventTouchUpInside];
        cell.repostButton.tag = indexPath.row;

        
        [cell.commentButton addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentButton.tag = indexPath.row;
        [cell.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];

        
        [cell.openOwnerPage addTarget:self action:@selector(openOwnerPageAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.openOwnerPage.tag = indexPath.row;

        

        if (wall.canLike == NO) {
            cell.likeView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
        } else {
            cell.likeView.backgroundColor = [UIColor yellowColor];
        }
        

        
        if (wall.canRepost == NO) {
            cell.repostView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
        } else {
            cell.repostView.backgroundColor = [UIColor clearColor];
        }
        
        
      
        
        __weak ASWallAttachmentCell *weakCell = cell;
        
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
        
        
        if ([cell viewWithTag:11]) [[cell viewWithTag:11] removeFromSuperview];
        if ([cell viewWithTag:222]) [[cell viewWithTag:222] removeFromSuperview];
        
        if ([wall.attachments count] > 0) {
            
            if ([cell viewWithTag:222]) [[cell viewWithTag:222] removeFromSuperview];

            CGPoint point = CGPointZero;
     
            
            float sizeText = [self heightLabelOfTextForString:cell.textPost.text fontSize:14.f widthLabel:CGRectGetWidth(self.view.bounds)-2*8];
            
            point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame),sizeText+(offsetBeforePhoto + heightPhoto + offsetBetweenPhotoAndText));
 
            CGSize sizeAttachment = CGSizeMake(CGRectGetWidth(self.view.bounds)-2*offset, CGRectGetWidth(self.view.bounds)-2*offset);
            
            ASImageViewGallery *galery = [[ASImageViewGallery alloc]initWithImageArray:wall.attachments startPoint:point withSizeView:sizeAttachment];
            galery.tag = 222;
            [cell addSubview:galery];
   
            ///
            
            
            for (id obj in wall.attachments) {
                
                if ([obj isKindOfClass:[ASLink class]]) {
                
                    if (CGRectGetMaxY(galery.frame)>70) {
                        point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(galery.frame));
                    } else {
                        point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(cell.textPost.frame));

                    }
                    
    
                    
                    ASLink* link = (ASLink*)obj;
                    
                    ASLinkModel* urlView = [[ASLinkModel alloc]initWithFrame:CGRectMake(point.x, point.y,
                                                                                      self.view.bounds.size.width-16,50)];
                    
                    urlView.bounds = CGRectMake(point.x, point.y,  self.view.bounds.size.width-16,50);
                    urlView.tag = 222;
                    urlView.titleLabel.text = link.title;
                    urlView.urlLabel.text   = link.urlString;
                    
                    [urlView.openSiteButton     addTarget:self
                                                   action:@selector(openSiteAction:)
                                         forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell addSubview:urlView];
                    
                    //point.y += 50;
                }
 
            }
        }
        return cell;
        
    }
    
  return nil;
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    
    if (collectionView.tag == 100) {
        return [self.arrayNumberDataCountres count];
    }
    
    if (collectionView.tag == 200) {
        return [self.miniaturePhotoArray count];
    }

    if (collectionView.tag == 300) {
        return [self.miniaturePhotoArray count];
    }
    
    return 0;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (collectionView.tag == 100) {
        NSLog(@"ASInfoMemberCollectionCell");

        static NSString *identifier = @"ASInfoMemberCollectionCell";
        ASInfoMemberCollectionCell *cell = (ASInfoMemberCollectionCell*)
                                           [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                     forIndexPath:indexPath];
        
        cell.firstLabel.text = self.arrayNumberDataCountres[indexPath.row];
        cell.seconLabel.text = self.arrayTextDataCountres[indexPath.row];
        
    return cell;
    }
    
    
    if (collectionView.tag == 300) {
        NSLog(@"collectionPhotoCell");

        ASCollectionPhotoCell *cell = (ASCollectionPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionPhotoCell" forIndexPath:indexPath];

        if (!cell) {
            [collectionView registerNib:[UINib nibWithNibName:@"CVPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"collectionPhotoCell"];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionPhotoCell" forIndexPath:indexPath];
        }
        
        
        ASPhoto* photo = self.miniaturePhotoArray[indexPath.row];
        
        
        __weak ASCollectionPhotoCell *weakCell = cell;
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:photo.photo_130URL];
        
        [cell.imageCell setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"pl_post2"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.imageCell.image = image;
                                           photo.photo_130image = image;
   
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           
                                       }];
        
        
        cell.backgroundColor = [UIColor blueColor];
        
        return cell;
    }

  return nil;
}

#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView.tag == 100) {
    
        return CGSizeMake(60, 50);
    }

    if (collectionView.tag == 300) {
        
        
        ASPhoto* photo = self.miniaturePhotoArray[indexPath.row];
    
        NSLog(@"-- photo wieght %ld height %f",(long)photo.width, photo.height);

        
        if (photo.width == 0 && photo.height == 0) {
            photo.width = 300;
            photo.height = 150;

        }
        
        CGSize   oldSize = CGSizeMake(photo.width, photo.height);
        CGSize   newSize = CGResizeFixHeight(oldSize);
        
        NSLog(@"-- neewsiz %@",NSStringFromCGSize(newSize));
        //return CGResizeFixHeight(newSize);
        return  newSize;//CGSizeMake(50, 50);

    }
    
    return  CGSizeMake(50, 50);
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    static NSString *identifier = @"ASInfoMemberCollectionCell";
    ASInfoMemberCollectionCell *cell = (ASInfoMemberCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    */
}


#pragma mark - Action

-(void)  sendMessageAction:(UIButton*) sender {
    
    
}



-(void) openFriends:(UIButton*) sender {
    
    
    ASFriendTVC* friendVC = [[ASFriendTVC alloc] initWithStyle:UITableViewStylePlain];
    friendVC.currentUser = self.currentUser;
 
    [self.navigationController pushViewController:friendVC animated:YES];

    
}




-(void)  addFriendAction:(UIButton*) sender {

    if (sender.tag == 0 || sender.tag == 2) {
        
        [[ASServerManager sharedManager] addToFriends:self.currentUser.userID
                                            onSuccess:^(NSDictionary *result) {
                                           
                                    int success = [[result objectForKey:@"response"]  integerValue];
                                    
                                    if (success==1) {
                                        self.currentUser.friendStatus = 1;
                                        
                                        NSIndexSet* set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
                                        
                                        [self.tableView beginUpdates];
                                        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
                                        [self.tableView endUpdates];
                                    }
     
                                                
                                                
                                            }
                                            onFailure:^(NSError *error, NSInteger statusCode) {
                                                
      }];
    }
    
    if (sender.tag == 1 || sender.tag == 3) {
        
        [[ASServerManager sharedManager] deleteFromFriends:self.currentUser.userID
                                            onSuccess:^(NSDictionary *result) {
                                               
                                        int success = [[[result objectForKey:@"response"] objectForKey:@"success"] integerValue];
                                              
                                        if (success==1) {
                                            self.currentUser.friendStatus = 0;

                                            NSIndexSet* set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
                                            
                                            [self.tableView beginUpdates];
                                            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
                                            [self.tableView endUpdates];
                                        }
                                                
                                            }
                                            onFailure:^(NSError *error, NSInteger statusCode) {
                                                
     }];
    }
    
    
    
    
    
}



-(void)segmentControlPostAction:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    NSLog(@"selectedSegment = %d",selectedSegment);
    
    
    
}


-(void) createPostAction:(UIButton*) sender {
    
    
    NSLog(@"createPostAction");
}




-(void) addLikeOnPost2:(UIButton*) sender {
    
    ASWall* wall = self.arrrayWall[sender.tag];
    
    
    if (wall.canLike) {
        
        
        [[ASServerManager sharedManager] postAddLikeOnWall:self.superUserID inPost:wall.postID type:wall.type typeOwner:@"user" onSuccess:^(NSDictionary *result) {
           
            
            NSDictionary* response = [result objectForKey:@"response"];
            
            wall.canLike = NO;
            wall.likes   = [[response objectForKey:@"likes"] stringValue];
            [self.tableView reloadData];

            
            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            
            
        }];
        
        
     
    } else {
        
        
        [[ASServerManager sharedManager] postDeleteLikeOnWall:self.superUserID inPost:wall.postID type:wall.type typeOwner:@"user" onSuccess:^(NSDictionary *result) {
            
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
    
    NSLog(@"after alert show");
    
}


-(void) showComment:(UIButton*) sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ASDetailTVC* detailVC = (ASDetailTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASDetailTVC"];
    
    // detailVC.group  = self.group;
    // [[self.imageViewSize objectAtIndex:indexPath.row]floatValue]
    // [[self.arrrayWall objectAtIndex:sender.tag] imageViewSize] = [[self.imageViewSize objectAtIndex:sender.tag]floatValue];
    
    
    ASWall* wall = [[ASWall alloc] init];
    wall = self.arrrayWall[sender.tag];
    wall.imageViewSize = [[self.imageViewSize objectAtIndex:sender.tag] floatValue];
    
    detailVC.whence = @"user";
    detailVC.wall   = wall;//self.arrrayWall[sender.tag];
    detailVC.postID = [[self.arrrayWall objectAtIndex:sender.tag] postID];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

-(void) openSiteAction:(UIButton*) sender {
    
    
}


-(void) openOwnerPageAction:(UIButton*) sender {
    
    
    ASWall* wall = [[ASWall alloc] init];
    wall = self.arrrayWall[sender.tag];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
       
    if (wall.group) {
        //ownerID = self.wall.group.groupID;
        //typeOwner = @"group";
        
        ASGroupTVC* groupVC = (ASGroupTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASGroupTVC"];
        groupVC.superGroupID = wall.group.groupID;
        
        [self.navigationController pushViewController:groupVC animated:YES];

    } else if (wall.user) {
       
       
        if (![wall.user.userID isEqualToString:self.authorizedUser.userID]) {
             
        ASUserTVC* userVC = (ASUserTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ASUserDetailTVC"];
        userVC.superUserID = wall.user.userID;
        [self.navigationController pushViewController:userVC animated:YES];
        }
    }
    
    
    
    
    
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
        
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSLog(@"username: %@", textfield.text);
            
            ASWall* wall = self.arrrayWall[self.indexPathWallForRepost];
            
            [[ASServerManager sharedManager] repostOnMyWall:wall.ownerID
                                                     inPost:wall.postID
                                                withMessage:textfield.text
                                                  typeOwner:@"user"
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




- (void)refreshWall:(id)sender {
    
    if (self.loadingDataWall != YES) {
        self.loadingDataWall = YES;
        
        
        if ([self.arrrayWall count] > 0) {
            
            [self.arrrayWall removeAllObjects];
            [self.imageViewSize removeAllObjects];
            [self.miniaturePhotoArray removeAllObjects];
            
            
            [self getUserFromServer];
            [self getUserPhotoFromServer];
            [self getWallFromServer];
            
            [self.refresh endRefreshing];
            [self.tableView reloadData];
            
            self.loadingDataWall = NO;
        }
        
    }
    
}

- (void) updateOnlyWall:(id)sender {
    
    if (self.loadingDataWall != YES) {
        self.loadingDataWall = YES;
        
        
        if ([self.arrrayWall count] > 0) {
            
            [self.arrrayWall removeAllObjects];
            [self.imageViewSize removeAllObjects];
            
            [self getWallFromServer];
            [self.refresh endRefreshing];
            [self.tableView reloadData];
            
            self.loadingDataWall = NO;
        }
        
    }
}


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
    
    //[self refreshWall:sender];
    [self updateOnlyWall:sender];
}




#pragma mark - Other

-(void) setCounteresForCollectionView {
    
    
    NSMutableArray* newNumberArray = [NSMutableArray array];
    NSMutableArray* newTextArray   = [NSMutableArray array];
    

    
    if (self.currentUser.albums) {
    
        [newNumberArray addObject:_currentUser.albums];
        [newTextArray   addObject:@"albums"];
        
    }
    
    
    if (self.currentUser.audios) {
        
        [newNumberArray addObject:_currentUser.audios];
        [newTextArray   addObject:@"audios"];
        
    }
    
    if (self.currentUser.followers) {
        
        [newNumberArray addObject:_currentUser.followers];
        [newTextArray   addObject:@"followers"];
        
    }
    
    if (self.currentUser.friends) {
        
        [newNumberArray addObject:_currentUser.friends];
        [newTextArray   addObject:@"friends"];
        
    }

    if (self.currentUser.groups) {
        
        [newNumberArray addObject:_currentUser.groups];
        [newTextArray   addObject:@"groups"];
        
    }
    
    if (self.currentUser.pages) {
        
        [newNumberArray addObject:_currentUser.pages];
        [newTextArray   addObject:@"pages"];
        
    }
    if (self.currentUser.photos) {
        
        [newNumberArray addObject:_currentUser.photos];
        [newTextArray   addObject:@"photos"];
        
    }
    if (self.currentUser.videos) {
        
        [newNumberArray addObject:_currentUser.videos];
        [newTextArray   addObject:@"videos"];
        
    }
    
    
    if (self.currentUser.subscriptions) {
        
        [newNumberArray addObject:_currentUser.subscriptions];
        [newTextArray   addObject:@"subscriptions"];
        
    }
    
    self.arrayNumberDataCountres = newNumberArray;
    self.arrayTextDataCountres   = newTextArray;
    
    /*
    NSArray* arrayCounterText = @[@"albums",   @"audios",  @"followers", @"friends",
                                  @"groups",   @"pages",   @"photos",    @"videos", @"subscriptions"];
    
    
    NSArray* arrayCounterNumber = @[_currentUser.albums,    _currentUser.audios,
                                    _currentUser.followers, _currentUser.friends,
                                    //_currentUser.groups,
                                    _currentUser.pages,
                                    _currentUser.photos, _currentUser.videos,
                                    _currentUser.subscriptions ];
    
    NSMutableArray* newNumberArray = [NSMutableArray array];
    NSMutableArray* newTextArray   = [NSMutableArray array];
    
    
    for (int i=0; i<[arrayCounterNumber count]; i++) {
        
        NSString* str = arrayCounterNumber[i];
        int count = [str integerValue];
        
        if (count > 0) {
            [newNumberArray addObject:str];
            [newTextArray   addObject:arrayCounterText[i]];
        }
    }
    
    self.arrayNumberDataCountres = newNumberArray;
    self.arrayTextDataCountres   = newTextArray;*/
    
}


- (IBAction)itemBar:(id)sender {


    [self.tableView reloadData];
}



#pragma mark - TextImageConfigure
- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageFrames.count;
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[ASLink class]]) {
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
    
    long double cost;
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
       
        if (k1>=10) {
            k1=0;
        }
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    
    //float heightOffset = cellDistance, widthOffset;
  float heightOffset = cellDistance, widthOffset;
    
    long double frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
           // тута
            rowWidth += (float)ceilf(newFrames[j].size.width);
        
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
    
    //// jgjhf
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[ASLink class]]) {
            
            heightOffset += 60;
        }
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
