//
//  BaseLeftSideViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarPolicy.h"
@class MainSplitViewController;
@class PsDataItem;
@class BaseRightSideViewController;
@interface BaseLeftSideViewController : UIViewController
@property (nonatomic, strong)UINavigationController* detailNav;
@property (nonatomic, strong)BaseTabBarPolicy* policy;
@property (nonatomic, strong)NSMutableArray* items;
@property (nonatomic, strong)MainSplitViewController* mainVc;
@property (nonatomic, strong)UIViewController* currentRvc;
@property (nonatomic, assign)BOOL rightSideShowed;

- (void)loadData;
- (void)pushRSViewController:(UIViewController*)rvc;
- (void)hideRSViewController:(BOOL)animated;
- (void)reloadData;

- (void)loadNavItem;
- (void)addObject;
- (void)addObjectCancel;
- (void)onSave:(PsDataItem*)dataItem;

@end
