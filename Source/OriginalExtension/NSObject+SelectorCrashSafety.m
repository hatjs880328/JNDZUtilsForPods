//
//  NSObject+SelectorCrashSafety.m
//  OMAPP
//
//  Created by 马耀 on 2017/3/7.
//  Copyright © 2017年 JNDZ. All rights reserved.
//


#import "NSObject+SelectorCrashSafety.h"
#import <objc/runtime.h>

@interface _UnregSelObjectProxy : NSObject
+ (instancetype) sharedInstance;
@end

@implementation _UnregSelObjectProxy
+ (instancetype) sharedInstance{
    
    static _UnregSelObjectProxy *instance=nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[_UnregSelObjectProxy alloc] init];
    });
    return instance;
}

+ (BOOL) resolveInstanceMethod:(SEL)selector {
    
    class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
    return YES;
}

void emptyMethodIMP(){
}

@end


@implementation NSObject (SelectorCrashSafety)

#if (defined(DEBUG) && defined(DRLIGHT_TOGGLE_CLOSED))
#else

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        [self swizzleMSFS];
//        [self swizzleFI];

    });
    
}

#endif

+(void)swizzleMSFS{
    
    SEL originalSelector = @selector(methodSignatureForSelector:);
    SEL swizzledSelector = @selector(DZ_methodSignatureForSelector:);
    
    DZ_SWIZZLE(originalSelector,swizzledSelector)
}

+(void)swizzleFI{
    
    SEL originalSelector = @selector(forwardInvocation:);
    SEL swizzledSelector = @selector(DZ_forwardInvocation:);
    
    DZ_SWIZZLE(originalSelector,swizzledSelector)
}


- (NSMethodSignature *)DZ_methodSignatureForSelector:(SEL)sel{
    
    NSMethodSignature *sig;
    sig = [self DZ_methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    
    // 键盘弹出和隐藏事件 应当返回nil 而不是补获
    NSString *sync = NSStringFromSelector(sel);
    if([sync containsString:@"keyboard"] || [sync containsString:@"Keyboard"]){
    
        return nil;
    }
    
    sig = [[_UnregSelObjectProxy sharedInstance] DZ_methodSignatureForSelector:sel];
    if (sig){
        return sig;
    }
    
    return nil;
}

- (void)DZ_forwardInvocation:(NSInvocation *)anInvocation{
    
    NSLog(@"******* 请注意该调用无法识别,可能会导致闪退 %@ ", self);
   [anInvocation invokeWithTarget:[_UnregSelObjectProxy sharedInstance] ];
}



@end
