//
//  ProductPolicy.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductPolicy.h"
#import "ProductRSViewController.h"

@implementation ProductPolicy


- (UIViewController*)createRightVC
{
    //return [[ProductRSViewController alloc]initWithNibName:@"ProductRSViewController" bundle:nil];
    return [[UIStoryboard storyboardWithName:@"ProductRSStoryboard" bundle:nil] instantiateInitialViewController];
}
@end
