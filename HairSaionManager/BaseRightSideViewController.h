//
//  BaseRightSideViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarPolicy.h"
#import "PsDataItem.h"
#import "ImagePickerViewController.h"

@class MGSplitViewController;
@class BaseLeftSideViewController;

@interface BaseRightSideViewController : UITableViewController<ImagePickerViewControllerDeleage>
@property (nonatomic, strong)BaseTabBarPolicy* policy;
@property (nonatomic, strong)PsDataItem* item;
@property (nonatomic, strong)NSIndexPath* lastSelectIndex;

@property (nonatomic, strong)NSString* identifier;
@property (nonatomic, strong)MGSplitViewController* rootSplitViewController;
@property (nonatomic, strong)BaseLeftSideViewController* leftViewController;
@property (nonatomic, assign)BOOL isAddMode;

- (void)setData:(PsDataItem *)item;
@end
