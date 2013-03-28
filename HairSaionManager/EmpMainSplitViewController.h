//
//  EmpMainSplitViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-3-7.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "MGSplitViewController.h"

#import "NGTabBarController.h"
/*
 typedef enum {
 LeftTabBarViewControllerProduct = 0,
 LeftTabBarViewControllerPolicy,
 LeftTabBarViewControllerMap,
 LeftTabBarViewControllerShoppingCart
 } LeftTabBarViewControllerItem;
 */

#define SPLIT_POSITION_MID 512.0f
#define SPLIT_POSITION_RIGHT_END 1024.0f

@interface EmpMainSplitViewController : MGSplitViewController<MGSplitViewControllerDelegate,NGTabBarControllerDelegate>
@end

