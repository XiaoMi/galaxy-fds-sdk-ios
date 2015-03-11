//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSObject.h"


@interface FDSUtilities : NSObject
+ (NSDictionary *)parseUriParameters:(NSURL *)uri;

+ (NSString *)formatDateString:(NSDate *)date;

+ (NSDate *)parseDate:(NSString *)dateString;

+ (void)downloadObject:(FDSObject *)object toFile:(NSString *)destinationFile
    withAppendFlag:(BOOL *)isAppend;

+ (long long int)getFileLength:(NSString *)fileName;

+ (NSString *)getFileMineType:(NSString *)fileName;

+ (NSDate *)getFileLastModifiedDate:(NSString *)fileName;

+ (NSDictionary *)getFileDescription:(NSString *)fileName error:(NSError **)error;

+ (long long)min:(long long)left and:(long long)right;
@end
