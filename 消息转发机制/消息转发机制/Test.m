//
//  Test1.m
//  消息转发机制
//
//  Created by dayan on 2020/5/21.
//  Copyright © 2020 dayan. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>

@implementation Test

//被动态添加的实例方法实现
void instanceMethod(id self,SEL _cmd){
    NSLog(@"收到消息后回执行此处的方法实现");
}

-(id)forwardingTargetForSelector:(SEL)aSelector{
    //返回转发的对象实例
    if(aSelector == @selector(instanceMethod)){
        return [[Test alloc] init];
    }
    return nil;
}

//动态补加方法实现
//+(BOOL)resolveInstanceMethod:(SEL)sel{
////    //如果说方法没有实现
////    //到这里没有补救 返回Yes的话 会对父类进行查找方法
//////    if(sel == @selector(instanceMethod)){
//////        class_addMethod(self, sel, (IMP)instanceMethod, "v@:");
//       return YES;
//////    }
////    return [super resolveInstanceMethod:sel];
//}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    //为指定的方法手动生成签名
    NSString *selName = NSStringFromSelector(aSelector);
    if([selName isEqualToString:@"instaceMethod"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    //如果另一个对象可以响应该消息，那么将消息转发给它
    SEL sel = [anInvocation selector];
    TestF *test2 = [[TestF alloc] init];
    if([TestF respondsToSelector:sel]){
        [anInvocation invokeWithTarget:test2];
    }
}


@end
