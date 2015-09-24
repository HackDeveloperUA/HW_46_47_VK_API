//
//  ASUserDetailTVC.m
//  HW_46_47
//
//  Created by MD on 11.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUserDetailTVC.h"

// Model
#import "ASUser.h"
#import "ASWall.h"
#import "ASFriend.h"
#import "ASGroup.h"
#import "ASPhoto.h"

// Collection View
#import "ASInfoMemberCollectionCell.h"
#import "ASInfoMemberFlowLayout.h"

#import "ASPhotosCollectionCell.h"
#import "ASPhotosFlowLayout.h"

// Custom Cell
#import "ASMainUserCell.h"
#import "ASPhotoUserCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

// Test
#import "ASCollectionPhotoCell.h"



static NSString* identifierMainUser     = @"ASMainUserCell";
static NSString* identifierPhotos       = @"ASPhotoUserCell";
static NSString* identifierSegmentPost  = @"ASSegmentPost";
static NSString* identifierGray         = @"ASGrayCell";


static CGSize CGSizeResize(CGSize size) {
    
    
    //size.width *= height / size.height;
    //size.height = height;
    //return size;
    
    CGFloat targetHeight = 65.0f;
    CGFloat scaleFactor = targetHeight / size.height;
    CGFloat targetWidth = size.width * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}


@interface ASUserDetailTVC () <UITableViewDataSource,      UITableViewDelegate,UICollectionViewDelegateFlowLayout,
                                UICollectionViewDataSource, UICollectionViewDelegate,
                                UIScrollViewDelegate>

@property (strong, nonatomic) NSString* groupID;

@property (strong,nonatomic)  ASGroup *currentGroup;
@property (strong,nonatomic)  ASUser *currentUser;

@property (strong, nonatomic) NSMutableArray* arrrayWall;

@property (strong, nonatomic) NSArray* arrayNumberDataCountres;
@property (strong, nonatomic) NSArray* arrayTextDataCountres;


@property (assign,nonatomic)  BOOL loadingDataWall;
@property (assign,nonatomic)  BOOL loadingDataCollPhoto;
@property (assign, nonatomic) BOOL firstTimeAppear;

//
@property (strong, nonatomic) NSMutableArray* miniaturePhotoArray;
@property (strong, nonatomic) NSMutableArray* pathsArray;

@property (strong, nonatomic) ASPhotoUserCell* asphotocell;
@property (assign, nonatomic) CGPoint scrollingPoint;
// TEST

@property (strong, nonatomic) UICollectionView* collectionViewPhoto;

@end

@implementation ASUserDetailTVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser  = [ASUser new];
    self.currentGroup = [ASGroup new];
    
    self.arrrayWall  = [NSMutableArray array];
    
    self.arrayNumberDataCountres = [NSArray array];
    self.arrayTextDataCountres   = [NSArray array];
    self.miniaturePhotoArray     = [NSMutableArray array];
    
    self.pathsArray = [NSMutableArray array];
    
    self.loadingDataWall      = YES;
    self.loadingDataCollPhoto = NO;
    self.firstTimeAppear      = YES;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;

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
            self.navigationItem.title = user.firstName;
            
            NSLog(@"%@ %@", user.firstName, user.lastName);
            [self getUserFromServer];
            [self getUserPhotoFromServer];
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - GetDataFromServer

-(void)  getUserFromServer {
    

    [[ASServerManager sharedManager] getUsersInfoUserID:@"201621080"
                                              onSuccess:^(ASUser *user) {
                                                  
                                                  self.currentUser = user;
                                                  [self setCounteresForCollectionView];
                                                  [self.tableView reloadData];
                                             
                                              }
     
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"errpr = %@ statsus %d",[error localizedDescription],statusCode);
                                              }];
    
}


-(void)  getUserPhotoFromServer {
   
    [[ASServerManager sharedManager] getPhotoUserID:@"201621080"
                                         withOffset:[self.miniaturePhotoArray count]
                                              count:20
                                          onSuccess:^(NSArray *photos) {
          
        NSLog(@"А БРАТЬЕВ = %d",[self.miniaturePhotoArray count]);
        NSLog(@"НАС %d",[photos count]);
       
 
      if ([photos count] > 0) {
          
          
          NSMutableArray* arrPath = [NSMutableArray array];
          
       /*
        for (NSInteger i= [self.miniaturePhotoArray count]; i<=[photos count]+[self.miniaturePhotoArray count]-1; i++) {
           
             NSLog(@"Добавляем %ld",(long)i);
            [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
          }
       */
     
        
              for (NSInteger i= [self.miniaturePhotoArray count]; i<=[photos count]+[self.miniaturePhotoArray count]-1; i++) {
                  
                  NSLog(@"Добавляем %ld",(long)i);
                  [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
              }
      
          
          
          [self.miniaturePhotoArray addObjectsFromArray:photos];
          //[self.collectionViewPhoto reloadData];
          [self.collectionViewPhoto insertItemsAtIndexPaths:arrPath];

          //[self.tableView reloadData];
     
          self.loadingDataCollPhoto = NO;
          
      }

               } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  
                                              }];
    

    
}



-(void)  getWallFromServer {
    

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([UICollectionView isSubclassOfClass:[UIScrollView class]]) {
        
        UICollectionView* collectionView = (UICollectionView*)scrollView;
        

         //if (collectionView.tag == 200) {
        if (collectionView.tag == 300) {

            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width) {


                if (self.loadingDataCollPhoto == NO)
                {

                    self.scrollingPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
                    
                    NSLog(@"Подгружаю !");
                   
                    self.loadingDataCollPhoto = YES;
                    [self getUserPhotoFromServer];
                }
                
            }
        }
        
        
     
    }
    
}





#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ASMainUserCell class]]) {
        return 211.f;
    }
    
    if ([cell isKindOfClass:[ASPhotoUserCell class]]) {
        return 95.f;
    }
    
    if ([cell isKindOfClass:[ASGrayCell class]]) {
        return 16.f;
    }
    
    if ([cell isKindOfClass:[ASSegmentPost class]]) {
        return 44.f;
    }
    
    // TEST
    if ([cell isKindOfClass:[ASPhotoUserCell class]]) {
        return 95.f;
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
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 95)];
    //headerView.backgroundColor = [UIColor greenColor];
    

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
             cell.addFriendButton.enabled   = self.currentUser.enableAddFriendButton;
            [cell.addFriendButton setTitle:   self.currentUser.titleAddFriendButton  forState: UIControlStateNormal];
            
            
            [cell.sendMessageButton addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addFriendButton   addTarget:self action:@selector(addFriendAction:)   forControlEvents:UIControlEventTouchUpInside];
            
            [cell.collectionViewMember reloadData];
            return cell;
        }
        
        
        
        /*
        if (indexPath.row == 1) {
           
            ASPhotoUserCell* cell = (ASPhotoUserCell*)[tableView dequeueReusableCellWithIdentifier:@"ASPhotoUserCell"];
           
        
            //self.asphotocell = [[ASPhotoUserCell alloc]init];
            
            if (self.asphotocell) {
                
            //[cell simpleReloadDataWithPath];
            //[cell.collectionUserCell setContentOffset:self.scrollingPoint animated:YES];
            
            }
            else {
                self.asphotocell = cell;
 
            }
            
            return cell;
        }*/
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            ASGrayCell* cell = (ASGrayCell*)[tableView dequeueReusableCellWithIdentifier:identifierGray];
            if (!cell) {
                cell = [[ASGrayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierGray];
            }
            return cell;
        }
        
        
        
        
        if (indexPath.row == 1) {
            
            ASSegmentPost* cell = (ASSegmentPost*)[tableView dequeueReusableCellWithIdentifier:identifierSegmentPost];
            if (!cell) {
                cell = [[ASSegmentPost alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSegmentPost];
            }
            [cell.postSegmentControl addTarget:self
                                        action:@selector(segmentControlPostAction:)
                              forControlEvents: UIControlEventValueChanged];
            [cell.createPost addTarget:self
                                action:@selector(createPostAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        
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
    
    return 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"cellForItemAtIndexPath");
    
    if (collectionView.tag == 100) {
    
        static NSString *identifier = @"ASInfoMemberCollectionCell";
        ASInfoMemberCollectionCell *cell = (ASInfoMemberCollectionCell*)
                                           [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                     forIndexPath:indexPath];
        
        cell.firstLabel.text = self.arrayNumberDataCountres[indexPath.row];
        cell.seconLabel.text = self.arrayTextDataCountres[indexPath.row];
        
    return cell;
    }
    
    
    if (collectionView.tag == 200) {

        static NSString *identifier = @"ASPhotosCollectionCell";
        ASPhotosCollectionCell *cell = (ASPhotosCollectionCell*)
                                        [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                  forIndexPath:indexPath];
        ASPhoto* photo = self.miniaturePhotoArray[indexPath.row];
    
        
        __weak ASPhotosCollectionCell *weakCell = cell;
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:photo.photo_130URL];
        
        [cell.cellImage setImageWithURLRequest:request
                                   placeholderImage:[UIImage imageNamed:@"pl_post2"]
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                
                                                weakCell.cellImage.image = image;
                                                photo.photo_130image = image;
                                                
                                                
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                
                                            }];
        
        cell.backgroundColor = [UIColor greenColor];
        
    return cell;
    }
    
    if (collectionView.tag == 300) {
       
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
    

    
    if (collectionView.tag == 200) {
        
        ASPhoto* photo = self.miniaturePhotoArray[indexPath.row];
 
            
            CGSize   oldSize = CGSizeMake(photo.width, photo.height);
            CGSize   newSize = CGSizeResize(oldSize);
           
            return CGSizeResize(newSize);

    }
    
    if (collectionView.tag == 100) {
    
        return CGSizeMake(60, 50);
    }

    if (collectionView.tag == 300) {
        
        
        ASPhoto* photo = self.miniaturePhotoArray[indexPath.row];
        
        
        CGSize   oldSize = CGSizeMake(photo.width, photo.height);
        CGSize   newSize = CGSizeResize(oldSize);
        
        return CGSizeResize(newSize);
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

-(void)  addFriendAction:(UIButton*) sender {
    
    
}

-(void)segmentControlPostAction:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    NSLog(@"selectedSegment = %d",selectedSegment);
    
}


-(void) createPostAction:(UIButton*) sender {
    
    
    NSLog(@"createPostAction");
}


#pragma mark - Other

-(void) setCounteresForCollectionView {
    
    
    NSArray* arrayCounterText = @[@"albums",   @"audios",  @"followers", @"friends",
                                  @"groups",   @"pages",   @"photos",    @"videos", @"subscriptions"];
    
    
    NSArray* arrayCounterNumber = @[_currentUser.albums,    _currentUser.audios,
                                    _currentUser.followers, _currentUser.friends,
                                    _currentUser.groups,    _currentUser.pages,
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
    self.arrayTextDataCountres   = newTextArray;
    
}


- (IBAction)itemBar:(id)sender {

    //self.asphotocell.collectionView = nil;

    NSIndexPath* path = [NSIndexPath indexPathForRow:1 inSection:0];
    ASPhotoUserCell* cell = (ASPhotoUserCell*)[self tableView:self.tableView cellForRowAtIndexPath:path];
    
    //cell.collectionUserCell = nil;
    
    
    
    [self.tableView reloadData];

}

@end
