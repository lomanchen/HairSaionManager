//
//  BranchPolicy.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-7.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "BranchPolicy.h"

@implementation BranchPolicy

- (UIViewController*)createRightVC
{
    //return [[ProductRSViewController alloc]initWithNibName:@"ProductRSViewController" bundle:nil];
    return [[UIStoryboard storyboardWithName:@"BranchRSViewController" bundle:nil] instantiateInitialViewController];
}
@end
