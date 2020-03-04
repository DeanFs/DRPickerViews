//
//  NSUserDefaults+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/8.
//

#define kUserGroupName @"group.com.huashengweilai.weilaiguanjia"

#import "NSUserDefaults+DRExtension.h"

@implementation NSUserDefaults (DRExtension)

#pragma mark - 读取
+ (nullable id)objectForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (nullable NSString *)stringForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (nullable NSArray *)arrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (nullable NSData *)dataForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

#pragma mark - 写
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault setObject:value forKey:defaultName];
    [groupDefault synchronize];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:value forKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault setInteger:value forKey:defaultName];
    [groupDefault synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:value forKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault setFloat:value forKey:defaultName];
    [groupDefault synchronize];
}

+ (void)setDouble:(double)value forKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:value forKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault setDouble:value forKey:defaultName];
    [groupDefault synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:value forKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault setBool:value forKey:defaultName];
    [groupDefault synchronize];
}

#pragma mark - 清除
+ (void)removeObjectForKey:(NSString *)defaultName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:defaultName];
    [userDefault synchronize];
    
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault removeObjectForKey:defaultName];
    [groupDefault synchronize];
}

+ (void)clean {
    NSUserDefaults *groupDefault = [NSUserDefaults groupDefaults];
    [groupDefault removePersistentDomainForName:kUserGroupName];
    [groupDefault synchronize];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removePersistentDomainForName:appDomain];
    [userDefault synchronize];
}

#pragma mark - 自定义组设置
+ (NSUserDefaults *)groupDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:kUserGroupName];
}

@end
