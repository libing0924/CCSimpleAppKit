//
//  CCNetworkRequest.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 李冰. All rights reserved.
//

// SimpleAppKit的网络服务最上层
// 提供给开发人员的网络请求业务层,可通过该层 添加统一的参数、添加http header、配置参数加密等
// 网络请求便利工具，可根据不同后端的开发模块接口标准分别进行请求配置，也可使用全局配置

#import <Foundation/Foundation.h>

@class CCNetworkRequest;

/**
 业务数据分解
 1.通过全局配置分解
 2.通过对象代理方法分解
 */
@protocol CCNetworkRequestHandler <NSObject>

@optional

/********* response相关 **********/
/**
 根据code判断业务请求成功

 @param request request
 @param code code,statusCodeFromRequest:task:responseObject:返回的code
 @return 是否成功
 */
- (BOOL)successFromRequest:(CCNetworkRequest *)request code:(NSInteger)code;

/**
 返回业务数据

 @param request request
 @param task task
 @param responseObject responseObject,网络请求原始数据
 @return 业务数据
 */
- (id)dataContentFromRequest:(CCNetworkRequest *)request task:(NSURLSessionTask *)task responseObject:(id)responseObject;

/**
 业务消息

 @param request request
 @param task task
 @param responseObject responseObject,网络请求原始数据
 @return 业务消息
 */
- (NSString *)messageFromRequest:(CCNetworkRequest *)request task:(NSURLSessionTask *)task responseObject:(id)responseObject;

/**
 业务状态码

 @param request request
 @param task task
 @param responseObject responseObject,网络请求原始数据
 @return 业务状态码
 */
- (NSInteger)statusCodeFromRequest:(CCNetworkRequest *)request task:(NSURLSessionTask *)task responseObject:(id)responseObject;

/********* request相关 **********/

/**
 http header

 @param request request
 @param urlString urlString
 @return http header
 */
- (NSDictionary *)headerFromRequest:(CCNetworkRequest *)request urlString:(NSString *)urlString;

/**
 请求参数(可在此处添加全局的参数或者对参数进行加密等)

 @param request request
 @param urlString urlString
 @param originalParameters 原始请求参数
 @return 新的请求参数
 */
- (NSDictionary *)parametersFromRequest:(CCNetworkRequest *)request urlString:(NSString *)urlString parameters:(NSDictionary *)originalParameters;

@end

@interface CCResponseMetaModel : NSObject

// 请求返回的原始数据
@property (nonatomic, strong) id rawData;
// 请求返回的原始业务员数据
@property (nonatomic, strong) id contentData;
// 请求是否成功(业务层面)
@property (nonatomic, assign) BOOL success;
// 请求的状态码
@property (nonatomic, assign) NSInteger code;
// error
@property (nonatomic, strong) NSError *error;
// message
@property (nonatomic, strong) NSString *message;
// task
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@interface CCNetworkRequest : NSObject

@property (nonatomic, strong) id<CCNetworkRequestHandler> requestHandler;

- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
          response:(nullable void (^)(CCResponseMetaModel *metaModel))response;

- (void)requestPOST:(NSString *)urlStr
        parameters:(NSDictionary *)params
          response:(nullable void (^)(CCResponseMetaModel *metaModel))response;

// 注册全局代理
+ (void)registerGlobeRequestHandler:(Class<CCNetworkRequestHandler>)globeRequestHandler;


@end
