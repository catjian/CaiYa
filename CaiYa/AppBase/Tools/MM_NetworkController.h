//
//  MM_NetworkController.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

//请求成功
typedef void (^RequestSuccessBlock)(id respInfo,NSError *error);

//请求失败
typedef void (^RequestFailureBlock)(id info,NSError *error);

@interface MM_NetworkController : AFHTTPClient
{
    
    NSMutableDictionary *allErrorDict;
    
    NSString *protocolVersion;
    
    NSString *appVersion;
}
@property(nonatomic,strong)NSMutableDictionary *allErrorDict;

@property(nonatomic,strong)NSString *protocolVersion;

@property(nonatomic,strong)NSString *appVersion;


+(MM_NetworkController *)sharedClient;

- (void)initWithURL:(NSURL *)url;

- (NSString *)errorMessageWithErrorCode:(NSString *)error;

- (NSString *)getPath:(NSDictionary *)value  action:(NSString *)action;

+ (BOOL)isNetWork;

+ (void)stopNetWorkRequestMethod:(NSString *)method Path:(NSString *)path;

- (void)postRequestAction:(NSString *)action
                   param:(NSDictionary *)p
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock;

- (void)postRequestAction:(NSString *)action
                   param:(NSDictionary *)p
             paramEncode:(AFHTTPClientParameterEncoding)encode
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock;

- (void)getRequestAction:(NSString *)action
                   param:(NSDictionary *)p
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock;

@end
