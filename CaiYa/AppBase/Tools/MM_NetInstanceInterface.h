//
//  MM_NetInstanceInterface.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/21.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_NetworkController.h"

//请求成功
typedef void (^SuccessBlock)(id respInfo);

//请求失败
typedef void (^FailureBlock)(NSDictionary *error);

@interface MM_NetInstanceInterface : MM_Object

+ (MM_NetInstanceInterface *)sharedNetInstaceInterface;

- (void)loginActionWithParameter:(NSDictionary *)parame
                   isWeiXingType:(ENUM_LOING_TYPE)type
                    SuccessBlock:(SuccessBlock)_sucBlock
                    FailuerBlock:(FailureBlock)_falBlock;

- (void)logoutActionWithSuccessBlock:(SuccessBlock)_sucBlock
                        FailuerBlock:(FailureBlock)_falBlock;

- (void)getArticleListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)registerActionWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)modifyPasswordActionWithParameter:(NSDictionary *)parame
                             SuccessBlock:(SuccessBlock)_sucBlock
                             FailuerBlock:(FailureBlock)_falBlock;

- (void)resetPasswordActionWithParameter:(NSDictionary *)parame
                            SuccessBlock:(SuccessBlock)_sucBlock
                            FailuerBlock:(FailureBlock)_falBlock;

- (void)modifyMobileActionWithParameter:(NSDictionary *)parame
                           SuccessBlock:(SuccessBlock)_sucBlock
                           FailuerBlock:(FailureBlock)_falBlock;

- (void)getElecCouponLisetWithParameter:(NSDictionary *)parame
                           SuccessBlock:(SuccessBlock)_sucBlock
                           FailuerBlock:(FailureBlock)_falBlock;

- (void)cashStaticWithParameter:(NSDictionary *)parame
                   SuccessBlock:(SuccessBlock)_sucBlock
                   FailuerBlock:(FailureBlock)_falBlock;

- (void)forwardArticleWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)userArticleStaticWithParameter:(NSDictionary *)parame
                          SuccessBlock:(SuccessBlock)_sucBlock
                          FailuerBlock:(FailureBlock)_falBlock;

- (void)applyCashWithParameter:(NSDictionary *)parame
                  SuccessBlock:(SuccessBlock)_sucBlock
                  FailuerBlock:(FailureBlock)_falBlock;

- (void)cancelApplyCashWithParameter:(NSDictionary *)parame
                        SuccessBlock:(SuccessBlock)_sucBlock
                        FailuerBlock:(FailureBlock)_falBlock;

- (void)cashRecordListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)getCashRuleWithParameter:(NSDictionary *)parame
                    SuccessBlock:(SuccessBlock)_sucBlock
                    FailuerBlock:(FailureBlock)_falBlock;

- (void)getLastVersionWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)upLoadUserInfoWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)getSmsCodeWithParameter:(NSDictionary *)parame
                   SuccessBlock:(SuccessBlock)_sucBlock
                   FailuerBlock:(FailureBlock)_falBlock;

- (void)getRegisterRuleWithParameter:(NSDictionary *)parame
                        SuccessBlock:(SuccessBlock)_sucBlock
                        FailuerBlock:(FailureBlock)_falBlock;

- (void)getCommentListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;

- (void)getDictListWithParameter:(NSDictionary *)parame
                    SuccessBlock:(SuccessBlock)_sucBlock
                    FailuerBlock:(FailureBlock)_falBlock;

- (void)updatePlayRoleWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock;
@end
