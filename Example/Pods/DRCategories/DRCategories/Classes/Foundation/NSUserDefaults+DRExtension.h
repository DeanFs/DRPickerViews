//
//  NSUserDefaults+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (DRExtension)

#pragma mark - 读取
+ (nullable id)objectForKey:(NSString *)defaultName;
+ (nullable NSString *)stringForKey:(NSString *)defaultName;
+ (nullable NSArray *)arrayForKey:(NSString *)defaultName;
+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;
+ (nullable NSData *)dataForKey:(NSString *)defaultName;
+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;
+ (NSInteger)integerForKey:(NSString *)defaultName;
+ (float)floatForKey:(NSString *)defaultName;
+ (double)doubleForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;

#pragma mark - 写
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (void)setFloat:(float)value forKey:(NSString *)defaultName;
+ (void)setDouble:(double)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

#pragma mark - 清除
+ (void)removeObjectForKey:(NSString *)defaultName;
/// 清除所有userDefault
+ (void)clean;

#pragma mark - appGroup
/// 获取group：group.com.huashengweilai.weilaiguanjia
+ (NSUserDefaults *)groupDefaults;

@end

NS_ASSUME_NONNULL_END
