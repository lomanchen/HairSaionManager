//
//  MainViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-5.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIPopoverControllerDelegate>
@property (nonatomic, assign)int lastSelect;
- (IBAction)doSomeTest:(id)sender;

@end
