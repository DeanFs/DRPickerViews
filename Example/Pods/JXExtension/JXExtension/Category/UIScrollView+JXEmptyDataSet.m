//
//  UIScrollView+JXEmptyDataSet.m
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "UIScrollView+JXEmptyDataSet.h"
#import <objc/runtime.h>

static NSMutableDictionary *_impLookupTable;
static NSString * const JXSwizzleInfoPointerKey = @"JXSwizzleInfoPointerKey";
static NSString * const JXSwizzleInfoOwnerKey = @"JXSwizzleInfoOwnerKey";
static NSString * const JXSwizzleInfoSelectorKey = @"JXSwizzleInfoSelectorKey";

@interface UIScrollView ()

@property (nonatomic, strong) UIView *emptyDataSetView;

@property (nonatomic, assign) NSInteger numberOfItems;

@end

@implementation UIScrollView (JXEmptyDataSet)

#pragma mark - Public method

- (void)jx_reloadEmptyDataSet {
    
    if (![self canDisplay]) {
        return;
    }
    
    BOOL isEmpty = !self.numberOfItems;
    if (!isEmpty != !self.emptyDataSetView) {
        if (isEmpty) {
            //Set view
            if ([self.emptyDataSetDataSource respondsToSelector:@selector(emptyDataSetViewForScrollView:)]) {
                self.emptyDataSetView = [self.emptyDataSetDataSource emptyDataSetViewForScrollView:self];
                [self addSubview:self.emptyDataSetView];
            }
        } else {
            [[self.emptyDataSetView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.emptyDataSetView removeFromSuperview];
            self.emptyDataSetView = nil;
        }
    } else if (isEmpty) {
        [self bringSubviewToFront:self.emptyDataSetView];
    } else {
        if (self.emptyDataSetView) {
            [self.emptyDataSetView removeFromSuperview];
            [self setEmptyDataSetView:nil];
        }
    }
}

- (void)jx_removeEmptyDataSet {
    [self.emptyDataSetView removeFromSuperview];
    self.emptyDataSetView = nil;
}

#pragma mark - Swizzling

void jx_original_implementation(id self, SEL _cmd) {
    // Fetch original implementation from lookup table
    NSString *key = jx_implementationKey(self, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:JXSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isEmptyDataSetVisible' flag on time.
    [self jx_reloadEmptyDataSet];
    
    // If found, call original implementation
    if (impPointer) {
        ((void (*)(id, SEL))impPointer)(self, _cmd);
    }
}

NSString *jx_implementationKey(id target, SEL selector) {
    if (!target || !selector) {
        return nil;
    }
    
    Class baseClass;
    if ([target isKindOfClass:[UITableView class]]) {
        baseClass = [UITableView class];
    } else if ([target isKindOfClass:[UICollectionView class]]) {
        baseClass = [UICollectionView class];
    } else if ([target isKindOfClass:[UIScrollView class]]) {
        baseClass = [UIScrollView class];
    } else {
        return nil;
    }
    
    NSString *className = NSStringFromClass([baseClass class]);
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@", className, selectorName];
}

- (void)swizzleIfPossible:(SEL)selector {
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_impLookupTable) {
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:JXSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:JXSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    NSString *key = jx_implementationKey(self, selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:JXSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue || !key) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod([self class], selector);
    IMP jx_newImplementation = method_setImplementation(method, (IMP)jx_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{JXSwizzleInfoOwnerKey: [self class],
                                   JXSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   JXSwizzleInfoPointerKey: [NSValue valueWithPointer:jx_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}

#pragma mark - Property method

- (id <JXEmptyDataSetDataSource> )emptyDataSetDataSource {
    return objc_getAssociatedObject(self, @selector(emptyDataSetDataSource));
}

- (void)setEmptyDataSetDataSource:(id <JXEmptyDataSetDataSource> )emptyDataSetDataSource {
    objc_setAssociatedObject(self, @selector(emptyDataSetDataSource), emptyDataSetDataSource, OBJC_ASSOCIATION_ASSIGN);
    if (emptyDataSetDataSource && [self canDisplay]) {
        // We add method sizzling for injecting -dzn_reloadData implementation to the native -reloadData implementation
        [self swizzleIfPossible:@selector(reloadData)];
        
        // Exclusively for UITableView, we also inject -dzn_reloadData to -endUpdates
        if ([self isKindOfClass:[UITableView class]]) {
            [self swizzleIfPossible:@selector(endUpdates)];
        }
    } else {
        if (self.emptyDataSetView) {
            [self.emptyDataSetView removeFromSuperview];
            [self setEmptyDataSetView:nil];
        }
    }
}

- (UIView *)emptyDataSetView {
    return objc_getAssociatedObject(self, @selector(emptyDataSetView));
}

- (void)setEmptyDataSetView:(UIView *)emptyDataSetView {
    if (emptyDataSetView) {
        CGRect frame = self.frame;
        if ([self.emptyDataSetDataSource respondsToSelector:@selector(verticalOffsetForEmptyDataSet:)]) {
            frame.origin.y = [self.emptyDataSetDataSource verticalOffsetForEmptyDataSet:self];
        }
        if ([self.emptyDataSetDataSource respondsToSelector:@selector(heightForEmptyDataSet:)]) {
            frame.size.height = [self.emptyDataSetDataSource heightForEmptyDataSet:self];
        }
        emptyDataSetView.frame = frame;
    }
    objc_setAssociatedObject(self, @selector(emptyDataSetView), emptyDataSetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)numberOfItems {
    NSInteger items = 0;
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    if ([self isKindOfClass:[UITableView class]]) {
        id <UITableViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UITableView *tableView = (UITableView *)self;
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource tableView:tableView numberOfRowsInSection:i];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        id <UICollectionViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UICollectionView *collectionView = (UICollectionView *)self;
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource collectionView:collectionView numberOfItemsInSection:i];
        }
    }
    return items;
}

- (BOOL)canDisplay {
    if (self.emptyDataSetDataSource && [self.emptyDataSetDataSource conformsToProtocol:@protocol(JXEmptyDataSetDataSource)]) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
    }
    return NO;
}

@end
