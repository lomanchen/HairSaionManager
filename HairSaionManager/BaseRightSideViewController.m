//
//  BaseRightSideViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "BaseRightSideViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface BaseRightSideViewController ()

@end

@implementation BaseRightSideViewController
@synthesize lastSelectIndex, identifier, rootSplitViewController, leftViewController, isAddMode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isAddMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastSelectIndex = nil;
    CALayer* layer = self.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;

    //self.navigationController.navigationBarHidden = YES;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setData:(PsDataItem *)item
{
    _item = item;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.lastSelectIndex = indexPath;
    //[self.detailNav pushViewController:vc animated:NO];
    
    
}

@end
