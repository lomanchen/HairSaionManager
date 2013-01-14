//
//  PopUpSubViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopUpViewController;
@interface PopUpSubViewController : UIViewController
@property (nonatomic, strong)PopUpViewController* popUpController;

- (IBAction)onCancel:(id)sender;

@end
