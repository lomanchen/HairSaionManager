//
//  TableLSViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-25.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "BaseTabBarPolicy.h"
#import "BaseLeftSideViewController.h"
@class PsDataItem;

@interface TableLSViewController : BaseLeftSideViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)IBOutlet UITableView* tableView;

@property (nonatomic, assign)int lastSelectIndex;
@property (nonatomic, assign)int currentEditIndex;


- (void)reloadRowWithData:(PsDataItem*)dataItem;
- (void)addRowWithData:(PsDataItem*)dataItem;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)onBarItem:(id)sender;


@end
