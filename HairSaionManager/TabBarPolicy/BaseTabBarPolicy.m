//
//  BaseTabBarPolicy.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "BaseTabBarPolicy.h"
#import "BaseRightSideViewController.h"
#import "BaseLeftSideViewController.h"
#import "LifeBarDataProvider.h"
@interface BaseTabBarPolicy()
{
    NSInteger subType;
}
@end
@implementation BaseTabBarPolicy

- (NSInteger)subType
{
    return subType;
}

- (BOOL)isProduct
{
    return YES;
}
- (UIViewController*)createRightVC
{
    return [[BaseRightSideViewController alloc]init];
}

- (NSString*)genKey4Index:(NSInteger)index
{
    return [NSString stringWithFormat:@"Product%d%d", subType, index];
}
- (void)setFilter
{
    //[[DataAdapter shareInstance]setFilterByTypeId:subType];
}

- (NSString*)title
{
    return [[LifeBarDataProvider shareInstance]titleForProductType:subType];
}


- (BOOL)need2RefreshWhenAppear
{
    return NO;
}

- (void)refreshData
{
    
}

- (id)initWithSubType:(NSInteger)typeId
{
    self = [super init];
    if (self)
    {
        subType = typeId;
    }
    return self;
}

- (void)setSubType:(NSInteger)typeId
{
    subType = typeId;
}

@end
