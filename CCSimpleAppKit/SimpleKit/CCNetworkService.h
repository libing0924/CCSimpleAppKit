//
//  CCNetworkService.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/6/3.
//  Copyright © 2019 CC. All rights reserved.
//
// 网络请求的接入层，可根据各个项目组的开发框架选型接入相关的网络框架，可参照CCMassiveAppKit(https://github.com/libing0924/CCMassiveAppKit)的实现

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCNetworkingStatus) {
    
    CCNetworkingStatusSuccess = 200, // 请求成功
};

// post提交参数方式（兼容后端框架不支持post提交json数据的情况）
typedef NS_ENUM(NSInteger, CCNetworkingPOSTDataStyle) {
    
    CCNetworkingPOSTDataDefault = 1, // POST默认参数提交
    CCNetworkingPOSTDataForm = 2, // POST form提交
};

typedef void(^cc_net_progress_block)(float progress);

typedef void(^cc_net_success_block)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);

typedef void(^cc_net_failure_block)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@protocol CCNetworkService <NSObject>

@required
- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
           headers:(NSDictionary *)headers
           success:(cc_net_success_block)success
           failure:(cc_net_failure_block)failure;

- (void)requestPOST:(NSString *)urlStr
         parameters:(NSDictionary *)params
            headers:(NSDictionary *)headers
            success:(cc_net_success_block)success
            failure:(cc_net_failure_block)failure;

- (void)uploadImageWithOperations:(NSDictionary *)operations
                            image:(UIImage *)image
                        urlString:(NSString *)urlString
                         progress:(cc_net_progress_block)progress
                          success:(cc_net_success_block)success
                          failure:(cc_net_failure_block)failure;

@optional
- (void)configPOSTDataStyle:(CCNetworkingPOSTDataStyle)POSTDataStyle;

@end
