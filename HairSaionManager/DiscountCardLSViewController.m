//
//  DiscountCardLSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-8.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "DiscountCardLSViewController.h"
#import "ProductRSViewController.h"
#import "ProductCell.h"
#import "DiscountCardItem.h"
#import "DiscountCardRSViewController.h"
#import "EmpMainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface DiscountCardLSViewController ()

@end

@implementation DiscountCardLSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    DiscountCardItem* item = [self.items objectAtIndex:indexPath.row];
    cell.imageView.image = [item defaultImgLink];
    //cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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


- (void)loadData
{
    DataAdapter * da = [DataAdapter shareInstance];
    int count = [da.discountCards count];
    self.items = [NSMutableArray array];
    for (int i = 0; i < count; i ++)
    {
        DiscountCardItem* item = [[DiscountCardItem alloc]initWithObject:(da.discountCards)[i]];
        [self.items addObject:item];
    }
    
}



- (void)removeObjectAtIndex:(NSInteger)index
{
    DiscountCardItem* item = [self.items objectAtIndex:index];
    [[DataAdapter shareInstance]deleteDiscountCardByCardId:item.key];
    [super removeObjectAtIndex:index];
}

- (void)loadNavItem
{
    [super loadNavItem];
    if (self.navigationItem)
    {
        NSMutableArray* leftItems = [NSMutableArray array];
        UIBarButtonItem* itemMain = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(onBarMain:)];
        itemMain.tag = -2;
        [leftItems addObject:itemMain];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:leftItems];
    }
}

- (void)onBarMain:(id)sender
{
    UINavigationController* nav = self.mainVc.navigationController;
    [nav popViewControllerAnimated:YES];
    
}


- (void)addObject
{
    [super addObject];
    NSString* cardId = [[DataAdapter shareInstance]createNewDiscountCard];
    DiscountCardItem* item = [[DiscountCardItem alloc]initWithObject:[[DataAdapter shareInstance]discountCardByCardId:cardId]];
    UINavigationController* vc = (UINavigationController*)[self.policy createRightVC];
    BaseRightSideViewController* rvc = vc.viewControllers[0];
    rvc.rootSplitViewController = self.mainVc;
    rvc.leftViewController = self;
    [rvc setData:item];
    rvc.isAddMode = YES;
    [self pushRSViewController:vc];
}

- (void)addObjectCancel
{
    BaseRightSideViewController* rvc = ((UINavigationController*)self.currentRvc).viewControllers[0];
    DiscountCardItem* item = rvc.item;
    [[DataAdapter shareInstance]deleteDiscountCardByCardId:item.key];
}

@end
