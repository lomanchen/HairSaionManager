//
//  LifeBarDataProvider.m
//  HairSaionManager
//
//  Created by chen loman on 13-4-1.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "LifeBarDataProvider.h"
#import "LCJsonRequest.h"
#import "ASIFormDataRequest.h"
#import "OrganizationItem.h"
#import "ProductTypeItem.h"
#import "ProductShowingDetail.h"
#import "DiscountCardItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"


#define LB_ACTION_KEY_ORG_LOGIN @"json_login.do"
#define LB_ACTION_KEY_ORG_INFO @"json_orgInfo.do"
#define LB_ACTION_KEY_ORG_PRODUCTTYPES @"json_productTypes.do"
#define LB_ACTION_KEY_ORG_PRODUCTS @"json_products.do"
#define LB_ACTION_KEY_ORG_ADDPRODUCT @"json_addProduct.do"
#define LB_ACTION_KEY_ORG_UPDATEPRODUCT @"json_updateProduct.do"
#define LB_ACTION_KEY_ORG_PICPATH @"json_picPath.do"
#define LB_ACTION_KEY_ORG_DELETE_PRODUCTTYPE @"json_deleteProductType.do"
#define LB_ACTION_KEY_ORG_UPDATE_PRODUCTTYPE @"json_updateProductType.do"
#define LB_ACTION_KEY_ORG_ADD_PRODUCTTYPE @"json_addProductType.do"
#define LB_ACTION_KEY_ORG_ADD_ORGCONF @"json_addOrgConf.do"
#define LB_ACTION_KEY_ORG_UPDATE_ORGCONF @"json_updateOrgConf.do"
#define LB_ACTION_KEY_ORG_DELETE_PRODUCT @"json_deleteProduct.do"
#define LB_ACTION_KEY_ORG_PICS @"json_pics.do"
#define LB_ACTION_KEY_ORG_SUBORGS @"json_subOrgs.do"
#define LB_ACTION_KEY_ORG_ADDSUBORG @"json_addSubOrg.do"
#define LB_ACTION_KEY_ORG_UPDATE @"json_updateOrg.do"
#define LB_ACTION_KEY_ORG_DELETESUBORG @"json_deleteSubOrg.do"
#define LB_ACTION_KEY_ORG_DISCOUNTCARDS @"json_discountCards.do"
#define LB_ACTION_KEY_ORG_ADDDISCOUNTCARD @"json_addDiscountCard.do"
#define LB_ACTION_KEY_ORG_UPDATEDISCOUNTCARD @"json_updateDiscountCard.do"
#define LB_ACTION_KEY_ORG_DELETEDISCOUNTCARD @"json_deleteDiscountCard.do"


#define LB_ACTION_KEY_PRODUCT_PICS @"json_pics.do"
#define LB_ACTION_KEY_PRODUCT_PICPATH @"json_picPath.do"
#define LB_ACTION_KEY_PRODUCT_ADDPIC @"json_addPic.do"
#define LB_ACTION_KEY_PRODUCT_UPDATEPIC @"json_updatePic.do"
#define LB_ACTION_KEY_PRODUCT_UPDATEPICS @"json_updatePics.do"
#define LB_ACTION_KEY_PRODUCT_TYPES @"json_types.do"

#define LB_ACTION_KEY_UPLOAD_PIC @"fileUpload.do"
#define LB_ACTION_KEY_PRODUCT_PICFORTYPE @"json_picForType.do"
#define LB_ACTION_KEY_PRODUCT_ADDPRODUCTTOTYPE @"json_addProductToType.do"
#define LB_ACTION_KEY_PRODUCT_DROPPRODUCTTOTYPE @"json_dropProductToType.do"
#define LB_ACTION_KEY_PRODUCT_UPDATETYPES @"json_updateTypes.do"

#define LB_ACTION_KEY_FILEUPLOAD @"fileUpload.do"
#define LB_ACTION_KEY_UPDATE_PICS @"json_updatePics.do"
#define LB_ACTION_KEY_PICS @"json_pics.do"





@interface LifeBarDataProvider()
{
    NSString* serverUrl;
    NSString* orgBaseUrl;
    NSString* productBaseUrl;
    NSString* imgPathForOrg;
    NSString* imgPathForProduct;
    NSDictionary* resultDic;
    OrganizationItem* currentOrgInfo;
    NSMutableArray* currentOrgProductTypes;
    NSString* uploadedImgTmpFileName;
    NSString* lastError;    
}
@end
@implementation LifeBarDataProvider

+ (LifeBarDataProvider*)shareInstance;
{
    static dispatch_once_t pred;
    static LifeBarDataProvider *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[LifeBarDataProvider alloc] init];
        
    });
    
    return shared;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        if ([self setup])
        {
            return self;
        }
        
    }
    return nil;
}

- (BOOL)setup
{
    serverUrl = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"server"];
    if (nil == serverUrl || [serverUrl isEqualToString:@""])
    {
        NSLog(@"初始化配置失败！");
        return NO;
    }
    orgBaseUrl = [serverUrl stringByAppendingString:@"/org/"];
    productBaseUrl = [serverUrl stringByAppendingString:@"/product/"];
    //get org image path
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_PICPATH] paramDic:nil delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        imgPathForOrg = [[request getResultDic]objectForKey:@"picPath"];
    }
    if (nil == imgPathForOrg || [imgPathForOrg isEqualToString:@""])
    {
        NSLog(@"初始化配置失败！");
        return NO;
    }
    
    request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_PICPATH] paramDic:nil delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        imgPathForProduct = [[request getResultDic]objectForKey:@"picPath"];
    }
    if (nil == imgPathForProduct || [imgPathForProduct isEqualToString:@""])
    {
        NSLog(@"初始化配置失败！");
        return NO;
    }
}

- (OrganizationItem*)getCurrentOrgInfo
{
    return currentOrgInfo;
}

- (NSString*)imgPathForProduct
{
    return imgPathForProduct;
}
- (NSString*)imgPathForOrg
{
    return imgPathForOrg;
}

- (NSString*)getLastError
{
    return lastError;
}

- (NSDictionary*)resultDic
{
    return resultDic;
}

- (BOOL)orgLogin:(NSString*)orgAccount andPwd:(NSString*)password
{
    NSDictionary* paramDic = [NSDictionary dictionaryWithObjects:@[orgAccount, password] forKeys:@[@"orgAccount", @"password"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_LOGIN] paramDic:paramDic delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        resultDic = [request getResultDic];
        currentOrgInfo = [[OrganizationItem alloc]initWithDic:[resultDic objectForKey:@"org"]];
        NSArray* confList = [resultDic objectForKey:@"orgConfList"];
        currentOrgInfo.conf = [NSMutableDictionary dictionary];
        for (NSDictionary* dic in confList)
        {
            [currentOrgInfo.conf setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"name"]];
        }
        [self getTypesWithOrgId:currentOrgInfo.Id];
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (NSArray*)getTypesWithOrgId:(NSInteger)orgId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_PRODUCTTYPES] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", orgId] forKey:@"orgId"] delegate:nil doneSelector:nil errorSelector:nil];
    currentOrgProductTypes = [NSMutableArray array];
    
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        resultDic = [request getResultDic];
        NSArray* productTypeList = [resultDic objectForKey:@"productTypeList"];
        for (NSDictionary* type in productTypeList)
        {
            ProductTypeItem* item = [[ProductTypeItem alloc]initWithDic:type];
            [currentOrgProductTypes addObject:item];
        }
    }
    return currentOrgProductTypes;
}

- (NSArray*)productTypesWithParentId:(NSInteger)parent
{
    NSMutableArray* result = [NSMutableArray array];
    if (currentOrgProductTypes)
    {
        for (ProductTypeItem* item in currentOrgProductTypes)
        {
            if (item.parent == parent)
            {
                [result addObject:item];
            }
        }
    }
    else
    {
        if ([[self getTypesWithOrgId:self.getCurrentOrgInfo.Id] count] > 0)
        {
            return [self productTypesWithParentId:parent];
        }
        
    }
    return [NSArray arrayWithArray:result];
}

- (NSMutableArray*)productTypesWithParentIdRecursive:(NSInteger)parent
{
    NSMutableArray* result = [NSMutableArray arrayWithArray:[self productTypesWithParentId:parent]];
    for (ProductTypeItem* type in result)
    {
        NSMutableArray* subResult = [self productTypesWithParentIdRecursive:type.typeId];
        [result addObjectsFromArray:subResult];
    }
    return result;
}

- (BOOL)deleteProductTypeById:(NSInteger)typeId
{
    if (typeId < 0)
    {
        NSLog(@"PARAM ERROR, typeId=%d", typeId);
        return NO;
    }
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_DELETE_PRODUCTTYPE] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", typeId] forKey:@"typeId"] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        ProductTypeItem* item = [self getProductTypeById:typeId];
        if (item)
        {
            [currentOrgProductTypes removeObject:item];
        }
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)updateProductType:(ProductTypeItem *)item
{
    
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", item.typeId], item.name, [NSString stringWithFormat:@"%d", item.parent], [NSString stringWithFormat:@"%d", self.getCurrentOrgInfo.Id]] forKeys:@[@"productType.typeId", @"productType.name", @"productType.parent", @"productType.orgId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_UPDATE_PRODUCTTYPE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}


- (BOOL)addProductType:(ProductTypeItem *)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[item.name, [NSString stringWithFormat:@"%d", item.parent], [NSString stringWithFormat:@"%d", self.getCurrentOrgInfo.Id]] forKeys:@[@"productType.name", @"productType.parent", @"productType.orgId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_ADD_PRODUCTTYPE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        [currentOrgProductTypes addObject:item];
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)addOrgConfWithOrgId:(NSInteger)orgId andKey:(NSString *)key andValue:(NSString *)value
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", orgId], key, value] forKeys:@[@"orgId", @"confKey", @"confValue"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_ADD_ORGCONF] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)updateOrgConfWithOrgId:(NSInteger)orgId andKey:(NSString *)key andValue:(NSString *)value
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", orgId], key, value] forKeys:@[@"orgId", @"confKey", @"confValue"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_UPDATE_ORGCONF] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"ERROR:%@", [request getErrMsg]);
    return NO;
}

- (ProductTypeItem*)getProductTypeById:(int)typeId
{
    for (ProductTypeItem* item in currentOrgProductTypes)
    {
        if (item.typeId == typeId)
        {
            return item;
        }
    }
    return nil;
}

- (NSString*)titleForProductType:(int)typeId
{
    NSString* title = @"";
    if (typeId == LB_PRODUCT_TYPE_ROOT)
    {
        return @"";
    }
    ProductTypeItem* item = [self getProductTypeById:typeId];
    NSString* parentTitle = [self titleForProductType:item.parent];
    if ([parentTitle isEqualToString:@""])
    {
        title =  item.name;
    }
    else
    {
        title = [NSString stringWithFormat:@"%@ - %@", parentTitle, item.name];
    }
    return title;
}

- (NSMutableArray*)getProductsWithOrgId:(NSInteger)orgId andTypeId:(int)typeId
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", orgId], [NSString stringWithFormat:@"%d", typeId], [NSString stringWithFormat:@"%d", 0], [NSString stringWithFormat:@"%d", LB_MAX_RECORD_COUNT]] forKeys:@[@"orgId", @"typeId", @"offset", @"pagesize"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_PRODUCTS] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    NSMutableArray* result = [NSMutableArray array];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        resultDic = [request getResultDic];
        NSArray* productTypeList = [resultDic objectForKey:@"productList"];
        for (NSDictionary* type in productTypeList)
        {
            ProductShowingDetail* item = [ProductShowingDetail initByDic:type];
            [result addObject:item];
        }
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return result;
}

- (BOOL)addProduct:(ProductShowingDetail *)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[item.name, [NSString stringWithFormat:@"%d", LB_PRODUCT_STATE_ONSALE], [NSString stringWithFormat:@"%d", item.type], item.detail, [NSString stringWithFormat:@"%d", LB_PRODUCT_PRIORITY_NORMAL], [NSString stringWithFormat:@"%d", item.orgId], [NSString stringWithFormat:@"%@", item.price], [NSString stringWithFormat:@"%d", item.amount]] forKeys:@[@"product.name", @"product.status",@"product.type", @"product.detail", @"product.priority", @"product.orgid", @"product.price", @"product.amount"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_ADDPRODUCT] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        item.Id  = [[[request getResultDic] objectForKey:@"productId"] longValue];
        return [self updateTypes:item.types forProduct:item.Id] && [self updateProductPics:item];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)updateProduct:(ProductShowingDetail *)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], item.name, [NSString stringWithFormat:@"%d", LB_PRODUCT_STATE_ONSALE], [NSString stringWithFormat:@"%d", item.type], item.detail, [NSString stringWithFormat:@"%d", LB_PRODUCT_PRIORITY_NORMAL], [NSString stringWithFormat:@"%ld", self.getCurrentOrgInfo.Id], [NSString stringWithFormat:@"%@", item.price], [NSString stringWithFormat:@"%d", item.amount]] forKeys:@[@"product.productId", @"product.name", @"product.status",@"product.type", @"product.detail", @"product.priority", @"product.orgid", @"product.price", @"product.amount"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_UPDATEPRODUCT] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return [self updateTypes:item.types forProduct:item.Id] && [self updateProductPics:item];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}



- (BOOL)deleteProductById:(long)productId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_DELETE_PRODUCT] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld", productId] forKey:@"productId"] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
    
}

- (BOOL)loadPicForProduct:(long)productId withType:(short)type completionHandler:(void (^)(NSData*)) handler
{
    if (productId <= 0 || type < 0)
    {
        NSLog(@"PARAM ERROR");
        return NO;
    }
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], [NSString stringWithFormat:@"%d", type]] forKeys:@[@"productId", @"picTypeId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_PICFORTYPE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        NSString* imgName = [((NSDictionary*)[[request getResultDic]objectForKey:@"pic"]) objectForKey:@"link"];
        NSString* imgLink = [imgPathForProduct stringByAppendingString:imgName];
        [self loadPicForLink:imgLink completionHandler:handler];
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
- (NSString*)loadPicLinkForProduct:(long)productId withType:(short)type
{
    if (productId <= 0 || type < 0)
    {
        NSLog(@"PARAM ERROR");
        return NO;
    }
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], [NSString stringWithFormat:@"%d", type]] forKeys:@[@"productId", @"picTypeId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_PICFORTYPE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        NSString* imgName = [((NSDictionary*)[[request getResultDic]objectForKey:@"pic"]) objectForKey:@"link"];
        NSString* imgLink = [imgPathForProduct stringByAppendingString:imgName];
        return imgLink;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return @"";
}

- (BOOL)loadPicLinkForProduct:(long)productId withType:(short)type completionHandler:(void (^)(NSString*)) handler;
{
    if (productId <= 0 || type < 0)
    {
        NSLog(@"PARAM ERROR");
        return NO;
    }
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], [NSString stringWithFormat:@"%d", type]] forKeys:@[@"productId", @"picTypeId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_PICFORTYPE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendAsynchronousRequestAndcompletionHandler:^(NSData* data)
    {
        if (handler)
        {
            NSString* imgName = [((NSDictionary*)[[request getResultDic]objectForKey:@"pic"]) objectForKey:@"link"];
            NSString* imgLink = [imgPathForProduct stringByAppendingString:imgName];
            handler(imgLink);
        }
    }];
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

//- (void)loadPicForLink:(NSString*)link deleage:(id)deleage setImgSel:(SEL)setImgSel
//{
//    NSURL *URL = [NSURL URLWithString:link];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        if (!error && responseCode == 200) {
//            [deleage performSelector:setImgSel withObject:[UIImage imageWithData:data]];
//        }
//        else
//        {
//            NSLog(@"Download image from link[%@] error:%@", link, error.description);
//        }
//    }];
//    
//}

- (void)loadPicForLink:(NSString*)link completionHandler:(void (^)(NSData*)) handler
{
    NSURL *URL = [NSURL URLWithString:link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && responseCode == 200) {
            handler(data);
        }
        else
        {
            NSLog(@"Download image from link[%@] error:%@", link, error.description);
        }
    }];
}

- (BOOL)loadPicLinksForItem:(PsDataItem *)item withRefType:(short)refType
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[serverUrl stringByAppendingString:LB_ACTION_KEY_PICS] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], [NSString stringWithFormat:@"%d", refType]] forKeys:@[@"refId", @"picRefType"]] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        NSArray* picList = [[request getResultDic]objectForKey:@"picList"];
        for (NSDictionary* dic in picList)
        {
            [item setImgLink:[dic objectForKey:@"link"] withType:[[dic objectForKey:@"type"]integerValue]];
        }
        return YES;
        
    };
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)addProduct:(long)productId toType:(NSInteger)typeId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_ADDPRODUCTTOTYPE] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], [NSString stringWithFormat:@"%d", typeId]] forKeys:@[@"productId", @"typeId"]] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)dropType:(NSInteger)typeId fromProduct:(long)productId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_DROPPRODUCTTOTYPE] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], [NSString stringWithFormat:@"%d", typeId]] forKeys:@[@"productId", @"typeId"]] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (BOOL)updateTypes:(NSArray *)types forProduct:(long)productId
{
    NSMutableString* data = [NSMutableString string];
    for (NSNumber* type in types)
    {
        [data appendFormat:@"%@,", type];
    }
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_UPDATETYPES] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", productId], data] forKeys:@[@"productId", @"typeListString"]] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;

}

- (NSMutableArray*)getProductTypesWithProductId:(long)productId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_TYPES] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld", productId] forKey:@"productId"] delegate:nil doneSelector:nil errorSelector:nil];
    NSMutableArray* result = [NSMutableArray array];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        resultDic = [request getResultDic];
        NSArray* productTypeList = [resultDic objectForKey:@"typeList"];
        for (NSDictionary* type in productTypeList)
        {
            [result addObject:[NSNumber numberWithInteger:[[type objectForKey:@"typeId"]integerValue]]];
        }
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return result;
}

- (NSString*)uploadImg:(NSString *)imgFilePath
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[serverUrl stringByAppendingString:LB_ACTION_KEY_FILEUPLOAD]]];
    [request setFile:imgFilePath forKey:@"myFile"];
//    [request setDelegate:self];
//    [request setDidReceiveDataSelector:@selector(onDidReceiveData:andData:)];
    [request startSynchronous];
    if ( [request isFinished])
    {
        id res = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            NSString* result = [res objectForKey:@"result"];
            if ([result isEqualToString:@"OK"])
            {
                return [res objectForKey:@"tmpFilePath"];
            }
        }
    }
    return @"";
}

- (BOOL)updateProductPics:(ProductShowingDetail *)item
{
    return [self updatePics:item forRefType:LB_PIC_TYPE_PRODUCT];
//    NSMutableString* picListString = [NSMutableString string];
//    for (NSString* link in [item.imgLinkDic allValues])
//    {
//        [picListString appendFormat:@"%@,", link];
//    }
//    
//    NSMutableString* picTypeListString = [NSMutableString string];
//    for (NSNumber* type in [item.imgLinkDic allKeys])
//    {
//        [picTypeListString appendFormat:@"%@,", type];
//    }
//    
//    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[productBaseUrl stringByAppendingString:LB_ACTION_KEY_PRODUCT_UPDATEPICS] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], picListString, picTypeListString] forKeys:@[@"productId", @"picListString", @"picTypeListString"]] delegate:nil doneSelector:nil errorSelector:nil];
//    [request sendSynchronousRequest];
//    if ([request isRequestDidSuccessed])
//    {
//        return YES;
//    }
//    NSLog(@"Error:%@", [request getErrMsg]);
//    return NO;
}

- (NSMutableArray*)getSubOrgByOrgId:(NSInteger)orgId
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d",orgId]] forKeys:@[@"orgId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_SUBORGS] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    NSMutableArray* subOrgs = [NSMutableArray array];
    if ([request isRequestDidSuccessed])
    {
        NSArray* subOrgList = [[request getResultDic]objectForKey:@"subOrgList"];
        for (NSDictionary* dic in subOrgList)
        {
            [subOrgs addObject:[[OrganizationItem alloc]initWithDic:dic]];
        }
    }
    else
    {
        NSLog(@"Error:%@", [request getErrMsg]);
    }
    return subOrgs;
}

- (BOOL)addOrg:(OrganizationItem*)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[item.name, item.account, [NSString stringWithFormat:@"%d", item.status], [NSString stringWithFormat:@"%d", item.type], item.detail, item.cclass, item.group, [NSString stringWithFormat:@"%d", item.groupId], [NSString stringWithFormat:@"%ld", item.credit], item.email, [NSString stringWithFormat:@"%d", item.parent], item.phone, item.mobile, item.url, item.state, item.city, item.street, item.zip, [NSString stringWithFormat:@"%.10f", item.latitude], [NSString stringWithFormat:@"%.10f", item.longitude], @""] forKeys:@[@"org.cname", @"org.account", @"org.cstatus",@"org.type", @"org.detail", @"org.cclass", @"org.cgroup", @"org.cgroupid", @"org.credit", @"org.email", @"org.parent", @"org.phone", @"org.mobile", @"org.website", @"org.state", @"org.city", @"org.street", @"org.zip", @"org.latitude", @"org.longitude", @"org.cface"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_ADDSUBORG] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        item.Id  = [[[request getResultDic] objectForKey:@"orgId"] integerValue];
        return [self updatePics:item forRefType:LB_PIC_TYPE_ORG];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
- (BOOL)updateOrg:(OrganizationItem*)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], item.name, item.account, [NSString stringWithFormat:@"%d", item.status], [NSString stringWithFormat:@"%d", item.type], item.detail, item.cclass, item.group, [NSString stringWithFormat:@"%d", item.groupId], [NSString stringWithFormat:@"%ld", item.credit], item.email, [NSString stringWithFormat:@"%d", item.parent], item.phone, item.mobile, item.url, item.state, item.city, item.street, item.zip, [NSString stringWithFormat:@"%.10f", item.latitude], [NSString stringWithFormat:@"%.10f", item.longitude], @""] forKeys:@[@"org.companyId", @"org.cname", @"org.account", @"org.cstatus",@"org.type", @"org.detail", @"org.cclass", @"org.cgroup", @"org.cgroupid", @"org.credit", @"org.email", @"org.parent", @"org.phone", @"org.mobile", @"org.website", @"org.state", @"org.city", @"org.street", @"org.zip", @"org.latitude", @"org.longitude", @"org.cface"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_UPDATE] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return [self updatePics:item forRefType:LB_PIC_TYPE_ORG];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;

}
- (BOOL)deleteOrgById:(NSInteger)orgId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_DELETESUBORG] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", orgId] forKey:@"orgId"] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
- (BOOL)updatePics:(PsDataItem*)item forRefType:(short)refType
{
    if (nil == item.imgLinkDic || [item imageCount] <= 0)
    {
        return YES;
    }
    NSMutableString* picListString = [NSMutableString string];
    for (NSString* link in [item.imgLinkDic allValues])
    {
        [picListString appendFormat:@"%@,", link];
    }
    
    NSMutableString* picTypeListString = [NSMutableString string];
    for (NSNumber* type in [item.imgLinkDic allKeys])
    {
        [picTypeListString appendFormat:@"%@,", type];
    }
    
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[serverUrl stringByAppendingString:LB_ACTION_KEY_UPDATE_PICS] paramDic:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], [NSString stringWithFormat:@"%d", refType], picListString, picTypeListString] forKeys:@[@"refId", @"picRefType", @"picListString", @"picTypeListString"]] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}

- (NSMutableArray*)getDiscountCardByOrgId:(NSInteger)orgId
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d",orgId]] forKeys:@[@"orgId"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_DISCOUNTCARDS] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    NSMutableArray* cards = [NSMutableArray array];
    if ([request isRequestDidSuccessed])
    {
        NSArray* cardsList = [[request getResultDic]objectForKey:@"discountCardList"];
        for (NSDictionary* dic in cardsList)
        {
            [cards addObject:[[DiscountCardItem alloc]initWithDic:dic]];
        }
    }
    else
    {
        NSLog(@"Error:%@", [request getErrMsg]);
    }
    return cards;

}
- (BOOL)addDiscountCard:(DiscountCardItem*)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", item.orgId], item.name, item.detail, [NSString stringWithFormat:@"%d", item.overlay], [NSString stringWithFormat:@"%d", item.type], item.value] forKeys:@[@"card.orgId", @"card.name", @"card.detail", @"card.overlay", @"card.type", @"card.value"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_ADDDISCOUNTCARD] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        item.Id  = [[[request getResultDic] objectForKey:@"cardId"] integerValue];
        return [self updatePics:item forRefType:LB_PIC_TYPE_DISCOUNTCARD];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
- (BOOL)updateDiscountCard:(DiscountCardItem*)item
{
    NSDictionary* param = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld", item.Id], [NSString stringWithFormat:@"%d", item.orgId], item.name, item.detail, [NSString stringWithFormat:@"%d", item.overlay], [NSString stringWithFormat:@"%d", item.type], item.value] forKeys:@[@"card.id", @"card.orgId", @"card.name", @"card.detail", @"card.overlay", @"card.type", @"card.value"]];
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_UPDATEDISCOUNTCARD] paramDic:param delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return [self updatePics:item forRefType:LB_PIC_TYPE_DISCOUNTCARD];
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
- (BOOL)deleteDiscountCardById:(NSInteger)cardId
{
    LCJsonRequest* request = [[LCJsonRequest alloc]initWithURL:[orgBaseUrl stringByAppendingString:LB_ACTION_KEY_ORG_DELETEDISCOUNTCARD] paramDic:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", cardId] forKey:@"cardId"] delegate:nil doneSelector:nil errorSelector:nil];
    [request sendSynchronousRequest];
    if ([request isRequestDidSuccessed])
    {
        return YES;
    }
    NSLog(@"Error:%@", [request getErrMsg]);
    return NO;
}
@end
