//
//  ASWritePostTVC.m
//  HW_46_47
//
//  Created by MD on 07.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASWritePostTVC.h"
#import "ASWritePostCell.h"

#import "ASServerManager.h"

#import "SCLAlertView.h"

@interface ASWritePostTVC () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSString* textFromTextView;
@property (strong, nonatomic) UITextView* superTextView;
@end



@implementation ASWritePostTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneAction:)];
    
    UIBarButtonItem *cancleButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancleAction:)];

    self.navigationItem.leftBarButtonItem = cancleButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return CGRectGetHeight(self.view.frame)/2;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    static NSString* identifier = @"writeCell";
    
    ASWritePostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (!cell) {
        cell = [[ASWritePostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textView.text = @"Test";
    self.superTextView = cell.textView;
    
    return cell;
}


-(void) cancleAction:(UIBarButtonItem*) sender {
    
     [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}




#pragma mark - Action

-(void) doneAction:(UIBarButtonItem*) sender {

    NSLog(@"doneAction");
    NSLog(@"text from textView = %@",self.textFromTextView);

    [self.superTextView resignFirstResponder];

    
    [[ASServerManager sharedManager] addPostOnWall:self.currentOwnerID
                                       withMessage:self.textFromTextView
                                         onSuccess:^(NSDictionary *result) {
                                             
                                             [self successAlert];
                                             
                                         } onFailure:^(NSError *error, NSInteger statusCode) {
                                             
                                         }];
    
}



- (void)textViewDidChange:(UITextView *)textView {
    self.textFromTextView = textView.text;
}

-(void) successAlert {
   
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"Готово" target:self selector:@selector(firstButton:)];
    [alert showSuccess:self title:@"Отлично" subTitle:@"Ваш пост добавлен" closeButtonTitle:nil duration:0.0f];


}

-(void) firstButton:(id) sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
