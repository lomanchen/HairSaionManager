//
//  KPConsumer.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPConsumer : NSObject {
    NSString    *_key;
    NSString    *_secret;
}

@property(nonatomic, readonly) NSString      *key;
@property(nonatomic, readonly) NSString      *secret;

- (id)initWithKey:(NSString *)key secret:(NSString *)secret;

@end
