//
//  KPTocken.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPConsumer.h"

@interface KPToken : NSObject {
    NSString    *_token;
    NSString    *_tokenSecret;
}

@property(nonatomic, readonly) NSString      *token;
@property(nonatomic, readonly) NSString      *tokenSecret;

/*
 初始化Token对象
 */
- (id)initWithToken:(NSString *)token secret:(NSString *)secret;

@end
