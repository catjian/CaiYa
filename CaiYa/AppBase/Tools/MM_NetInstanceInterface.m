//
//  MM_NetInstanceInterface.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/21.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_NetInstanceInterface.h"

static MM_NetInstanceInterface *netInstace = nil;

@implementation MM_NetInstanceInterface

+ (MM_NetInstanceInterface *)sharedNetInstaceInterface
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netInstace = [[MM_NetInstanceInterface alloc] init];
    });
    return netInstace;
}

//普通登录
- (void)loginActionWithParameter:(NSDictionary *)parame
                   isWeiXingType:(ENUM_LOING_TYPE)type
                    SuccessBlock:(SuccessBlock)_sucBlock
                    FailuerBlock:(FailureBlock)_falBlock
{
    NSDictionary *parameter = nil;
    switch (type)
    {
        case ENUM_LOING_TYPE_WEIXIN:
        {
            parameter = @{@"mobileLogin":@(YES), @"weixin":parame[@"weixin"]};
        }
            break;
        case ENUM_LOING_TYPE_CAIYA_ACCOUNT:
        {
            parameter = @{@"mobileLogin":@(YES),
                          @"username":parame[@"username"],
                          @"password":parame[@"password"]};
        }
            break;
        default:
            break;
    }
    
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在登录中..."];
    [[MM_NetworkController sharedClient] postRequestAction:@"a/login"
                                                     param:parameter
                                               paramEncode:AFFormURLParameterEncoding
                                                   success:^(id respInfo, NSError *error) {
        DebugLog(@"respInfo = %@",respInfo);
                                                       [[MM_Tools shareTools] HideHUD];
                                                       if (_sucBlock)
                                                       {
                                                           _sucBlock(respInfo);
                                                       }
    }
                                                   failure:^(id info, NSError *error) {
                                                       DebugLog(@"error = %@",error);
                                                       [[MM_Tools shareTools] HideHUD];
                                                       if (_falBlock)
                                                       {
                                                           _falBlock(nil);
                                                       }
    }];
}

//退出
- (void)logoutActionWithSuccessBlock:(SuccessBlock)_sucBlock
                        FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"退出中..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/logout"
                                                    param:nil
                                                  success:^(id respInfo, NSError *error) {
                                             DebugLog(@"responseObject = %@",respInfo);
                                             [[MM_Tools shareTools] HideHUD];
    }
                                                  failure:^(id info, NSError *error) {
                                             DebugLog(@"error = %@",error);
                                             [[MM_Tools shareTools] HideHUD];
    }];
}

//文章列表接口
- (void)getArticleListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"cms/article/list"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//用户注册
- (void)registerActionWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在注册..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/register"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//修改密码
- (void)modifyPasswordActionWithParameter:(NSDictionary *)parame
                             SuccessBlock:(SuccessBlock)_sucBlock
                             FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在修改密码..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/modifyPwd"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//重置密码
- (void)resetPasswordActionWithParameter:(NSDictionary *)parame
                            SuccessBlock:(SuccessBlock)_sucBlock
                            FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在重置密码..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/resetPwd"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//修改手机号
- (void)modifyMobileActionWithParameter:(NSDictionary *)parame
                            SuccessBlock:(SuccessBlock)_sucBlock
                            FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在修改手机号..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/modifyMobile"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//用户优惠券列表接口
- (void)getElecCouponLisetWithParameter:(NSDictionary *)parame
                           SuccessBlock:(SuccessBlock)_sucBlock
                           FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取电子券..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyElecCoupon"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//用户个人收益接口
- (void)cashStaticWithParameter:(NSDictionary *)parame
                   SuccessBlock:(SuccessBlock)_sucBlock
                   FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取收益统计..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyCashStatic/lastWeek"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//文章分享接口
- (void)forwardArticleWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在提交分享结果..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cms/article/forwardArticle"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//用户分享文章统计信息
- (void)userArticleStaticWithParameter:(NSDictionary *)parame
                          SuccessBlock:(SuccessBlock)_sucBlock
                          FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取用户分享文章统计信息..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyUserArticleStatic/list"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//提现申请
- (void)applyCashWithParameter:(NSDictionary *)parame
                          SuccessBlock:(SuccessBlock)_sucBlock
                          FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在提现申请..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyCashRecord/applyCash"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//取消提现申请
- (void)cancelApplyCashWithParameter:(NSDictionary *)parame
                  SuccessBlock:(SuccessBlock)_sucBlock
                  FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在取消提现申请..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyCashRecord/cancelApplyCash"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//提现记录列表
- (void)cashRecordListWithParameter:(NSDictionary *)parame
                  SuccessBlock:(SuccessBlock)_sucBlock
                  FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取提现记录列表..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyCashRecord"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//提现规则
- (void)getCashRuleWithParameter:(NSDictionary *)parame
                    SuccessBlock:(SuccessBlock)_sucBlock
                    FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取提现规则..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyCashRule/getCashRule"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//检查最新版本
- (void)getLastVersionWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在检查最新版本..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyVersion/getLastVersion"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//更新用户信息
- (void)upLoadUserInfoWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_Tools shareTools] ShowHUDWithMessage:@"正在更新用户信息..."];
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/info"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//短信验证
- (void)getSmsCodeWithParameter:(NSDictionary *)parame
                   SuccessBlock:(SuccessBlock)_sucBlock
                   FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/getSmsCode"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                  }];
}

//注册邀请奖励规则
- (void)getRegisterRuleWithParameter:(NSDictionary *)parame
                        SuccessBlock:(SuccessBlock)_sucBlock
                        FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cy/cyRegisterRule/getRegisterRule"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                      _falBlock(nil);
                                                  }];
}

//获取一篇文章的所有评论（分页）
- (void)getCommentListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"a/cms/comment/list"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                      _falBlock(nil);
                                                  }];
}

//获取扮演角色列表
- (void)getDictListWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/dict/list"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                      _falBlock(nil);
                                                  }];
}

//为用户设置扮演角色
- (void)updatePlayRoleWithParameter:(NSDictionary *)parame
                       SuccessBlock:(SuccessBlock)_sucBlock
                       FailuerBlock:(FailureBlock)_falBlock
{
    [[MM_NetworkController sharedClient] getRequestAction:@"a/sys/user/updatePlayRole"
                                                    param:parame
                                                  success:^(id respInfo, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      if(respInfo)
                                                      {
                                                          if (_sucBlock)
                                                          {
                                                              _sucBlock(respInfo);
                                                          }
                                                      }
                                                  }
                                                  failure:^(id info, NSError *error) {
                                                      [[MM_Tools shareTools] HideHUD];
                                                      DebugLog(@"error = %@",error);
                                                      _falBlock(nil);
                                                  }];
}

@end
