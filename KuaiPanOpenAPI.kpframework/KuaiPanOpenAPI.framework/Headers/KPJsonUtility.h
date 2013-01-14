//
//  KPJsonUtility.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPJsonUtility : NSObject

+ (id)jsonValueFromString:(NSString *)jsonString;
+ (NSString *)jsonValueFromObject:(id)object;

@end
