//
//  CCSingletonDelegate.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/6/3.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCSingletonService <NSObject>

@required
+ (id)sharedInstance;

@end
