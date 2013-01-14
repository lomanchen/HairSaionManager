//
//  KPOperation+LCAddition.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//


#import "KPOperation+LCAddition.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "failToIgnore";

@implementation KPOperation (LCAddition)
@dynamic failToIgnore;
- (void)setFailToIgnore:(BOOL)newValue
{
	//objc_setAssociatedObject(self, ObjectTagKey, newValue, OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(self, ObjectTagKey, [NSNumber numberWithBool:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)failToIgnore
{
    return [objc_getAssociatedObject(self, ObjectTagKey) boolValue];
}
@end
