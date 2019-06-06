//
//  CCPagingRequestControl.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 李冰. All rights reserved.
//

#import "CCPagingRequest.h"

NSString * const kDefaultPagingRequestPageNumKey = @"pageNum";
NSString * const kDefaultPagingRequestPageSizeKey = @"pageSize";

static Class pagingRequestGlobeHandler = nil;

@implementation CCPagingRequest

- (instancetype)init {
    
    if (self = [super init]) {
        
        _pageNumber = 1;
        _pageSize = 10;
        _requestType = CCPagingRequestTypeGET;
    }
    
    return self;
}

- (void)firstPageRequest {
    
    _pageNumber = 1;
    [self request];
}

- (void)nextPageRequest {
    
    [self request];
}

- (void)request {
    
    NSAssert(self.urlStr, @"Request url is null");
    
    NSDictionary *parameters = nil;
    if (self.pagingHandler && [self.pagingHandler respondsToSelector:@selector(parametersWithPagingRequest:originalParameters:)]) {
        
        parameters = [self.pagingHandler parametersWithPagingRequest:self originalParameters:nil];
    }
        
    if(!parameters) parameters = [NSDictionary dictionaryWithObjects:@[@(_pageNumber), @(_pageSize)] forKeys:@[kDefaultPagingRequestPageNumKey, kDefaultPagingRequestPageSizeKey]];
    
    __weak typeof(self) weakSelf = self;
    if (self.requestType == CCPagingRequestTypeGET) {
        
        [self requestGET:self.urlStr parameters:parameters response:^(CCResponseMetaModel *metaModel) {
            
            [weakSelf _requestEndWithMetaModel:metaModel];
        }];
    } else if (self.requestType == CCPagingRequestTypePOST) {
        
        [self requestPOST:self.urlStr parameters:parameters response:^(CCResponseMetaModel *metaModel) {
            
            [weakSelf _requestEndWithMetaModel:metaModel];
        }];
    }
}

- (void)_requestEndWithMetaModel:(CCResponseMetaModel *)metaModel {
    
    if (metaModel.success) {
        
        if (self.pageNumber == 1) [self.dataSource removeAllObjects];
        
        NSArray *datas = [NSArray arrayWithArray:metaModel.rawData];
        
        [self.dataSource addObjectsFromArray:datas];
        
        BOOL hasNoMoreData = NO;
        NSUInteger totalCount = 0;
        if (self.pagingHandler && [self.pagingHandler respondsToSelector:@selector(pagingRequestTotalData:metaData:)]) {
            
            totalCount = [self.pagingHandler pagingRequestTotalData:self metaData:metaModel];
        }
        
        if (totalCount == 0) {
            
            if (datas.count < self.pageSize) hasNoMoreData = YES;
        } else {
            
            if (self.dataSource.count < totalCount) hasNoMoreData = YES;
        }
        
        if (hasNoMoreData) {
            
            if (self.pagingHandler && [self.pagingHandler respondsToSelector:@selector(pagingRequestHasNoMoreData:)]) {
                
                [self.pagingHandler pagingRequestHasNoMoreData:self];
            }
        } else {
            
            self.pageNumber++;
        }
    }
    
    if (self.pagingHandler && [self.pagingHandler respondsToSelector:@selector(pagingRequestDidEnd:metaData:)]) {
        
        [self.pagingHandler pagingRequestDidEnd:self metaData:metaModel];
    }
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    
    if (_dataSource) return _dataSource;
    
    _dataSource = @[].mutableCopy;
    
    return _dataSource;
}

- (id<CCPagingRequestHandler>)pagingHandler {
    
    if (_pagingHandler) return _pagingHandler;
    
    return [pagingRequestGlobeHandler new];
}

+ (void)registerGlobePagingRequestHandler:(Class<CCPagingRequestHandler>)globePagingRequestService {
    
    pagingRequestGlobeHandler = globePagingRequestService;
}

@end
