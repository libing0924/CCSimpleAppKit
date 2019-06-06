//
//  CCNetworkRequest.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 李冰. All rights reserved.
//

#import "CCNetworkRequest.h"
#import "CCNetworkFactory.h"

static Class requestGlobeHandler = nil;

@implementation CCResponseMetaModel

@end

@implementation CCNetworkRequest

- (void)requestGET:(NSString *)urlStr parameters:(NSDictionary *)params response:(void (^)(CCResponseMetaModel *))response {
    
    NSDictionary *header = [self _requestHeaderWithURL:urlStr];
    NSDictionary *newParameters = [self _requestParametersWithURL:urlStr originalParameters:params];
    
    [[CCNetworkFactory globeRequestService] requestGET:urlStr parameters:newParameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:responseObject error:nil];
        response(dataModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:nil error:error];
        response(dataModel);
    }];
}

- (void)requestPOST:(NSString *)urlStr parameters:(NSDictionary *)params response:(void (^)(CCResponseMetaModel *))response {
    
    NSDictionary *header = [self _requestHeaderWithURL:urlStr];
    NSDictionary *newParameters = [self _requestParametersWithURL:urlStr originalParameters:params];
    
    [[CCNetworkFactory globeRequestService] requestPOST:urlStr parameters:newParameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:responseObject error:nil];
        response(dataModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:nil error:error];
        response(dataModel);
    }];
}

- (NSDictionary *)_requestHeaderWithURL:(NSString *)urlString {
    
    NSDictionary *destinationHeader = nil;
    if (self.requestHandler && [self.requestHandler respondsToSelector:@selector(headerFromRequest:urlString:)]) {
        
        NSDictionary *header = [self.requestHandler headerFromRequest:self urlString:urlString];
        
        if ([header isKindOfClass:NSDictionary.class]) {
            
            destinationHeader = header.copy;
        }
    }
    
    return destinationHeader;
}

- (NSDictionary *)_requestParametersWithURL:(NSString *)urlString originalParameters:(NSDictionary *)originalParameters {
    
    NSDictionary *parameters = originalParameters;
    if (self.requestHandler && [self.requestHandler respondsToSelector:@selector(parametersFromRequest:urlString:parameters:)]) {
        
        NSDictionary *newParameters = [self.requestHandler parametersFromRequest:self urlString:urlString parameters:originalParameters];
        
        if ([newParameters isKindOfClass:NSDictionary.class]) {
            
            parameters = newParameters.copy;
        }
    }
    
    return parameters;
}


- (CCResponseMetaModel *)_handleResponseRawData:(NSURLSessionDataTask * _Nullable)task responseObject:(id)responseObject error:(NSError *)error {
    
    if (!self.requestHandler) {
        
        NSAssert(NO, @"Please config paging request handler!");
        return nil;
    }
    
    CCResponseMetaModel *model = [CCResponseMetaModel new];
    model.rawData = responseObject;
    
    id contentData = nil;
    NSInteger code = -1;
    NSString *message = nil;
    if (!error && responseObject) {
        
        contentData = [self.requestHandler dataContentFromRequest:self task:task responseObject:responseObject];
        code = [self.requestHandler statusCodeFromRequest:self task:task responseObject:responseObject];
        message = [self.requestHandler messageFromRequest:self task:task responseObject:responseObject];
    } else {
        
        code = error.code;
        message = error.description;
        model.error = error;
    }
    
    BOOL success = [self.requestHandler successFromRequest:self code:code];
    model.success = !error && success;
    model.contentData = contentData;
    model.code = code;
    model.message = message;
    
    return model;
}

- (id<CCNetworkRequestHandler>)requestHandler {
    
    if (_requestHandler) return _requestHandler;
    
    return [requestGlobeHandler new];
}

+ (void)registerGlobeRequestHandler:(Class<CCNetworkRequestHandler>)globeRequestHandler {
    
    requestGlobeHandler = globeRequestHandler;
}

@end
