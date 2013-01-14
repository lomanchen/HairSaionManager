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
@interface BaseTabBarPolicy()
@property (nonatomic, strong)NSString* subType;
@end
@implementation BaseTabBarPolicy
@synthesize subType=_subType;

- (NSString*)subType
{
    return _subType;
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
    return [NSString stringWithFormat:@"Product%@%d", _subType == nil ? @"ALL" : _subType, index];
}
- (void)setFilter
{
    [[DataAdapter shareInstance]setFilterByTypeId:_subType];
}

- (NSString*)title
{
    return [[DataAdapter shareInstance]currentFilterLinkString];
}


- (BOOL)need2RefreshWhenAppear
{
    return NO;
}

- (void)refreshData
{
    
}

- (id)initWithSubType:(NSString *)subType
{
    self = [super init];
    if (self)
    {
        self.subType = subType;
        if (nil == self.subType)
        {
            self.subType = @"";
        }
    }
    return self;
}

@end
