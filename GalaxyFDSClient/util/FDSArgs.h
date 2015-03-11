//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSArgs : NSObject
+ (void)check:(BOOL)expression andMessage:(NSString *)message;

+ (id)notNil:(id)argument forName:(NSString *)name;

+ (id)notEmpty:(id)argument forName:(NSString *)name;

+ (long long)positive:(long long)n forName:(NSString *)name;

+ (long long)notNegative:(long long)n forName:(NSString *)name;
@end
