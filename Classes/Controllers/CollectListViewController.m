//
//  CollectViewController.m
//  Joke
//
//  Created by cao on 13-8-21.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "CollectListViewController.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "PopHintViewController.h"
#import "CollectJokeViewController.h"

@interface CollectListViewController ()

@end

@implementation CollectListViewController

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
    
    _flag = -1; 

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
    titleLabel.text = @"喜欢";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    _collects = [NSMutableArray array];
    
    [self loadData];
    
}
-(void)loadData{
    if(!_loadingViewController){
        _loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [self addChildViewController:_loadingViewController];
    [self.view addSubview:_loadingViewController.view];
    
    [self fetchData];
}
-(void)fetchData{
    NSString *urlString = [iApi sharedInstance].collects;
    urlString = [iApi addUrl:urlString key:@"userid" value:[NSString stringWithFormat:@"%d",[UserModel shareInstance].userId]];
    urlString = [iApi addUrl:urlString key:@"flag" value:[NSString stringWithFormat:@"%d", _flag]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"==fetchCollects fetch begin:%@", [url description]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [LoadingViewController stop:_loadingViewController];
        NSInteger code = [JSON[@"code"] integerValue];
        [self stopLoading];
        if(code == 1){
            //TODO flag
            [_collects addObjectsFromArray:JSON[@"data"][@"items"]];
            if(JSON[@"data"][@"flag"]){
                _flag = [JSON[@"data"][@"flag"] integerValue];
            }else{
                self.hasMore = NO;
            }
            [self.tableView reloadData];
        }else{
            NSString *errmsg = JSON[@"data"][@"errmsg"];
            PopHintViewController *pop = [[PopHintViewController alloc] initWithText:errmsg?errmsg:@""];
            [self addChildViewController:pop];
            [self.view addSubview:pop.view];
        }
        NSLog(@"==fetchCollects fetch success:%@", [JSON description]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self stopLoading];
        [LoadingViewController stop:_loadingViewController];
        NSLog(@"===fetchCollects fetch fail:%@", error);
        PopHintViewController *pop = [[PopHintViewController alloc] initWithText:@""];
        [self addChildViewController:pop];
        [self.view addSubview:pop.view];
    }];
    [operation start];
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
    return _collects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = [indexPath row];
    cell.textLabel.text = _collects[row][@"title"];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSInteger row = [indexPath row];
    NSInteger jokeId = [_collects[row][@"id"] integerValue];
    CollectJokeViewController *joke = [[CollectJokeViewController alloc] initWithNibName:@"CollectJokeViewController" bundle:nil];
    joke.visitId = jokeId;
    [self.navigationController pushViewController:joke animated:YES];
}

-(void)refresh{
    [self fetchData];
}

@end
