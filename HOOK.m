//
//  HOOK.m
//  SDCycleScrollView
//
//  Created by 孙继刚 on 2018/5/28.
//  Copyright © 2018年 madordie. All rights reserved.
//

#ifndef KTJChangeIMP
#define KTJChangeIMP(JOriginalSEL, JSwizzledSEL)                                                                                                        \
    {                                                                                                                                                   \
        Class class = [self class];                                                                                                                     \
        SEL originalSelector = (JOriginalSEL);                                                                                                          \
        SEL swizzledSelector = (JSwizzledSEL);                                                                                                          \
        Method originalMethod = class_getInstanceMethod(class, originalSelector);                                                                       \
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);                                                                       \
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)); \
        if (didAddMethod) {                                                                                                                             \
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));             \
        } else {                                                                                                                                        \
            method_exchangeImplementations(originalMethod, swizzledMethod);                                                                             \
        }                                                                                                                                               \
    }
#endif


#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UICollectionViewLayoutAttributes (RIGOU)

@end

static NSInteger rgCount = 0;

@implementation UICollectionViewLayoutAttributes (RIGOU)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KTJChangeIMP(@selector(init), @selector(hook_init));
        KTJChangeIMP(NSSelectorFromString(@"dealloc"), @selector(hook_dealloc));
    });
}
- (instancetype)hook_init
{
    rgCount += 1;
    printf("%ld\n", (long)rgCount);
    return [self hook_init];
}
- (void)hook_dealloc
{
    rgCount -= 1;
    printf("%ld\n", (long)rgCount);
    [self hook_dealloc];
}
@end
