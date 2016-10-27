//
//  SXURLCache.h
//  SXURLCache
//
//  Created by dfpo on 16/10/27.
//  Copyright © 2016年 dfpo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXURLCache : NSObject

+ (instancetype) sharedInstance;

/**
 *  添加url缓存data
 */
- (void) addCacheWithUrl: (NSString *)url data:data;
/**
 *  添加url缓存data并指定缓存失效时间（自缓存时间起算）
 */
- (void) addCacheWithUrl: (NSString *)url data:data expiryTime:(NSTimeInterval)expireTime;
/**
 *  拿到url对应的缓存的data
 */
- cacheDataWithUrl: (NSString *)url;
/**
 *  url缓存的data是否缓存
 */
- (BOOL) isUrlCached: (NSString *)url;
/**
 *  清空所有缓存
 */
- (void) clearAll;
/**
 *  清空url对应的缓存
 */
- (void) clearCacheWithUrl: (NSString *)url;

@end
