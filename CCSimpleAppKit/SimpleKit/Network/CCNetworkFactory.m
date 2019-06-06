//
//  CCNetworkRequestFactory.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/6/3.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCNetworkFactory.h"

static Class<CCNetworkService, CCSingletonService> networkGlobeService = nil;

@implementation CCNetworkFactory

+ (id<CCNetworkService>)globeRequestService {
    
    return [networkGlobeService sharedInstance];
}

+ (id<CCNetworkService>)dequeueReusableRequestService {
    
    return [self globeRequestService];
}

+ (void)registerGlobeRequestService:(Class<CCNetworkService, CCSingletonService>)globeRequestService {
    
    networkGlobeService = globeRequestService;
}

+ (void)registerGlobeRequestHandler:(Class<CCNetworkRequestHandler>)globeRequestHandler {
    
    [CCNetworkRequest registerGlobeRequestHandler:globeRequestHandler];
}

+ (void)registerGlobePagingRequestHandler:(Class<CCPagingRequestHandler>)globePagingRequestHandler {
    
    [CCPagingRequest registerGlobePagingRequestHandler:globePagingRequestHandler];
}

@end
