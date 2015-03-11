//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSUtilities.h"
#import "GalaxyFDSClientException.h"

const int BUFFER_SIZE = 4096;

@implementation FDSUtilities {

}
+ (NSDictionary *)parseUriParameters:(NSURL *)uri {
  NSString *query = [uri query];
  id parameters = [[NSMutableDictionary alloc] init];
  if (query) {
    for (NSString *item in [query componentsSeparatedByString:@"&"]) {
      id kv = [item componentsSeparatedByString:@"="];
      id list = [parameters objectForKey:kv[0]];
      if (!list) {
        list = [[NSMutableArray alloc] init];
        parameters[kv[0]] = list;
      }
      if ([kv count] >= 2) {
        [list addObject:[item substringFromIndex:([kv[0] length] + 1)]];
      } else {
        [list addObject:kv[0]];
      }
    }
  }
  return parameters;
}

+ (NSString *)formatDateString:(NSDate *)date {
  return [[self getDateFormatter] stringFromDate:date];
}

+ (NSDate *)parseDate:(NSString *)dateString {
  return [[self getDateFormatter] dateFromString:dateString];
}

+ (void)downloadObject:(FDSObject *)object toFile:(NSString *)destinationFile
    withAppendFlag:(BOOL *)isAppend {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *parentDirectory = [destinationFile stringByDeletingLastPathComponent];
  NSError *error;
  if (!*isAppend && parentDirectory != nil) {
    BOOL isDir;
    if (![fileManager fileExistsAtPath:parentDirectory isDirectory:&isDir]) {
      if (![fileManager createDirectoryAtPath:parentDirectory
          withIntermediateDirectories:YES attributes:nil error:&error]) {
        @throw [GalaxyFDSClientException exceptionWithReason:[NSString
            stringWithFormat:@"Create directory(%@) failed because: %@",
            parentDirectory, [error localizedDescription]]
            userInfo:[error userInfo]];
      }
    } else if (!isDir) {
      @throw [GalaxyFDSClientException exceptionWithReason:[NSString
          stringWithFormat:@"Create directory(%@) failed because it exists and "
          "is not a directory", parentDirectory] userInfo:nil];
    }
  }
  if ([fileManager fileExistsAtPath:destinationFile] && !*isAppend) {
    [fileManager removeItemAtPath:destinationFile error:&error];
    if (error) {
      @throw [GalaxyFDSClientException exceptionWithReason:[NSString
          stringWithFormat:@"Cannot delete file:%@", destinationFile]
          userInfo:[error userInfo]];
    }
  }
  if (![fileManager fileExistsAtPath:destinationFile]) {
    if (![fileManager createFileAtPath:destinationFile contents:nil
        attributes:nil]) {
      @throw [GalaxyFDSClientException exceptionWithReason:[NSString
          stringWithFormat:@"Create file(%@) failed", destinationFile]
          userInfo:nil];
    }
  }
  NSFileHandle *fileHandle = [NSFileHandle
      fileHandleForWritingAtPath:destinationFile];
  if (!fileHandle) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Cannot open file(%@) for writing", destinationFile]
        userInfo:nil];
  }
  if (*isAppend) {
    [fileHandle seekToEndOfFile];
  }
  *isAppend = YES;
  NSInteger bytesRead;
  uint8_t buffer[BUFFER_SIZE];
  FDSObjectInputStream *in = object.objectContent;
  [in open];
  @try {
    while ((bytesRead = [in read:buffer maxLength:BUFFER_SIZE]) > 0) {
      [fileHandle writeData:[NSData dataWithBytes:buffer length:
          (NSUInteger) bytesRead]];
    }
    if (bytesRead == -1) {
      @throw [GalaxyFDSClientException exceptionWithReason:@"operation failed "
          "when reading content of object" userInfo:nil];
    }
  } @catch (NSException *e) {
    @throw [GalaxyFDSClientException exceptionWithReason:[e reason] userInfo:
        [e userInfo]];
  } @finally {
    [in close];
    [fileHandle closeFile];
  }
}

+ (NSDateFormatter *)getDateFormatter {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
  [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
  return dateFormatter;
}


+ (long long)getFileLength:(NSString *)fileName {
  id fileDescription = [self getFileDescription:fileName error:nil ];
  if (!fileDescription) {
    return -1;
  }
  return [fileDescription fileSize];
}

+ (NSString *)getFileMineType:(NSString *)fileName {
  NSError *error;
  NSString *fullPath = [fileName stringByExpandingTildeInPath];
  NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
  NSURLRequest *fileUrlRequest = [NSURLRequest requestWithURL:fileUrl];
  NSURLResponse *response;
  [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:
      &response error:&error];
  if (error) {
    return nil;
  }
  return [response MIMEType];
}

+ (NSDate *)getFileLastModifiedDate:(NSString *)fileName {
  id fileDescription = [self getFileDescription:fileName error:nil ];
  if (!fileDescription) {
    return nil;
  }
  return [fileDescription fileModificationDate];
}

+ (NSDictionary *)getFileDescription:(NSString *)fileName error:(NSError **)error {
  NSError *err;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSDictionary *dictFile = [fileManager attributesOfItemAtPath:fileName error:&err];
  if (error != nil) {
    *error = err;
  }
  if (!err) {
    return dictFile;
  } else {
    return nil;
  }
}

+ (long long)min:(long long)left and:(long long)right {
  return left < right ? left : right;
}
@end
