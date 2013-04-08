//
//  TypeViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-5.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAdapter.h"
@class MainViewController;

@interface TypeViewController : UITableViewController
@property (nonatomic, strong)UIPopoverController* popoverController;
@property (nonatomic, strong)MainViewController* mainViewController;

@end
