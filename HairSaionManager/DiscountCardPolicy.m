//
//  DiscountCardPolicy.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-8.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "DiscountCardPolicy.h"

@implementation DiscountCardPolicy
- (UIViewController*)createRightVC
{
    //return [[ProductRSViewController alloc]initWithNibName:@"ProductRSViewController" bundle:nil];
    return [[UIStoryboard storyboardWithName:@"DiscountCardLSViewController" bundle:nil] instantiateInitialViewController];
}

@end
