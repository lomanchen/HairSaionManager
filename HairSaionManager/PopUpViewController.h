//
//  PopUpViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopUpSubViewController;
@class PopUpViewController;
@protocol PopUpViewControllerDeleage <NSObject>
@required
- (BOOL)viewWillPopUpWithSubViewController:(PopUpSubViewController*)subVc animated:(BOOL)animated; //return NO to not show
- (BOOL)viewWillHideWithSubViewController:(PopUpSubViewController*)subVc animated:(BOOL)animated; //return NO to not hide
- (void)viewDidHide:(PopUpViewController*)vc;
- (void)viewDidShow:(PopUpViewController*)vc;

@end
@interface PopUpViewController : UIViewController
@property (nonatomic, assign)id<PopUpViewControllerDeleage> popUpDeleage;
@property (nonatomic, strong)PopUpSubViewController* subViewController;
- (id)initWithContentViewController:(PopUpSubViewController*)contentViewController;
- (id)initWithNavContentViewController:(UINavigationController*)nav;

- (void)show:(UIView*)inView andAnimated:(BOOL)animated;
- (void)hide:(BOOL)animated;

- (void)setContentViewController:(PopUpSubViewController*)contentViewController;
- (void)setVisiable:(BOOL)flag inView:(UIView *)inView;
@end
