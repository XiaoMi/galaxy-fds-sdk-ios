//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSArgs.h"


@implementation FDSArgs {

}

+ (void)check:(BOOL)expression andMessage:(NSString *)message {
  if (!expression) {
    [NSException raise:NSInvalidArgumentException format:@"%@", message];
  }

}

+ (id)notNil:(id)argument forName:(NSString *)name {
  if (argument == nil) {
    [NSException raise:NSInvalidArgumentException
        format:@"%@ may not be nil", name];
  }
  return argument;
}

+ (id)notEmpty:(id)argument forName:(NSString *)name {
  [self notNil:argument forName:name];
  if ([argument length] == 0) {
    [NSException raise:NSInvalidArgumentException
        format:@"%@ may not be empty", name];
  }
  return argument;
}

+ (long long)positive:(long long)n forName:(NSString *)name {
  if (n <= 0) {
    [NSException raise:NSInvalidArgumentException
        format:@"%@ may not be negative or zero", name];
  }
  return n;
}

+ (long long)notNegative:(long long)n forName:(NSString *)name {
  if (n < 0) {
    [NSException raise:NSInvalidArgumentException
        format:@"%@ may not be negative", name];
  }
  return n;
}

@end
