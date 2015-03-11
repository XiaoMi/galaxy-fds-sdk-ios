//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GalaxyFDSCredential.h"

@interface FDSSignatureCredential : NSObject <GalaxyFDSCredential>
- (id)initWithAccessKeyId:(NSString *)accessKeyId
    andSecretAccessKeyId:(NSString *)secretAccessKeyId;
@end
