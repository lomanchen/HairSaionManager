//
//  Defines.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-4.
//  Copyright (c) 2012年 KingSoft. All rights reserved.
//

#define SafeRelease(_pointer) {[_pointer release];_pointer = nil;}

// OAuth参数
#define OA_NONCE        @"oauth_nonce"
#define OA_TIMESTAMP    @"oauth_timestamp"
#define OA_KEY          @"oauth_consumer_key"
#define OA_SIG_METHOD   @"oauth_signature_method"
#define OA_VERSION      @"oauth_version"
#define OA_TOKEN        @"oauth_token"
#define OA_TOKEN_SECRET @"oauth_token_secret"

//提示参数
#define NAME_MESSAGE        @"请填写正确的用户名！"
#define PWD_MESSAGE         @"请填写密码！"
#define TITLE               @"错误提示"
