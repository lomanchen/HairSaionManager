//
//  BaseTabBarPolicy.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTabBarPolicy : NSObject
- (BOOL)isProduct;
- (NSInteger)subType;
- (UIViewController*)createRightVC;
- (NSString*)genKey4Index:(NSInteger)index;
- (void)setFilter;
- (void)setSubType:(NSInteger)subType;
- (NSInteger)calcPageCount;
- (NSString*)title;
- (void)setIndex;
- (id)initWithSubType:(NSInteger)typeId;
- (BOOL)need2RefreshWhenAppear;
- (void)refreshData;
- (void)bindVcPair:(UIViewController*)rvc withLvc:(UIViewController*)lvc;
@end
