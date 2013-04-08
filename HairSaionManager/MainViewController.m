//
//  MainViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-5.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "MainViewController.h"
#import "TypeViewController.h"
#import "MySplitViewController.h"
#import "MainSplitViewController.h"
#import "PopMideaPickerViewController.h"
@interface MainViewController ()
@end

@implementation MainViewController
@synthesize lastSelect;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;//UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"segue=%@", identifier);
    if ([@"showType"isEqualToString:identifier])
    {
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue=%@", [segue identifier]);
    NSString* identifier = [segue identifier];
    if ([@"showType"isEqualToString:identifier])
    {
        self.lastSelect = -1;
        UIStoryboardPopoverSegue* popSegue = segue;
        TypeViewController* dest = segue.destinationViewController;
        dest.popoverController = popSegue.popoverController;
        dest.mainViewController = self;
        dest.popoverController.delegate = self;
    }
    else if ([@"setData2Edit"isEqualToString:identifier])
    {
        MainSplitViewController* msvc = segue.destinationViewController;
    }
self.view.backgroundColor = [UIColor grayColor];
self.view.alpha = 0.9;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if (lastSelect != -1)
    {
        //MainSplitViewController* vc = [[MainSplitViewController alloc]init];
        //[self.navigationController pushViewController:vc animated:YES];
        lastSelect = -1;
    }
    return YES;
}

- (IBAction)doSomeTest:(id)sender
{
    PopMideaPickerViewController* viewController = [[PopMideaPickerViewController alloc] initWithNibName:@"Taking_Photos_with_the_CameraViewController_iPad" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
