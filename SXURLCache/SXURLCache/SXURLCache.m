//
//  SXURLCache.m
//  SXURLCache
//
//  Created by dfpo on 16/10/27.
//  Copyright © 2016年 dfpo. All rights reserved.
//

#import "SXURLCache.h"

@interface SXURLCache ()
/**
 *  缓存存放路径
 */
@property (nonatomic) NSString * basePath;
/**
 *  nscahce url expiryTime
 */
@property (nonatomic) NSCache *urlCacheDataExpiryTimeCache;
@end

@implementation SXURLCache
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlCacheDataExpiryTimeCache = [[NSCache alloc] init];
        self.basePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"SXURLCache"];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:self.basePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return self;
}

- (NSString *) cachePathByUrl: (NSString *)url
{
    NSString * file = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [self.basePath stringByAppendingPathComponent:file];
}
/**
 *  缓存失效时间设定
 */
- (void) addCacheWithUrl: (NSString *)url data:data expiryTime:(NSTimeInterval)expireTime {
    
    [self addCacheWithUrl:url data:data];
    [self.urlCacheDataExpiryTimeCache setObject:@(expireTime) forKey:url];
}

- (void) addCacheWithUrl: (NSString *)url data:data;
{
    NSString * path = [self cachePathByUrl:url];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

- cacheDataWithUrl: (NSString *)url
{
    NSString * path = [self cachePathByUrl:url];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSNumber *cacheTimeNum = [self.urlCacheDataExpiryTimeCache objectForKey:url];
    if (cacheTimeNum == nil) {
        
        if (![fm fileExistsAtPath:path]) {
            return nil;
        }
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    
    NSDictionary *attribuDict = [fm attributesOfItemAtPath:path error:nil];
    
    NSDate *fileCreatDate =
    [self localeDateForData:attribuDict[NSFileCreationDate]];
    NSDate *currentDate = [self localeDateForData:[NSDate date]];
    NSTimeInterval duration = [currentDate timeIntervalSinceDate:fileCreatDate];
    NSTimeInterval cacaheTime = cacheTimeNum.doubleValue;
    
    if (duration > cacaheTime) {
        NSLog(@"----%@---", @"cahce data expriy ");
        [self clearCacheWithUrl:url];
        return nil;
    }
    
    
    if (![fm fileExistsAtPath:path]) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (BOOL) isUrlCached: (NSString *)url
{
    
    
    NSString * path = [self cachePathByUrl:url];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSNumber *cacheTimeNum = [self.urlCacheDataExpiryTimeCache objectForKey:url];
    if (cacheTimeNum == nil) {
        
        return [fm fileExistsAtPath:path];
    }
    
    
    NSDictionary *attribuDict = [fm attributesOfItemAtPath:path error:nil];
    
    NSDate *fileCreatDate =
    [self localeDateForData:attribuDict[NSFileCreationDate]];
    NSDate *currentDate = [self localeDateForData:[NSDate date]];
    NSTimeInterval duration = [currentDate timeIntervalSinceDate:fileCreatDate];
    NSTimeInterval cacaheTime = cacheTimeNum.doubleValue;
    
    if (duration > cacaheTime) {
        
        [self clearCacheWithUrl:url];
        return NO;
    }
    
    return [fm fileExistsAtPath:path];
    
}

- (void) clearCacheWithUrl: (NSString *)url
{
    NSString * path = [self cachePathByUrl:url];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void) clearAll
{
    NSArray * fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.basePath error:nil];
    if (fileArray.count==0) {
        return;
    }
    
    for (NSString * filename in fileArray) {
        NSString * path = [self.basePath stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}
#pragma mark - private
- (NSDate *)localeDateForData:(NSDate *)aData {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: aData];
    
    NSDate *localeDate = [aData  dateByAddingTimeInterval: interval];
    return  localeDate;
}
@end
