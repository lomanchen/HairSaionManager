//
//  ProductTypeItem.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-24.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "PsDataItem.h"
@class ProductType;
@interface ProductTypeItem : PsDataItem

@property (nonatomic, strong) NSString * productType;
@property (nonatomic, strong) NSString * typeParent;
@property (nonatomic, strong) NSString * typePricingId;


- (ProductTypeItem*)initWithObject:(ProductType*)type;
- (void)setValueByProductType:(ProductType*)type;
@end
