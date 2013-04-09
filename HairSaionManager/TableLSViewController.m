//
//  BaseLeftSideViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "TableLSViewController.h"
#import "ProductShowingDetail.h"
#import "ProductPolicy.h"
#import "ProductRSViewController.h"
#import "ProductCell.h"
#import "MainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TableLSViewController ()

@end

@implementation TableLSViewController
@synthesize detailNav, lastSelectIndex, currentEditIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)init
{
    return [self initWithNibName:@"TableLSViewController"  bundle:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastSelectIndex = -1;
    self.currentEditIndex = -1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.items count];
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        self.currentEditIndex = indexPath.row;
        PsDataItem* item = [self.items objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"确定删除“%@”吗？", item.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    //        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //    }
}


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
    if (self.lastSelectIndex == indexPath.row && self.rightSideShowed == YES)
    {
        [self hideRSViewController:YES];
    }
    else
    {
        self.lastSelectIndex = indexPath.row;
        PsDataItem* item = [self.items objectAtIndex:indexPath.row];
        UINavigationController* vc = (UINavigationController*)[self.policy createRightVC];
        BaseRightSideViewController* rvc = vc.viewControllers[0];
        rvc.rootSplitViewController = self.mainVc;
        rvc.leftViewController = self;
        [rvc setData:item];
        [self pushRSViewController:vc];
    }
    //[self.detailNav pushViewController:vc animated:NO];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //delete data
        [self removeObjectAtIndex:self.currentEditIndex];
    }
}

- (void)removeObjectAtIndex:(NSInteger)index
{
    [self.items removeObjectAtIndex:self.currentEditIndex];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.currentEditIndex inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadRowWithData:(PsDataItem *)dataItem
{
    [self.items setObject:dataItem atIndexedSubscript:self.lastSelectIndex];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.lastSelectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
}
- (void)addRowWithData:(PsDataItem *)dataItem
{
    [self.items addObject:dataItem];
    NSIndexPath* insertPath = [NSIndexPath indexPathForRow:[self.items count] -1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView selectRowAtIndexPath:insertPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}

- (void)dataDidLoad
{
    [self.tableView reloadData];
}




- (void)onBarItem:(id)sender
{
}


- (void)reloadData
{
    [super reloadData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}
@end
