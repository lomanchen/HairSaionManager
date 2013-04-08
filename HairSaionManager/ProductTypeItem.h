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
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger parent;



- (ProductTypeItem*)initWithObject:(ProductType*)type;
- (ProductTypeItem*)initWithDic:(NSDictionary*)dic;

- (void)setValueByProductType:(ProductType*)type;
- (void)setTypeIdWithObject:(NSNumber*)number;
@end
