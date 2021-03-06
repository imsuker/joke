//
//  SettingsViewController.m
//  Joke
//
//  Created by cao on 13-8-19.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"
#import "UserModel.h"
#import "CollectListViewController.h"
#import "SettingsLogoutCell.h"
#import "MyAccountViewController.h"
#import "VipIntroduceViewController.h"
#import "UMFeedbackViewController.h"
#import "AboutUsViewController.h"

#define JD_KEY_UMENG_APPKEY @"521d51b256240bf69103cc78"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    titleLabel.text = @"个人中心";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    _settingModel = [[SettingsModel alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedback) name:UMFBCheckFinishedNotification object:nil];
    _newFeedback = 0;
    [UMFeedback checkWithAppkey:JD_KEY_UMENG_APPKEY];
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
    return [_settingModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_settingModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *name = [_settingModel nameOfRow:indexPath.row section:indexPath.section];
    NSString *idItem = [_settingModel idOfRow:indexPath.row section:indexPath.section];

    // Configure the cell...
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if([idItem isEqual:JD_KEY_SETTINGS_Collect]){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d条", [UserModel shareInstance].countLikedIds];
        cell.detailTextLabel.textColor = JD_FONT_COLOR_999;
    }
    if([idItem isEqual:JD_KEY_SETTINGS_feedback]){
        cell.detailTextLabel.textColor = JD_FONT_COLOR_999;
        NSString *count = _newFeedback != 0?[NSString stringWithFormat:@"%d条",_newFeedback] : @"";
        cell.detailTextLabel.text = count;
    }
    
    if([idItem isEqual:JD_KEY_SETTINGS_logout]){
        cell = [[SettingsLogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    NSString *idItem = [_settingModel idOfRow:indexPath.row section:indexPath.section];
    if([idItem isEqual:JD_KEY_SETTINGS_Account]){
        if([UserModel shareInstance].isLogin){
            MyAccountViewController *myaccount = [[MyAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:myaccount animated:YES];
        }else{
            VipIntroduceViewController *vip = [[VipIntroduceViewController alloc] initWithNibName:@"VipIntroduceViewController" bundle:nil];
            [self.navigationController pushViewController:vip animated:YES];
        }
    }
    if([idItem isEqual:JD_KEY_SETTINGS_Collect]){
        CollectListViewController *collect = [[CollectListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:collect animated:YES];
    }
    if([idItem isEqual:JD_KEY_SETTINGS_About]){
        AboutUsViewController *about = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
        [self.navigationController presentModalViewController:about animated:YES];
    }
    if([idItem isEqual:JD_KEY_SETTINGS_feedback]){
        UMFeedbackViewController *feedback = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
        feedback.appkey = JD_KEY_UMENG_APPKEY;
        [self.navigationController pushViewController:feedback animated:YES];
        [feedback.mContactView setHidden:YES];
        if(_newFeedback !=0){
            _newFeedback = 0;
            [self updateFeedBack];
        }
    }
    if([idItem isEqual:JD_KEY_SETTINGS_support]){
        if(NSClassFromString(@"SKStoreProductViewController") == nil){
            [self supportAppStore];
            return;
        }
        SKStoreProductViewController *sk = [[SKStoreProductViewController alloc] init];
        sk.delegate = self;
        LoadingViewController *loadingView = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
        [self addChildViewController:loadingView];
        [self.view addSubview:loadingView.view];
        __weak LoadingViewController *weakLoadingView = loadingView;
        [sk loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:JD_CONFIG_APPLE_ID} completionBlock:^(BOOL result, NSError *error) {
            [weakLoadingView stop];
            if(error){
                [self supportAppStore];
            }else{
                [self presentModalViewController:sk animated:YES];
            }
        }];
        
    }
    if([idItem isEqual:JD_KEY_SETTINGS_logout]){
        [UserModel saveLastIdToBackend];
        [[UserModel shareInstance] logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)supportAppStore{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",JD_CONFIG_APPLE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)feedback{
    NSLog(@"finish get feedback:%d", [UMFeedback sharedInstance].newReplies.count);
    _newFeedback = [UMFeedback sharedInstance].newReplies.count;
    if(_newFeedback == 0){
        return;
    }
    [self updateFeedBack];
}
-(void)updateFeedBack{
    NSIndexPath *pathForFeedback = [_settingModel indexPathOfFeedback];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[pathForFeedback] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
@end
