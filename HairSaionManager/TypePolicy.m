//
//  TypePolicy.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-25.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "TypePolicy.h"

@implementation TypePolicy


- (UIViewController*)createRightVC
{
    //return [[ProductRSViewController alloc]initWithNibName:@"ProductRSViewController" bundle:nil];
    return [[UIStoryboard storyboardWithName:@"ProductRSStoryboard" bundle:nil] instantiateInitialViewController];
}

@end
