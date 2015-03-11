//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDSClientConfiguration.h"
#import "FDSObjectMetadata.h"
#import "FDSProgressListener.h"
#import "FDSPutObjectResult.h"
#import "FDSObject.h"

@class FDSUploadPartResult;

@interface GalaxyFDSClient : NSObject
- (id)initWithConfig:(FDSClientConfiguration *)fdsConfig;

/**
 * <p>
 * Gets the object metadata for the object stored in Galaxy FDS under the
 * specified bucket and object, like the length of object. The content of object
 * will not be downloaded
 * </p>
 * <p>
 * To get metadata of object from Galaxy FDS, the caller must have read
 * permission to access to the object.
 * </p>
 *
 * @param objectName       The name of the object to be downloaded
 * @param bucketName       The name of the bucket containing the desired object.
 * @return All object metadata for the specified object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response, or writing the incoming data
 *                                  from FDS to the specified destination file.
 *                                  destination file.
 */
- (FDSObjectMetadata *)getMetaDataOfObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName;

/**
 * @see #getObject:fromBucket:withOffset:andLength:andParams:andProgressListener:
 */
- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName;

/**
 * @see #getObject:fromBucket:withOffset:andLength:andParams:andProgressListener:
 */
- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andParams:(NSArray *)params;

/**
 * @see #getObject:fromBucket:withOffset:andLength:andParams:andProgressListener:
 */
- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * <p>
 * Gets part of object stored in Galaxy FDS under the specified bucket, with
 * user defined parameters and with a progress listener which will notify the
 * caller periodically of how many bytes have been consumed.
 * Content range of the got object is from [offset, offset + length).
 * </p>
 * <p>
 * This method will download the whole content required into memory and return a
 * stream containing the data. This method will be improved in the future to
 * return a direct stream of data from HTTP connection, that will shorten the
 * response time.
 * </p>
 * <p>
 * To get an object from Galaxy FDS, the caller must have read permission
 * access to the object.
 * </p>
 *
 * @param objectName       The name of the object to be downloaded
 * @param bucketName       The name of the bucket containing the desired object.
 * @param offset           The position of object content where client begins
 *                         downloading
 * @param length           The length of content to be downloaded. Please make
 *                         sure that (offset+length) <= (length of object)
 * @param params           The user defined parameters
 * @param progressListener The progress listener for receiving updates about
 *                         object consumed status.
 * @return The object stored in Galaxy FDS in the specified bucket and object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andLength:(long long)length
    andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #getObjectOnURI:withOffset:andLength:andParams:andProgressListener:
 */
- (FDSObject *)getObjectOnURI:(NSString *)uriString withOffset:(long long)offset
    andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * <p>
 * Gets part of object stored in Galaxy FDS from URL, with user defined
 * parameters and with a progress listener which will notify the caller
 * periodically of how many bytes have been consumed.
 * Content range of the got object is from [offset, offset + length).
 * </p>
 * <p>
 * This method will download the whole content required into memory and return a
 * stream containing the data. This method will be improved in the future to
 * return a direct stream of data from HTTP connection, that will shorten the
 * response time.
 * </p>
 * <p>
 * To get an object from Galaxy FDS, the caller must have read permission
 * access to the object.
 * </p>
 *
 * @param uriString        The url for getting object
 * @param offset           The position of object content where client begins
 *                         downloading
 * @param length           The length of content to be downloaded. Please make
 *                         sure that (offset+length) <= (length of object)
 * @param params           The user defined parameters
 * @param progressListener The progress listener for receiving updates about
 *                         object consumed status.
 * @return The object stored in Galaxy FDS in the specified bucket and object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSObject *)getObjectOnURI:(NSString *)uriString withOffset:(long long)offset
    andLength:(long long)length andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #getObject:fromBucket:toFile:withParams:andProgressListener:
 */
- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile;

/**
 * @see #getObject:fromBucket:toFile:withParams:andProgressListener:
 */
- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile
    withParams:(NSArray *)params;

/**
 * <p>
 * Gets the object metadata for the object stored in Galaxy FDS under the
 * specified bucket and object, and saves the object contents to the specified
 * file.
 * Progress listener which will notify the caller periodically of how many
 * bytes have been saved.
 * </p>
 * <p>
 * Instead of using {@link GalaxyFDSClient#getObject(String, String)}, use
 * this method to ensure that the object will be downloaded part by part, and
 * will not be load into memory as a whole object.
 * </p>
 * <p>
 * To get an object from Galaxy FDS, the caller must have read permission to
 * access to the object.
 * </p>
 *
 * @param objectName       The name of the object to be downloaded
 * @param bucketName       The name of the bucket containing the desired object.
 * @param destinationFile  Indicates the file (which might already exist) where
 *                         to save the object content being downloading from
 *                         Galaxy FDS.
 * @param params           The user defined parameters
 * @param listener         The progress listener for saving updates about
 *                         object download status.
 * @return All object metadata for the specified object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response, or writing the incoming data
 *                                  from FDS to the specified destination file.
 *                                  destination file.
 */
- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile
    withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #putObject:intoBucket:fromFile:withObjectMetadata:andParams: \
 *                 andProgressListener:
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName;

/**
 * @see #putObject:intoBucket:fromFile:withObjectMetadata:andParams: \
 *                 andProgressListener:
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName
    withParams:(NSArray *)params;

/**
 * <p>
 * Uploads the specified file to Galaxy FDS under the specified bucket and
 * object name.
 * </p>
 * <p>
 * Galaxy FDS never stores partial objects;
 * if during this call an exception wasn't thrown,
 * the entire object was stored.
 * </p>
 * <p>
 * The client automatically computes
 * a checksum of the file.
 * Galaxy FDS uses checksum to validate the data in each file.
 * </p>
 * <p>
 * Using the file extension, Galaxy FDS attempts to determine
 * the correct content type and content disposition to use
 * for the object.
 * </p>
 * <p>
 * This operation will overwrite an existing object with the same object;
 * Galaxy FDS will store the last write request. Galaxy FDS does not provide
 * object locking. If Galaxy FDS receives multiple write requests for the same
 * object nearly simultaneously, all of the objects might be stored. However,
 * a single object will be stored with the final write request.
 * </p>
 * <p>
 * The specified bucket must already exist and the caller must have write
 * permission to the bucket to upload an object.
 * </p>
 *
 * @param objectName       The name of the object to be uploaded
 * @param bucketName       The name of an existing bucket, to which you have
 *                         write permission.
 * @param fileName         The file containing the data to be uploaded to
 *                         Galaxy FDS.
 * @param params           The user defined parameters
 * @param listener         The progress listener for receiving updates about
 *                         object download status.
 * @return A {@link PutObjectResult} object containing the information
 * returned by Galaxy FDS for the newly created object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName
    withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #putObject:intoBucket:fromInputStream:withObjectMetadata:andParams: \
 *                 andProgressListener:
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata;

/**
 * @see #putObject:intoBucket:fromInputStream:withObjectMetadata:andParams: \
 *                 andProgressListener:
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params;

/**
 * <p>
 * Uploads the specified input stream and object metadata to Galaxy FDS under
 * the specified bucket and object name. The input stream will be closed
 * whether or not putObject() succeed.
 * Progress listener which will notify the caller periodically of how many
 * bytes have been uploaded.
 * </p>
 * <p>
 * Galaxy FDS never stores partial objects; if during this call an exception
 * wasn't thrown, the entire object was stored.
 * </p>
 * <p>
 * The client automatically computes checksum of the file. This checksum is
 * verified against another checksum that is calculated once the data reaches
 * Galaxy FDS, ensuring the data has not corrupted in transit over the network.
 * </p>
 * <p>
 * Content length <b>must</b> be specified before data can be uploaded to
 * Galaxy FDS. If the caller doesn't provide it, the library will <b>have
 * to</b> buffer the contents of the input stream in order to calculate it
 * because Galaxy FDS explicitly requires that the content length be sent in
 * the request headers before any of the data is sent.
 * </p>
 * <p/>
 * <p>
 * this operation will overwrite an existing object with the same object;
 * Galaxy FDS will store the last write request. Galaxy FDS does not provide
 * object locking.
 * If Galaxy FDS receives multiple write requests for the same object nearly
 * simultaneously, all of the objects might be stored.  However, a single
 * object will be stored with the final write request.
 * </p>
 * <p/>
 * <p>
 * The specified bucket must already exist and the caller must have write
 * permission to the bucket to upload an object.
 * </p>
 *
 * @param objectName       The name of the object to be uploaded
 * @param bucketName       The name of an existing bucket, to which you have
 *                         write permission.
 * @param input            The input stream containing the data to be uploaded.
 * @param metadata         Additional metadata instructing Galaxy FDS how to
 *                         handle the uploaded data (e.g. custom user metadata,
 *                         hooks for specifying content type, etc.).
 * @param params           The user defined parameters
 * @param listener         The progress listener for receiving updates about
 *                         object download status.
 * @return A {@link PutObjectResult} object containing the information returned
 * by Galaxy FDS for the newly created object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #putObjectToBucket:fromFile:withParams:andProgressListener:
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName;

/**
 * @see #putObjectToBucket:fromFile:withParams:andProgressListener:
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName withParams:(NSArray *)params;

/**
 * <p>
 * Upload the specified file to Galaxy FDS under the specified bucket,
 * FDS service will generate a unique object name.
 * Progress listener which will notify the caller periodically of how many
 * bytes have been uploaded.
 * </p>
 * <p>
 * Galaxy FDS never stores partial objects; if during this call an exception
 * wasn't thrown, the entire object was stored.
 * </p>
 * <p>
 * The client automatically computes a checksum of the file. Galaxy FDS uses
 * checksum to validate the data in each file.
 * </p>
 * <p>
 * Using the file extension, Galaxy FDS attempts to determine the correct
 * content type and content disposition to use for the object.
 * </p>
 * <p>
 * This operation will create a new object, whose name will be unique in the
 * specified bucket.
 * </p>
 * <p>
 * The specified bucket must already exist and the caller must have write
 * permission to the bucket to upload an object.
 * </p>
 *
 * @param bucketName       The name of an existing bucket, to which you have
 *                         write permission.
 * @param file             The file containing the data to be uploaded to
 *                         Galaxy FDS.
 * @param params           The user defined parameters
 * @param listener         The progress listener for receiving updates about
 *                         object upload status.
 * @return A {@link PutObjectResult} object containing the information
 * returned by Galaxy FDS for the newly created object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * @see #putObjectToBucket:fromInputStream:withObjectMetadata:andParams: \
 *                         andProgressListener:
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata;

/**
 * @see #putObjectToBucket:fromInputStream:withObjectMetadata:andParams: \
 *                         andProgressListener:
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params;

/**
 * <p>
 * Upload the specified file to Galaxy FDS under the specified bucket, the
 * input stream will be closed whether or not putObject() succeed
 * FDS service will generate a unique object name.
 * Progress listener which will notify the caller periodically of how many
 * bytes have been uploaded.
 * </p>
 * <p>
 * Galaxy FDS never stores partial objects; if during this call an exception
 * wasn't thrown, the entire object was stored.
 * </p>
 * <p>
 * The client automatically computes a checksum of the file. Galaxy FDS uses
 * checksum to validate the data in each file.
 * </p>
 * <p>
 * Content length <b>must</b> be specified before data can be uploaded to
 * Galaxy FDS. If the caller doesn't provide it, the library will <b>have
 * to</b> buffer the contents of the input stream in order to calculate it
 * because Galaxy FDS explicitly requires that the content length be sent in
 * the request headers before any of the data is sent.
 * </p>
 * <p>
 * This operation will create a new object, whose name will be unique in the
 * specified bucket.
 * </p>
 * <p>
 * The specified bucket must already exist and the caller must have write
 * permission to the bucket to upload an object.
 * </p>
 *
 * @param bucketName       The name of an existing bucket, to which you have
 *                         write permission.
 * @param input            The input stream containing the data to be uploaded.
 * @param metadata         Additional metadata instructing Galaxy FDS how to
 *                         handle the uploaded data (e.g. custom user metadata,
 *                         hooks for specifying content type, etc.).
 * @param params           The user defined parameters
 * @param listener         The progress listener for receiving updates about
 *                         object download status.
 * @return A {@link PutObjectResult} object containing the information
 * returned by Galaxy FDS for the newly created object.
 * @throws GalaxyFDSClientException If any errors are encountered in the client
 *                                  while making the request or handling the
 *                                  response.
 */
- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener;

/**
 * Test if object exists.
 *
 * @param objectName The name of the object to be test
 * @param bucketName The name of the bucket containing the desired object.
 * @return True if object exists, otherwise false
 * @throws GalaxyFDSClientException
 */
- (BOOL)doesObject:(NSString *)objectName existInBucket:(NSString *)bucketName;

/**
 * Just for internal use. SHOULD NOT be called by SDK users
 */
- (FDSUploadPartResult *)uploadPart:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromStream:(FDSObjectInputStream *)input
    withId:(NSString *)uploadId andPartNumber:(int *)partNumber
    andLength:(long long)contentLength;
@end
