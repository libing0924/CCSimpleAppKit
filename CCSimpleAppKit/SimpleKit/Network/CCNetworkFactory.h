//
//  CCNetworkRequestFactory.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/6/3.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSingletonService.h"
#import "CCNetworkService.h"
#import "CCNetworkRequest.h"
#import "CCPagingRequest.h"

/**
 网络请求工厂
 通过工厂创建网络请求实体类
 **使用前请务必通过registerGlobeRequestService:注册网络服务的实体类**
 */
@interface CCNetworkFactory : NSObject

/**
 获取全局单例的网络服务实体对象
 
 @return 实体对象
 */
+ (id<CCNetworkService>)globeRequestService;

/**
 
 在网络请求池获取可用网络服务实体对象，
 基于客户端业务发起请求的量级未达到需要调度的情况，该方法暂未实现，本方法返回的还是全局请求对象
 
 @return 实体对象
 */
+ (id<CCNetworkService>)dequeueReusableRequestService;

/**
 注册全局的网络服务
 */
+ (void)registerGlobeRequestService:(Class<CCNetworkService, CCSingletonService>)globeRequestService;

// 请求全局代理
+ (void)registerGlobeRequestHandler:(Class<CCNetworkRequestHandler>)globeRequestHandler;

// 分页请求全局代理
+ (void)registerGlobePagingRequestHandler:(Class<CCPagingRequestHandler>)globePagingRequestHandler;

@end

