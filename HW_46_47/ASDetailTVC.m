//
//  ASDetailTVC.m
//  HW_46_47
//
//  Created by MD on 02.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASDetailTVC.h"
// Model
#import "ASUser.h"
#import "ASWall.h"
#import "ASGroup.h"
#import "ASPhoto.h"
#import "ASComment.h"

// Custom Cell
#import "ASWallAttachmentCell.h"

// Networking
#import "ASServerManager.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

// Other
#import "UIColor+HEX.h"
#import "ASImageViewGallery.h"



float        offset = 8.f;
float        heightText   = 27.f;


static float heightPhoto  = 40.f;
static float heightShared = 33.f;

static float offsetBeforePhoto                = 8.f;
static float offsetBetweenPhotoAndText        = 3.f;
static float offsetBetweenTextAndShared       = 8.f;
static float offsetAfterShared                = 6.f;


static NSString* identifierWall      = @"ASWallCell";

static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    
    size.width *= height / size.height;
    size.height = height;
    
    return size;
}



@interface ASDetailTVC () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray* arrayComments;

@property (assign,nonatomic)  BOOL loadingData;
@property (assign,nonatomic)  BOOL firstTimeAppear;

@property (strong,nonatomic) NSMutableArray *imageViewSize;

@end




@implementation ASDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSLog(@"viewDidLoad ASDetailTVC");
    //self.group = [[ASGroup alloc] init];
   
    self.arrayComments  = [NSMutableArray array];
    self.imageViewSize  = [NSMutableArray array];
    
    self.loadingData = YES;
    self.firstTimeAppear = YES;

    
    self.navigationController.navigationBar.barStyle     = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:1.000];
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
  
        [self getCommentFromServer];
    }
    
}


#pragma mark - Server


-(void) getCommentFromServer {
   
    NSString* ownerID;
    
    if (self.group) {
        ownerID = self.group.groupID;
    } else if (self.user) {
        ownerID = self.user.userID;
    }
    
    [[ASServerManager sharedManager] getCommentFromPost:ownerID inPost:self.postID withOffset:[self.arrayComments count] count:20
                                              onSuccess:^(NSArray *comments) {
                                                  
                                            
                                   if ([comments count] > 0) {
                                                      
                                                      
                                                      
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                          
                                              
                                              NSMutableArray* arrPath = [NSMutableArray array];
                                       
                                       //for (NSInteger i=[self.arrayComments count]; i<=[comments count]+[self.arrayComments count]-1; i++) {

                                           for (NSInteger i=0; i<=[comments count]-1; i++) {
                                       
                                            // for (NSInteger i=[comments count]; i==0; i--) {

                                                   NSLog(@"Добавляем %ld",(long)i);
                                                  [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                              }
                                              
                                       
                                              //NSRange range = {0, [comments count]};
                                              //[self.arrayComments insertObjects:comments atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
                                              [self.arrayComments addObjectsFromArray:comments];

                                       
                                       
                                           // for (int i = (int)[self.arrayComments count] - (int)[comments count]; i < [self.arrayComments count]; i++) {
                                       
                                             for (NSInteger i=0; i<=[comments count]-1; i++) {
                                           //  for (NSInteger i=[comments count]; i==0; i--) {

                                                  CGSize newSize = [self setFramesToImageViews:nil imageFrames:[[self.arrayComments objectAtIndex:i] attachments]
                                                                                     toFitSize:CGSizeMake(self.view.frame.size.width-16, self.view.frame.size.width-16)];
                                                  
                                                  [self.imageViewSize addObject:[NSNumber numberWithFloat:roundf(newSize.height)]];
                                              }
                                              
                                       
                                              dispatch_sync(dispatch_get_main_queue(), ^{
                                                  
                                                   [self.tableView beginUpdates];
                                                   [self.tableView insertRowsAtIndexPaths:arrPath withRowAnimation:UITableViewRowAnimationBottom];
                                                   [self.tableView endUpdates];
                                                  
                                                   self.loadingData = NO;
                                                   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrayComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];


                                              });
                                             });

                                                  
                                        }
                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  
                                              }];
    
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCellStyleValue2
    
   
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if ([cell isKindOfClass:[ASWallAttachmentCell class]]) {
    
        
        ASComment* commet = self.arrayComments [indexPath.row];
        
        float  height = 0;
        float  heightText   = 27.f;
        
        if (![commet.text isEqualToString:@""]) {
            height = height + (int)[self heightLabelOfTextForString:commet.text fontSize:14.f widthLabel:self.view.frame.size.width-(offset*2)];
        }
        
        if ([commet.attachments count] > 0) {
            height = height + [[self.imageViewSize objectAtIndex:indexPath.row]floatValue];
        }
        
        return (offsetBeforePhoto+heightPhoto)+(offsetBetweenPhotoAndText+height)+(offsetBetweenTextAndShared+heightShared)+(offsetAfterShared);

    }
    
    
    return 44.f;
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayComments count];//+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    //if (indexPath.section == 0) {
        
       /* if (indexPath.row == 0) {
            //UITableViewCellStyleValue2
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
            }
            
            cell.textLabel.text = @"Load More";
            return cell;
        }
    
        else {*/
            
        
            ASWallAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierWall];
            
            if (!cell) {
                cell = [[ASWallAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWall];
            }
            
            ASComment *comment = self.arrayComments[indexPath.row];
        
            cell.textPost.text = comment.text;
            
            cell.likeLabel.text  = ([comment.likes length]>3)    ? ([NSString stringWithFormat:@"%@k",[comment.likes substringToIndex:1]]) : (comment.likes);
            cell.likeButton.tag  = indexPath.row;
           [cell.likeButton     addTarget:self action:@selector(addLikeOnPost:) forControlEvents:UIControlEventTouchUpInside];
            
        
             if (comment.user) {
                 cell.fullName.text = [NSString stringWithFormat:@"%@ %@",comment.user.firstName, comment.user.lastName];
             } else if (comment.group) {
                 cell.fullName.text = comment.group.fullName;
                 }
            
         
            if (comment.canLike == NO) {
                cell.likeView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
            } else {
                cell.likeView.backgroundColor = [UIColor clearColor];
            }
            

            
            __weak ASWallAttachmentCell *weakCell = cell;
            
            NSURL* url = [[NSURL alloc] init];
            if (comment.user.photo_100URL) {
                url = comment.user.photo_100URL;
            } else {
                url = comment.group.photo_100URL;
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
            
            if ([comment.attachments count] > 0) {
                
                CGPoint point = CGPointZero;
                
                float sizeText = [self heightLabelOfTextForString:cell.textPost.text fontSize:14.f widthLabel:CGRectGetWidth(self.view.bounds)-2*8];
                point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame),sizeText+(offsetBeforePhoto + heightPhoto + offsetBetweenPhotoAndText));
                
                
                CGSize sizeAttachment = CGSizeMake(CGRectGetWidth(self.view.bounds)-2*offset, CGRectGetWidth(self.view.bounds)-2*offset);
                
                ASImageViewGallery *galery = [[ASImageViewGallery alloc]initWithImageArray:comment.attachments startPoint:point withSizeView:sizeAttachment];
                galery.tag = 11;
                [cell addSubview:galery];
            }
            return cell;
            
        
  




    return nil;
}




#pragma mark - TextImageConfigure

- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageFrames.count;
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
