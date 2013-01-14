//
//  KPUserInfo.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-16.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPUserInfo : NSObject {

    NSInteger   userID;
    NSString    *userName;
    long long   maxFileSize;
    long long   quotaTotal;
    long long   quotaUsed;
}

@property(nonatomic, assign) NSInteger   userID;
@property(nonatomic, retain) NSString    *userName;
@property(nonatomic, assign) long long   maxFileSize;
@property(nonatomic, assign) long long   quotaTotal;
@property(nonatomic, assign) long long   quotaUsed;

@end
