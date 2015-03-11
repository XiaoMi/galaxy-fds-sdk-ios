//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalaxyFDSCredential.h"

@interface FDSSSOCredential : NSObject <GalaxyFDSCredential>
- (id)initWithToken:(NSString *)serviceToken andAppId:(NSString *)appId;
@end
