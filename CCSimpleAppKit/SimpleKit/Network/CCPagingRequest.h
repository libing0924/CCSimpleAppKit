//
//  CCPagingRequestControl.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 李冰. All rights reserved.
//

// 网络层依赖CCNetworkService实现

#import <Foundation/Foundation.h>
#import "CCNetworkRequest.h"

@class CCPagingRequest;

FOUNDATION_EXPORT NSString * const kDefaultPagingRequestPageNumKey;
FOUNDATION_EXPORT NSString * const kDefaultPagingRequestPageSizeKey;

typedef NS_ENUM(NSInteger, CCPagingRequestType) {
    
    CCPagingRequestTypeGET = 1,
    CCPagingRequestTypePOST = 2,
};

@protocol CCPagingRequestHandler <NSObject>

@optional

/**
 当没有更多数据的时候会回调该方法
 
 @param pagingRequest pagingRequest
 */
- (void)pagingRequestHasNoMoreData:(CCPagingRequest *)pagingRequest;

/**
 当请求结束的时候回调

 @param pagingRequest pagingRequest
 @param metaModel metaModel，封装的请求数据
 */
- (void)pagingRequestDidEnd:(CCPagingRequest *)pagingRequest metaData:(CCResponseMetaModel *)metaModel;

/**
 根据metaModel返回总数据数

 @param pagingRequest pagingRequest
 @param metaModel metaModel
 @return 数据总条数，默认返回0。0的时候使用pageSize与当前返回数据做对比来判断是否有更多数据，非0正整数的时候使用返回值和pagingRequest的dataSource数据进行对比判断是否有更多数据
 */
- (NSUInteger)pagingRequestTotalData:(CCPagingRequest *)pagingRequest metaData:(CCResponseMetaModel *)metaModel;

/**
 pagingRequest获取请求参数的回调，开发者需要自定义参数的时候请实现该方法
 
 @param pagingRequest pagingRequest
 @param originalParameters originalParameters，pagingRequest的原始参数
 @return 新的参数
 */
- (NSDictionary *)parametersWithPagingRequest:(CCPagingRequest *)pagingRequest originalParameters:(NSDictionary *)originalParameters;

@end

@interface CCPagingRequest : CCNetworkRequest

@property (nonatomic, strong) NSString *urlStr;

// 分页请求的pageSize的value
@property (nonatomic, assign) NSInteger pageSize;
// 分页请求的pageNum的参数value
@property (nonatomic, assign) NSInteger pageNumber;
// 分页请求的pageSize的参数key默认'pageSize'
@property (nonatomic, strong) NSString *pageSizeKey;
// 分页请求的pageNum的参数key默认'pageNum'
@property (nonatomic, strong) NSString *pageNumberKey;
// 请求方法：默认CCPagingRequestTypeGET
@property (nonatomic, assign) CCPagingRequestType requestType;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataSource;
// CCNetworkRequest的代理
@property (nonatomic, strong) id<CCPagingRequestHandler> pagingHandler;

/**
 首页请求
 */
- (void)firstPageRequest;

/**
 下一页请求
 */
- (void)nextPageRequest;

// 注册全局代理
+ (void)registerGlobePagingRequestHandler:(Class<CCPagingRequestHandler>)globePagingRequestService;

@end
