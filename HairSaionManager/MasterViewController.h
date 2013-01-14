//
//  MasterViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-5.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class MainSplitViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) MainSplitViewController *splitViewController;



@end
