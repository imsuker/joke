//
//  MyAccountViewController.m
//  Joke
//
//  Created by cao on 13-8-28.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#define JD_KEY_MYACCOUNT_USERNAME @"username"
#define JD_KEY_MYACCOUNT_EMAIL @"email"
#define JD_KEY_MYACCOUNT_CHANGEPASSWORD @"changepassword"

#import "MyAccountViewController.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"
#import "UserModel.h"
#import "ChangePasswordViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //背景颜色
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = JD_FONT_COLOR_e6ebf0;
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"我的账号";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    _rows = @[
              @{
                  @"id" : JD_KEY_MYACCOUNT_USERNAME,
                  @"name" : [UserModel shareInstance].userName,
              },
              @{
                  @"id" : JD_KEY_MYACCOUNT_EMAIL,
                  @"name" : [UserModel shareInstance].email
                  },
              @{
                  @"id" : JD_KEY_MYACCOUNT_CHANGEPASSWORD,
                  @"name" : @"修改密码"
                  }
              
              ];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSInteger row = [indexPath row];
    NSString *name = _rows[row][@"name"];
    
    // Configure the cell...
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger row = [indexPath row];
    if([_rows[row][@"id"] isEqual:JD_KEY_MYACCOUNT_CHANGEPASSWORD]){
        ChangePasswordViewController *change =[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
        [self.navigationController pushViewController:change animated:YES];
    }
}

@end
