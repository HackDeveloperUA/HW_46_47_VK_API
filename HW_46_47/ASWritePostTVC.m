//
//  ASWritePostTVC.m
//  HW_46_47
//
//  Created by MD on 07.10.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASWritePostTVC.h"
#import "ASWritePostCell.h"

@interface ASWritePostTVC () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSString* textFromTextView;

@end



@implementation ASWritePostTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneAction:)];
    
    
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
    
    return cell;
}



#pragma mark - Action

-(void) doneAction:(UIBarButtonItem*) sender {

    NSLog(@"doneAction");
    NSLog(@"text from textView = %@",self.textFromTextView);

    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}



- (void)textViewDidChange:(UITextView *)textView {
    self.textFromTextView = textView.text;
}



@end
