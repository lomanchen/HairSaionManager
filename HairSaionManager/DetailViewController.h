//
//  DetailViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-5.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@interface DetailViewController : UIViewController <MGSplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) MGSplitViewController *splitViewController;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
