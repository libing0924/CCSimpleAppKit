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

typedef void(^success_block)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^failed_block) (NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
typedef void (^response_block)(CCResponseMetaModel *);

@implementation CCResponseMetaModel

@end

@interface CCNetworkRequest ()

@property (nonatomic, copy) success_block(^req_success_block)(response_block response);
@property (nonatomic, copy) failed_block(^req_failed_block)(response_block response);

@end
@implementation CCNetworkRequest

- (void)requestGET:(NSString *)urlStr parameters:(NSDictionary *)params response:(void (^)(CCResponseMetaModel *))response {
    
    NSDictionary *header = [self _requestHeaderWithURL:urlStr];
    NSDictionary *newParameters = [self _requestParametersWithURL:urlStr originalParameters:params];
    
    [[CCNetworkFactory globeRequestService] requestGET:urlStr parameters:newParameters headers:header success:self.req_success_block(response) failure:self.req_failed_block(response)];
}

- (void)requestPOST:(NSString *)urlStr parameters:(NSDictionary *)params response:(void (^)(CCResponseMetaModel *))response {
    
    NSDictionary *header = [self _requestHeaderWithURL:urlStr];
    NSDictionary *newParameters = [self _requestParametersWithURL:urlStr originalParameters:params];
    
    [[CCNetworkFactory globeRequestService] requestPOST:urlStr parameters:newParameters headers:header success:self.req_success_block(response) failure:self.req_failed_block(response)];
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

#pragma mark - getter

- (id<CCNetworkRequestHandler>)requestHandler {
    
    if (_requestHandler) return _requestHandler;
    
    return [requestGlobeHandler new];
}

- (success_block (^)(response_block))req_success_block {
    
    return ^success_block(response_block response) {
        
        return ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:responseObject error:nil];
            response(dataModel);
        };
    };
}

- (failed_block (^)(response_block))req_failed_block {
    
    return ^failed_block(response_block response) {
        
        return ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            CCResponseMetaModel *dataModel = [self _handleResponseRawData:task responseObject:nil error:error];
            response(dataModel);
        };
    };
}

+ (void)registerGlobeRequestHandler:(Class<CCNetworkRequestHandler>)globeRequestHandler {
    
    requestGlobeHandler = globeRequestHandler;
}

@end
