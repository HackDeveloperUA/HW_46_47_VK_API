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


// Collection View
#import "ASInfoMemberCollectionCell.h"
#import "ASInfoMemberFlowLayout.h"

//#import "ASPhotosCollectionCell.h"
#import "ASPhotosFlowLayout.h"

// Custom Cell
#import "ASMainGroupCell.h"
#import "ASSegmentPost.h"
#import "ASGrayCell.h"
#import "ASWallCell.h"
#import "ASWallTextCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

// HEX
#import "UIColor+HEX.h"


static NSString* identifierMainGroup    = @"ASMainGroupCell";
static NSString* identifierSegmentPost  = @"ASSegmentPost";
static NSString* identifierGray         = @"ASGrayCell";
static NSString* identifierWall         = @"ASWallCell";
static NSString* identifierWallTextOnly  = @"ASWallTextCell";

@interface ASGroupTVC () <UITableViewDataSource,      UITableViewDelegate ,
                          UICollectionViewDataSource, UICollectionViewDelegate,
                          UIScrollViewDelegate>


@property (strong, nonatomic) NSString* groupID;

@property (strong,nonatomic)  ASGroup *group;
@property (strong, nonatomic) NSMutableArray* arrrayWall;
@property (strong, nonatomic) NSArray* arrayDataCountres;

@property (assign,nonatomic)  BOOL loadingData;
@property (assign, nonatomic) BOOL firstTimeAppear;

//@property (strong,nonatomic)  UIRefreshControl *refresh;
//@property (strong,nonatomic)  NSMutableArray *imageViewSize;
@end



@implementation ASGroupTVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.group = [[ASGroup alloc] init];
    self.arrrayWall  = [NSMutableArray array];

    self.loadingData = YES;
    self.firstTimeAppear = YES;

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
            [self getNewWallFromServer];
          //  [self getInfoFromServer];
          //  [self getWallFromServer];
        }];
        
    }
    [self.tableView reloadData];

}

#pragma mark - GET-InfoServer

-(void)  getNewWallFromServer {
    
    
    [[ASServerManager sharedManager] getNewGroupWall:@""
                                          withDomain:@"iosdevcourse"
                                          withOffset:[self.arrrayWall count]
                                               count:20
                                           onSuccess:^(NSArray *posts) {
                                               
                                               
                               NSLog(@"Попал сюда = getNewWallFromServer");
                               NSLog(@"Пришло = %d",[posts count]);

                               if ([posts count] > 0) {
                                   
                                   NSMutableArray* arrPath = [NSMutableArray array];
                                   
                                   for (NSInteger i= [self.arrrayWall count]; i<=[posts count]+[self.arrrayWall count]-1; i++) {
                                       
                                       NSLog(@"Добавляем %ld",(long)i);
                                       [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                                   }
                                   
                                   
                                   [self.arrrayWall addObjectsFromArray:posts];
                                   
                                   
                                   [self.tableView beginUpdates];
                                   [self.tableView insertRowsAtIndexPaths:arrPath withRowAnimation:UITableViewRowAnimationTop];
                                   [self.tableView endUpdates];
                                   
                                   self.loadingData = NO;
                                   
                               }

   
                                               
                                           } onFailure:^(NSError *error, NSInteger statusCode) {
                                               
                                           }];
    
    
    
}



-(void)  getInfoFromServer {

    //58860049 iosdevcourse
    [[ASServerManager sharedManager] getGroupInfoID:@"iosdevcourse" onSuccess:^(ASGroup *group) {
        
            self.arrayDataCountres = [NSArray array];
            self.navigationItem.title = group.fullName;
        
            self.groupID = group.groupID;
            self.group = group;
        
            _arrayDataCountres = @[_group.members, _group.topics, _group.docs, _group.photos, _group.videos, _group.albums];
        
            [self.tableView reloadData];
            self.loadingData = NO;
        
          //[self getWallFromServer];
            
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];

}



#pragma mark - GET-WallServer

-(void)  getWallFromServer {
    
     NSLog(@"[count ] =====  %d",[self.arrrayWall count]);
    
    
    [[ASServerManager sharedManager] getGroupWall:@""
                                       withDomain:@"iosdevcourse"
                                       withOffset:[self.arrrayWall count]
                                            count:20
                                        onSuccess:^(NSArray *posts) {
                                            
         if ([posts count] > 0) {
            
            NSMutableArray* arrPath = [NSMutableArray array];
            
            for (NSInteger i= [self.arrrayWall count]; i<=[posts count]+[self.arrrayWall count]-1; i++) {
                
                NSLog(@"Добавляем %ld",(long)i);
                [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:1]];
            }

            
            [self.arrrayWall addObjectsFromArray:posts];
            

            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrPath withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];

             self.loadingData = NO;
            
        }
        
                                            
                                        }
                                       onFailure:^(NSError *error, NSInteger statusCode) {
                                           
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
                    
                    [self getNewWallFromServer];
                    // [self getWallFromServer];
                }
            }
            
        }
    }
    
    
    
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ASMainGroupCell class]]) {
      
       return  (208+[ASMainGroupCell heightForText:self.group.status])-21;
       
    }
    
    if ([cell isKindOfClass:[ASSegmentPost class]]) {
        return 44.f;
    }
    
    if ([cell isKindOfClass:[ASGrayCell class]]) {
        return 16.f;
    }
    

    // Заруб
    
    if ([cell isKindOfClass:[ASWallCell class]]) {

        ASWall* wall = self.arrrayWall[indexPath.row];
        ASWallCell* weakCell = (ASWallCell*)cell;
     
        weakCell.attachmentsView.backgroundColor = [UIColor blackColor];
        return 460 + [ASWallCell heightForTextWithPostModel:wall andWidthTextCell:self.view.frame.size.width];
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
    
        heightText = [ASWallCell heightForTextWithPostModel:wall andWidthTextCell:self.view.frame.size.width];
        
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
            
            ASMainGroupCell* cell = (ASMainGroupCell*)[tableView dequeueReusableCellWithIdentifier:identifierMainGroup];
            
            if (!cell) {
              cell = [[ASMainGroupCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identifierMainGroup];
            }
            
            __weak ASMainGroupCell *weakCell = cell;
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.group.mainCommunityImageURL];

            
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
            

            
            
            cell.fullNameGroup.text = self.group.fullName;
            cell.typeGroup.text     = self.group.typeCommunity;
            cell.statusGroup.text   = self.group.status;
            
            //@"Join community" : @"You are a member"
            [cell.followButton setTitle:self.group.titleJoinButton forState: UIControlStateNormal];
            [cell.followButton addTarget:self
                                action:@selector(followButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            
            if ([cell.followButton.titleLabel.text isEqualToString:@"Join community"]) {
                [cell.followButton setBackgroundColor:[UIColor colorWithRed:0.114 green:0.384 blue:0.941 alpha:1]];
            }
            else
           
            if ([cell.followButton.titleLabel.text isEqualToString:@"You are a member"])
            {
            [cell.followButton setBackgroundColor:[UIColor colorWithRed:1 green:0.176 blue:0.333 alpha:1]];
            }
          
            cell.collectionView.collectionViewLayout = (UICollectionViewLayout*)[ASInfoMemberFlowLayout initFlowLayout];
            return cell;
        }
        
        
        
        if (indexPath.row == 1) {

            ASGrayCell* cell = (ASGrayCell*)[tableView dequeueReusableCellWithIdentifier:identifierGray];
            
            if (!cell) {
            cell = [[ASGrayCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifierGray];
            }
            return cell;
         }
        
        
        
        
        if (indexPath.row == 2) {

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
    
    if (indexPath.section == 1) {

        ASWall* wall = self.arrrayWall[indexPath.row];

        
        if ([wall.attachments count] > 0) {
            
        
            ASWallCell* cell = (ASWallCell*)[tableView dequeueReusableCellWithIdentifier:identifierWall];
            
            if (!cell) {
                cell = [[ASWallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifierWall];
            }
            cell.attachmentsView.backgroundColor = [UIColor redColor];
          
            cell.textPost.text = wall.text;
            cell.date.text     = wall.date;
            
            if (wall.user) {
                cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
                [cell.ownerPhoto setImageWithURL:wall.user.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            } else if (wall.group) {
                
                cell.fullName.text = wall.group.fullName; //[NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
                [cell.ownerPhoto setImageWithURL:wall.group.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            }
            
            
            return cell;
      
            
        } else {
            
            
            ASWallTextCell* cell = (ASWallTextCell*)[tableView dequeueReusableCellWithIdentifier:identifierWallTextOnly];
            
            if (!cell) {
                cell = [[ASWallTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identifierWallTextOnly];
            }
            cell.textPost.text = wall.text;
            cell.date.text     = wall.date;

            if (wall.user) {
                cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
                [cell.ownerPhoto setImageWithURL:wall.user.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            } else if (wall.group) {
                
                cell.fullName.text = wall.group.fullName; //[NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
                [cell.ownerPhoto setImageWithURL:wall.group.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            }
            
            /*
            
             ownerPhoto;
             
             @property (weak, nonatomic) IBOutlet UILabel *fullName;
             @property (weak, nonatomic) IBOutlet UILabel *date;
             @property (weak, nonatomic) IBOutlet UILabel *textPost;

             
             */
            
            
            
            //[cell.ownerPhoto setImageWithURL:wall.urlPhoto placeholderImage:[UIImage imageNamed:@"pl_man"]];

            /*
            [[ASServerManager sharedManager] getInfoUserFromWall:wall.fromID
                                                       onSuccess:^(NSDictionary *infoUser) {
                                                        
                                                       NSLog(@" getInfoUserFromWall ");

                                                       NSString* fullName = [NSString stringWithFormat:@"%@ %@",[infoUser objectForKey:@"first_name"],[infoUser objectForKey:@"last_name"]];
                                                       wall.fullName = fullName;
                                                       wall.urlPhoto = [NSURL URLWithString:[infoUser objectForKey:@"photo_400_orig"]];
                                                       
                                                       
                                                       }
                                                       onFailure:^(NSError *error, NSInteger statusCode) {
                                                           
                                                       }];
            cell.fullName.text = wall.fullName;
            cell.date.text     = wall.date;
            [cell.ownerPhoto setImageWithURL:wall.urlPhoto placeholderImage:[UIImage imageNamed:@"pl_man"]];
            */
            
            /*
            __weak ASWallTextCell *weakCell = cell;
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:wall.urlPhoto];
            
            [cell.ownerPhoto setImageWithURLRequest:request
                                       placeholderImage:nil
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    
                                                    weakCell.ownerPhoto.image = image;
                                                    
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                    
                                                }];
            weakCell.fullName.text = wall.fullName;
            weakCell.date.text     = wall.date;
            */
            
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

    NSLog(@"TESSSTT didSelectItemAtIndexPath");
    
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

- (IBAction)segmentControlPostAction:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    NSLog(@"selectedSegment = %d",selectedSegment);
    
}


-(void) createPostAction:(UIButton*) sender {

    
    NSLog(@"createPostAction");
}



-(void) followButtonAction:(UIButton*) sender {
    
    
    NSLog(@"followButtonAction");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
