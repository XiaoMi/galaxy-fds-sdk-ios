//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSUserParam : NSObject {
  NSMutableDictionary *_params;
}
@property(readonly) NSDictionary *params;

- (id)init;

- (NSString *)description;
@end
