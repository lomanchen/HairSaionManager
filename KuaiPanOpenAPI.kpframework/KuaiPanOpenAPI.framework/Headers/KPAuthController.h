//
//  KPAuthController.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPOperation.h"

@class KPConsumer;
@class KPXAuthOperation;
@class KPToken;


@interface KPAuthController : UIViewController <KPOperationDelegate>{
    
    KPConsumer                          *_consumer;
    KPXAuthOperation                    *_XOAuthOperation;

    IBOutlet UITextField                *_userName;
    IBOutlet UITextField                *_password;
    IBOutlet UINavigationBar            *_navigationBar;

}

/*
 * 初始化
 */
- (id)initWithConsumer:(KPConsumer *)consumer;
/*
 * 返回是否已经授权
 */
- (BOOL)isAlreadAuth;

/*
 * 清除本地存储的授权信息
 */
- (void)clearAuthInfo;

/*
 * 清除正在进行的操作，在销毁KPAuthController前调用该函数
 */
- (void)clearOperations;

@end
