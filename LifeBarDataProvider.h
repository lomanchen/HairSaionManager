//
//  LifeBarDataProvider.h
//  HairSaionManager
//
//  Created by chen loman on 13-4-1.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizationItem.h"
#import "ProductTypeItem.h"
#import "ProductShowingDetail.h"
#import "DiscountCardItem.h"


#define LB_PRODUCT_TYPE_ROOT 0

//for pic type
#define LB_PRODUCT_PIC_TYPE_DEFAULT 0
#define LB_PRODUCT_PIC_TYPE_THUMB 0
#define LB_PRODUCT_PIC_TYPE_MIDDLE 1
#define LB_PRODUCT_PIC_TYPE_FULL 2
#define LB_PRODUCT_PIC_TYPE_HEADER 3
#define LB_PRODUCT_PIC_TYPE_LEFT 4
#define LB_PRODUCT_PIC_TYPE_RIGHT 5
#define LB_PRODUCT_PIC_TYPE_BACK 6
#define LB_PRODUCT_PIC_TYPE_NOFACE 7

#define LB_ORG_PIC_TYPE_DEFAULT 0
#define LB_ORG_PIC_TYPE_THUMB 0
#define LB_ORG_PIC_TYPE_MIDDLE 1
#define LB_ORG_PIC_TYPE_FULL 2
#define LB_ORG_PIC_TYPE_HEADER 3
#define LB_ORG_PIC_TYPE_LEFT 4
#define LB_ORG_PIC_TYPE_RIGHT 5
#define LB_ORG_PIC_TYPE_BACK 6
#define LB_ORG_PIC_TYPE_NOFACE 7

#define LB_DISCOUNTCARD_PIC_TYPE_DEFAULT 0
#define LB_DISCOUNTCARD_PIC_TYPE_THUMB 0
#define LB_DISCOUNTCARD_PIC_TYPE_MIDDLE 1
#define LB_DISCOUNTCARD_PIC_TYPE_FULL 2
#define LB_DISCOUNTCARD_PIC_TYPE_HEADER 3
#define LB_DISCOUNTCARD_PIC_TYPE_LEFT 4
#define LB_DISCOUNTCARD_PIC_TYPE_RIGHT 5
#define LB_DISCOUNTCARD_PIC_TYPE_BACK 6
#define LB_DISCOUNTCARD_PIC_TYPE_NOFACE 7

#define LB_PRODUCT_PIC_DEFALUT_FULL @"default_full.JPG"
#define LB_PRODUCT_PIC_DEFALUT_THUMB @"default.JPG"


//for discount type
#define LB_PRODUCT_DISCOUNT_TYPE_PERCENT 0
#define LB_PRODUCT_DISCOUNT_TYPE_CUT 1

//for org type
#define LB_ORG_TYPE_DEFAULT 0

#define LB_ORG_TYPE_ROOT 0
#define LB_ORG_ROOT @"root"

//for discount overlay type
#define LB_DISCOUNT_CARD_NO_OVERLAY 0
#define LB_DISCOUNT_CARD_CAN_OVERLAY 1

//for product state
#define LB_PRODUCT_STATE_ONSALE 0

//for org status
#define LB_PRODUCT_STATUS_NORMAL 0


//for product priority
#define LB_PRODUCT_PRIORITY_NORMAL 0

//for product custom flag
#define LB_PRODUCT_CUSTOMIZE_FLAG_OFF 0
#define LB_PRODUCT_CUSTOMIZE_FLAG_ON 1


#define LB_ORG_CONF_KEY_SHOW_DISCOUNT_CARD @"showDiscountCard"
#define LB_ORG_CONF_VALUE_YES @"1"
#define LB_ORG_CONF_VALUE_NO @"0"
#define LB_ORG_CONF_KEY_SHOW_SUBBRANCH @"showSubbranch"

//pic reftype

#define LB_PIC_TYPE_PRODUCT 0
#define LB_PIC_TYPE_ORG 1
#define LB_PIC_TYPE_DISCOUNTCARD 2

#define LB_MAX_RECORD_COUNT 9999

@interface LifeBarDataProvider : NSObject
+ (LifeBarDataProvider*)shareInstance;
- (NSDictionary*)resultDic;
- (OrganizationItem*)getCurrentOrgInfo;
- (NSString*)getLastError;
- (NSString*)imgPathForProduct;
- (NSString*)imgPathForOrg;
- (BOOL)orgLogin:(NSString*)orgAccount andPwd:(NSString*)password;
- (NSArray*)getTypesWithOrgId:(NSInteger)orgId;
- (NSArray*)productTypesWithParentId:(NSInteger)parent;
- (NSMutableArray*)productTypesWithParentIdRecursive:(NSInteger)parent;
- (BOOL)deleteProductTypeById:(NSInteger)typeId;
- (BOOL)updateProductType:(ProductTypeItem*)item;
- (BOOL)addProductType:(ProductTypeItem*)item;
- (BOOL)updateOrgConfWithOrgId:(NSInteger)orgId andKey:(NSString*)key andValue:(NSString*)value;
- (BOOL)addOrgConfWithOrgId:(NSInteger)orgId andKey:(NSString*)key andValue:(NSString*)value;
- (ProductTypeItem*)getProductTypeById:(int)typeId;
- (NSString*)titleForProductType:(int)typeId;
- (NSMutableArray*)getProductsWithOrgId:(NSInteger)orgId andTypeId:(int)typeId;
- (BOOL)addProduct:(ProductShowingDetail*)item;
- (BOOL)updateProduct:(ProductShowingDetail*)item;
- (BOOL)deleteProductById:(long)productId;
- (BOOL)loadPicForProduct:(long)productId withType:(short)type completionHandler:(void (^)(NSData*)) handler;
- (BOOL)loadPicLinkForProduct:(long)productId withType:(short)type completionHandler:(void (^)(NSString*)) handler;
- (NSString*)loadPicLinkForProduct:(long)productId withType:(short)type;
- (BOOL)loadPicLinksForItem:(PsDataItem *)item withRefType:(short)refType;
- (BOOL)addProduct:(long)productId toType:(NSInteger)typeId;
- (BOOL)dropType:(NSInteger)typeId fromProduct:(long)productId;
- (BOOL)updateTypes:(NSArray*)types forProduct:(long)productId;
- (NSMutableArray*)getProductTypesWithProductId:(long)productId;
- (NSString*)uploadImg:(NSString*)imgFileName;
- (BOOL)updateProductPics:(ProductShowingDetail*)item;
- (NSMutableArray*)getSubOrgByOrgId:(NSInteger)orgId;
- (BOOL)addOrg:(OrganizationItem*)item;
- (BOOL)updateOrg:(OrganizationItem*)item;
- (BOOL)deleteOrgById:(NSInteger)orgId;
- (BOOL)updatePics:(PsDataItem*)item forRefType:(short)refType;
- (NSMutableArray*)getDiscountCardByOrgId:(NSInteger)orgId;
- (BOOL)addDiscountCard:(DiscountCardItem*)item;
- (BOOL)updateDiscountCard:(DiscountCardItem*)item;
- (BOOL)deleteDiscountCardById:(NSInteger)cardId;

@end
