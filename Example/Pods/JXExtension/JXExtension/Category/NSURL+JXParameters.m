//
//  NSURL+JXParameters.m
//  JXExtension
//
//  Created by Jeason on 2017/9/22.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "NSURL+JXParameters.h"
#import <objc/runtime.h>

static void *kURLParametersDictionaryKey;

@implementation NSURL (JXParameters)

#pragma mark - Public Method

- (id)jx_objectForKeyedSubscript:(id)key {
    return self.parameters[key];
}

- (NSString *)jx_parameterForKey:(NSString *)key {
    return self.parameters[key];
}

#pragma mark - Private Method

- (void)scanParameters {
    if (self.isFileURL) {
        return;
    }
    NSScanner *scanner = [NSScanner scannerWithString:self.absoluteString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"] ];
    //skip to ?
    [scanner scanUpToString:@"?" intoString:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *tmpValue;
    while ([scanner scanUpToString:@"&" intoString:&tmpValue]) {
        NSArray *components = [tmpValue componentsSeparatedByString:@"="];
        if (components.count >= 2) {
            NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [components[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            parameters[key] = value;
        }
    }
    self.parameters = parameters;
}

- (NSDictionary *)parameters {
    NSDictionary *result = objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
    if (!result) {
        [self scanParameters];
    }
    return objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
}

- (void)setParameters:(NSDictionary *)parameters {
    objc_setAssociatedObject(self, &kURLParametersDictionaryKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
