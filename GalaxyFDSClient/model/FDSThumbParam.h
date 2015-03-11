//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

/**
* User defined parameters for get thumbnail
*/
#import <Foundation/Foundation.h>
#import "FDSUserParam.h"

@interface FDSThumbParam : FDSUserParam

/**
* @param width The width of thumbnail
* @param height The height of thumbnail
*/
- (id)initWithWidth:(int)width andHeight:(int)height;
@end
