//
//  HomeViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-17.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SyncOperationManager.h"
#import "PopUpViewController.h"

@interface HomeViewController : UIViewController<SyncResultDeleage, PopUpViewControllerDeleage>

@end
