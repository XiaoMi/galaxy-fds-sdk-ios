//
// Created by ss on 15-2-15.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GalaxyFDSClientException : NSException
+ (id)exceptionWithReason:(NSString *)reason userInfo:(NSDictionary *)info;
@end
