//
//  MM_NetworkController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_NetworkController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"

static MM_NetworkController *_sharedClient = nil;

@implementation MM_NetworkController
@synthesize allErrorDict = _allErrorDict;
@synthesize protocolVersion = _protocolVersion;
@synthesize appVersion = _appVersion;

+ (MM_NetworkController *)sharedClient
{
    //创建一个单例
    static dispatch_once_t onceSingleton;
    
    dispatch_once(&onceSingleton, ^{
        _sharedClient = [[MM_NetworkController alloc] init];
        [_sharedClient initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ConnectUrl"]]];
    });
    return _sharedClient;
}


- (void)initWithURL:(NSURL *)url
{
    _sharedClient = [super initWithBaseURL:url];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"APIErrorCodeList" ofType:@"plist"];
    
    _allErrorDict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    
    _protocolVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Protocol version"];
    
    _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    self.parameterEncoding = AFJSONParameterEncoding;
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [super postPath:path parameters:parameters success:success failure:failure];
}

- (NSString *)getPath:(NSDictionary *)value  action:(NSString *)action
{
    NSData *valuedata = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
    
    NSString *vString = [[NSString alloc]initWithData:valuedata encoding:NSUTF8StringEncoding];
    
    NSString *path = [NSString stringWithFormat:@"%@?%@=%@&prov=%@&appv=%@",action,REQ_JSON_KEY,vString,[MM_NetworkController sharedClient].protocolVersion,[MM_NetworkController sharedClient].appVersion];
    
    return path;
}

//是否有网络
+ (BOOL)isNetWork
{
    AFNetworkReachabilityStatus status = [[MM_NetworkController sharedClient] networkReachabilityStatus];
    
    return  !(status == AFNetworkReachabilityStatusNotReachable);
}


- (NSString *)errorMessageWithErrorCode:(NSString *)error
{
    if(_allErrorDict != nil && error && [error length]>0)
    {
        NSString *errorCode = [_allErrorDict objectForKey:error];
        if (errorCode == nil || [errorCode length] < 1)
        {
            errorCode = [_allErrorDict objectForKey:@"-404"];
        }
        return errorCode;
    }
    return nil;
}

+ (void)stopNetWorkRequestMethod:(NSString *)method Path:(NSString *)path
{
    [[MM_NetworkController sharedClient] cancelAllHTTPOperationsWithMethod:method path:path];
}

- (NSError *)configError:(NSInteger)errorcode
{
    if (![MM_NetworkController isNetWork])
        errorcode = -1000;
    
    if (errorcode == 0)
        return nil;
    
    NSString *errormsg = [[MM_NetworkController sharedClient] errorMessageWithErrorCode:
                          [NSString stringWithFormat:@"%d",(int)errorcode]];
    
    NSError *error = [self createError:errorcode localDescription:errormsg];
    return error;
}

- (NSError *)createError:(NSInteger)errorcode localDescription:(NSString *)des
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:des forKey:NSLocalizedDescriptionKey];
    return  [NSError errorWithDomain:@"PB_RuiFuTongErrorDomain" code:errorcode userInfo:userInfo];
}

#pragma mark - 发起请求
- (void)getRequestAction:(NSString *)action
                   param:(NSDictionary *)p
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock
{
    DebugLog(@"post Notification p = %@",p);
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] initWithDictionary:p];
    NSArray *allKey = parames.allKeys;
    if ([allKey indexOfObject:@"mobileLogin"] == NSNotFound)
    {
        [parames setValue:@(YES) forKey:@"mobileLogin"];
    }
    DebugLog(@"post Notification parames = %@",p);
    
    [self getPath:action
       parameters:parames
          success:^(AFHTTPRequestOperation *operation, id JSON){
              DebugLog(@"%@++--",JSON);
              if (sblock)
              {
                  sblock(JSON,nil);
              }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (fblock)
              {
                  error = [self configError:error.code];
                  DebugLog(@"%@--+",error);
                  fblock(nil,error);
                  if ([action rangeOfString:@"logout"].location == NSNotFound)
                  {
                      [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"网络错误!"];
                  }
              }
     }];
}

- (void)postRequestAction:(NSString *)action
                   param:(NSDictionary *)p
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock
{
    DebugLog(@"post Notification p = %@",p);
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] init];
    if (p && p.count > 0)
    {
        parames = [NSMutableDictionary dictionaryWithDictionary:p];
        NSArray *allKey = parames.allKeys;
        if ([allKey indexOfObject:@"mobileLogin"] == NSNotFound)
        {
            [parames setValue:@(YES) forKey:@"mobileLogin"];
        }
        DebugLog(@"post Notification parames = %@",parames);
    }
    
    [self postPath:action
        parameters:p
           success:^(AFHTTPRequestOperation *operation, id JSON){
               DebugLog(@"%@++--",JSON);
               if (sblock)
               {
                   sblock(JSON,nil);
                   DebugLog(@"%@++-77777-",[JSON objectForKey:@"respMsg"]);
               }
     }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               if (fblock)
               {
                   error = [self configError:error.code];
                   DebugLog(@"%@--+",error);
                   fblock(nil,error);
                   [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"网络错误!"];
               }
     }];
}

- (void)postRequestAction:(NSString *)action
                   param:(NSDictionary *)p
             paramEncode:(AFHTTPClientParameterEncoding)encode
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock
{
    DebugLog(@"post Notification p = %@",p);
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] init];
    if (p && p.count > 0)
    {
        parames = [NSMutableDictionary dictionaryWithDictionary:p];
        NSArray *allKey = parames.allKeys;
        if ([allKey indexOfObject:@"mobileLogin"] == NSNotFound)
        {
            [parames setValue:@(YES) forKey:@"mobileLogin"];
        }
        DebugLog(@"post Notification parames = %@",parames);
    }
    
    [self postPath:action
        parameters:parames
 parameterEncoding:encode
           success:^(AFHTTPRequestOperation *operation, id JSON){
               DebugLog(@"%@++--",JSON);
               if (sblock)
               {
                   sblock(JSON,nil);
                   DebugLog(@"%@++-77777-",[JSON objectForKey:@"respMsg"]);
               }
     }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               if (fblock)
               {
                   error = [self configError:error.code];
                   DebugLog(@"%@--+",error);
                   fblock(nil,error);
                   [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"网络错误!"];
               }
     }];
}

@end

