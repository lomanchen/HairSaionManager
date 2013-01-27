//
//  ProductTypeItem.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-24.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "ProductTypeItem.h"
#import "ProductType.h"
@implementation ProductTypeItem
@synthesize typeParent, typePricingId, productType;
- (ProductTypeItem*)initWithObject:(ProductType *)type
{
    self = [super init];
    if (self)
    {
        [self setValueByProductType:type];
    }
    return self;
}


- (void)setValueByProductType:(ProductType*)type
{
    self.name = type.typeName;
    self.productType = type.productType;
    self.typePricingId = type.typePricingId;
    self.typeParent = type.typeParent;
    self.key = self.productType;
}

@end
