//
// Created by SteyDong on 2021/1/21.
//

#import "JPTimerUtils.h"

@implementation JPTimerUtils


//存储所有的 timer 一个标识一个timer
static NSMutableDictionary *_timersDict;
//信号量 用来加锁
dispatch_semaphore_t _jpTimeSemaphore;

+ (void)initialize {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _timersDict = [NSMutableDictionary dictionary];
        _jpTimeSemaphore = dispatch_semaphore_create(1);
    });

}

+ (NSString *)jp_timerBeginWithStartTime:(NSTimeInterval)startTime intervalTime:(NSTimeInterval)intervalTime repeats:(BOOL)repeats async:(BOOL)async task:(void (^)(void))task {

    if (startTime < 0 || (repeats && intervalTime <= 0) || !task) {
        NSLog(@"%@: startTime < 0 || (repeats && intervalTime <= 0) || !task",[[NSString stringWithUTF8String:__FILE__] lastPathComponent]);
        return nil;
    }

    //队列
    dispatch_queue_t queue_t = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    //创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue_t);
    //设置timer的开始时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, startTime * NSEC_PER_SEC),  intervalTime * NSEC_PER_SEC, 0);

    /****************************加锁******************************/
    dispatch_semaphore_wait(_jpTimeSemaphore, DISPATCH_TIME_FOREVER);

    //设置定时器的唯一标识
    NSString *timerName = [NSString stringWithFormat:@"jp_timerName_%zd_%f_%d",_timersDict.count,[JPTimerUtils jp_timerCurrentTimeStamp], arc4random_uniform(100000000)];
    //存储到字典中
    _timersDict[timerName] = timer;

    /****************************解锁******************************/
    dispatch_semaphore_signal(_jpTimeSemaphore);

    //定时器的回调
    dispatch_source_set_event_handler(timer, ^{
        //回调方法
        task();

        //判断是否是一次性任务
        if (!repeats) {
            [self jp_cancelTask:timerName];
        }
    });
    dispatch_resume(timer);

    return timerName;
}

+ (NSString *)jp_timerBeginWithStartTime:(NSTimeInterval)startTime intervalTime:(NSTimeInterval)intervalTime repeats:(BOOL)repeats async:(BOOL)async target:(id)target selector:(SEL)selector {

    if (!target || !selector) {
        NSLog(@"%@: !target || !selector",[[NSString stringWithUTF8String:__FILE__] lastPathComponent]);
        return nil;
    }

    return [self jp_timerBeginWithStartTime:startTime intervalTime:intervalTime repeats:repeats async:async task:^{

        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
}

+ (void)jp_cancelTask:(NSString *)name {

    if (!name || !name.length) {
        return;
    }

    if (![self jp_checkTimerRun:name]) {
        return;
    }

    /****************************加锁******************************/
    dispatch_semaphore_wait(_jpTimeSemaphore, DISPATCH_TIME_FOREVER);

    //取出timer
    dispatch_source_t timer = _timersDict[name];
    //取消定时器
    if (timer) {
        dispatch_cancel(timer);
        //从字典中移除
        [_timersDict removeObjectForKey:name];
    }

    /****************************解锁******************************/
    dispatch_semaphore_signal(_jpTimeSemaphore);
}

+ (BOOL)jp_checkTimerRun:(NSString *)name {

    if (!name || !name.length) {

        return NO;
    }

    BOOL run = [_timersDict.allKeys containsObject:name];

    return run;
}

+ (NSTimeInterval)jp_timerCurrentTimeStamp {

    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval * 1000;
}

@end
