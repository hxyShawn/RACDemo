//
//  ViewController.m
//  RACDemo
//
//  Created by choice on 2020/4/11.
//  Copyright © 2020 choice. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "SubjectViewController.h"
#import "LoginViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *data;
@property (nonatomic, strong) NSString *currentText;
@property (nonatomic, strong) RACCommand *command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = @[@"RACSignal与RACSubscriber",@"RACSubject",@"RACSubject替换代理",@"RACTuple",@"RACSequence遍历数组与字典",@"RACMulticastConnection：处理重复发送消息的问题",@"RACCommand：用于处理事件的类",@"combineLatest",@"reduce",@"merge",@"merge2",@"zipwith",@"concat",@"then",@"take",@"takeLast",@"takeUntil",@"skip",@"doNext",@"doComplete",@"switchToLatest",@"retry",@"throttle",@"normal",@"deliverOn",@"subscribeOn",@"deliverOnMainThread",@"filter",@"interval",@"timeout",@"delay",@"login"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     self.data =     @[@"RACSignal与RACSubscriber",@"RACSubject",@"RACSubject替换代理",@"RACTuple",@"RACSequence遍历数组与字典",@"RACMulticastConnection：处理重复发送消息的问题",@"RACCommand：用于处理事件的类",@"merge",@"combineLatest",@"reduce",@"zipwith",@"concat",@"then",@"take",@"takeLast",@"takeUntil",@"skip",@"doNext",@"doComplete",@"switchToLatest",@"retry",@"throttle",@"normal",@"deliverOn",@"subscribeOn",@"deliverOnMainThread"];
     */
    switch (indexPath.row) {
        case 0:
            [self RACSignal];
            break;
        case 1:
            [self RACSubject];
            break;
        case 2:
            [self RACSubjectAsDelegate];
            break;
        case 3:
            //RACTuple
            [self RACTuple];
            break;
        case 4:
            [self RACSequence];
            break;
        case 5:
            [self RACMulticastConnection];
            break;
        case 6:
            //RACCommand
            [self RACCommand];
            break;
        case 7:
            [self combineLatest];
            break;
        case 8:
            [self reduce];
            break;
        case 9:
            [self merge];
            break;
        case 10:
            [self merge2];
            
            break;
        case 11:
            [self zipWith];
            
            break;
        case 12:
            [self concat];
            break;
        case 13:
            [self then];
            break;
        case 14:
            [self take];
            break;
        case 15:
            [self takeLast];
            break;
        case 16:
            [self takeUntil];
            break;
        case 17:
            [self skip];
            break;
        case 18:
            [self doNext];
            break;
        case 19:
            [self doComplete];
            break;
        case 20:
            [self switchToLatest];
            break;
        case 21:
            [self retry];
            break;
        case 22:
            [self throttle];
            break;
        case 23:
            [self normal];
            break;
        case 24:
            [self deliverON];
            break;
        case 25:
            [self subscribeOn];
            break;
            case 26:
            [self deliverOnMainThread];
            break;
        case 27:
            [self filter];
            break;
        case 28:
            [self interval];
            break;
            case 29:
            [self timeout];
            break;
            case 30:
            [self delay];
            break;
            case 31:
            [self login];
            break;
        default:
            break;
    }
}

- (void)RACSignal
{
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@1];
        [subscriber sendError:[NSError errorWithDomain:@"com.error" code:0 userInfo:@{@"message":@"content"}]];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        //如果sendNext，这里可以return nil;
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
        }];
        return disposable;
    }];

    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"next:%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    } completed:^{
        NSLog(@"complete");
    }];
}

- (void)RACSubject
{
    //1.创建信号
    //创建RACSubject不需要block参数
    RACSubject *subject = [RACSubject subject];
    
    //2.订阅信号
    //这里信号被订阅两次，那么订阅者也创建了两次，保存在RACSubject的subscribers属性数组中。
    //那么每当信号有新值发出的时候，每个订阅者都会执行。
    [subject subscribeNext:^(id x) {
        //block在信号发出新值时调用
        NSLog(@"第一个订阅者:%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者:%@",x);
    }];
    
    //3.发送信号
    [subject sendNext:@"6"];
}

- (void)RACSubjectAsDelegate
{
    SubjectViewController *vc = [[SubjectViewController alloc]init];
    vc.subject = [RACSubject subject];
    [vc.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)RACReplaySubject
{
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    
    
    // 3.先订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接受到的数据%@", x);
    }];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    //6
    //6
    
    //遍历字典
    NSDictionary *myInfoDic = @{@"name":@"zs",@"nickname":@"FengZi",@"age":@"18"};\
    [myInfoDic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        //解元组，注意一一对应
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"myInfoDic:%@-%@",key,value);
    }];
    
    
}

- (void)RACTuple
{
    RACTuple *tuple = RACTuplePack(@(404),@"废了");
    RACTupleUnpack(NSNumber *code, NSString *message) = tuple;
    NSLog(@"code = %@, message = %@",code,message);
}

- (void)RACSequence
{
    // 1.遍历数组
//    NSArray *numbers = @[@1,@2,@3,@4];
//    // 这里其实是三步
//    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
//    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
//    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
//    [numbers.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
    // 2.遍历字典,遍历出来的键值对 都会包装成 RACTuple(元组对象) @[key, value]
    NSDictionary *dic = @{@"name": @"yahaha", @"age": @18};
    //这里的RACTuple *x是自己改的,sequence返回的必定是rRACTuple
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解元组包，会把元组的值，按顺序给参数里的变量赋值
        // 写法相当与
        // NSString *key = x[0];
        // NSString *value = x[1];
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key:%@, value:%@", key, value);
    }];
    
}

- (void)RACMulticastConnection
{
    /**
     RACMulticastConnection用于解决一个信号被多次订阅后，创建信号中的block被重复调用的问题，所以在实际开发中，使用RACMulticastConnection可以解决网络重复请求的问题。
     */
    //    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //       NSLog(@"block内容");
    //       [subscriber sendNext:@"发送信号A"];
    //       return nil;
    //    }];
    //
    //    [signalA subscribeNext:^(id  _Nullable x) {
    //       NSLog(@"第一次订阅：%@",x);
    //    }];
    //
    //     [signalA subscribeNext:^(id  _Nullable x) {
    //       NSLog(@"第二次订阅：%@",x);
    //    }];
    
    //1.创建信号
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"block内容");
        [subscriber sendNext:@""];
        return nil;
    }];
    
    //2.连接信号：publish或者muticast方法
    //连接后的信号使用订阅方法时，并不能激活信号，而是将其订阅者保存到数组中。
    //在连接对象执行connect方法时，信号中的订阅者会统一调用sendNext方法。
    RACMulticastConnection *signalBconnect = [signalB publish];
    
    //3.订阅信号
    //使用signalBconnect而不再是signalB
    [signalBconnect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一次订阅：%@",x);
    }];
    [signalBconnect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二次订阅：%@",x);
    }];
    
    //4.连接后激活信号
    [signalBconnect connect];
}

- (void)RACCommand
{
    //1.创建RACCommand：initWithSignalBlock
    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //我们常在这里创建一个网络请求的信号，也就是封装一个请求数据的操作。
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"网络请求的信号"];
                //数据传递完成，必须调用sendComplleted.,否则永远处于执行中。
                [subscriber sendCompleted];
            });
            return nil;
        }];
        return signal;
    }];
    
    //2.订阅RACCommand中的信号，要等到RACCommand执行后，才能收到消息
    [self.command.executionSignals subscribeNext:^(id  _Nullable x) {
        //这里是一个信号中信号
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"收到信号：%@",x);
        }];
    }];
        
    //改进订阅方法：switchToLatest可以直接获取信号中信号
    [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"改进-收到信号：%@",x);
    }];
    
    
    //3.监听RACCommand命令是否执行完毕的信号
    //默认会监测一次，所以可以使用skip表示跳过第一次信号。
    //这里可以用于App网络请求时，控制加载提示视图的隐藏或者显示
    [[self.command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if([x boolValue] == YES){
            NSLog(@"RACCommand命令正在执行...");
        }else{
            NSLog(@"RACCommand命令不在执行中！！！");
        }
    }];
    
    //4.执行RACComand
    //方法：- (RACSignal *)execute:(id)input
    [self.command execute:@""];
}

- (void)combineLatest
{
    //将combineLatest:后面的数组中的信合打包成为一个新的信号。只有当两个信号都成功发送过信号的时候打包后的信号才能正常执行订阅后的代码块。
    RACSubject *signalOne = [RACSubject subject];
    [signalOne subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号one：%@",x);
    }];
    
    RACSubject *signalTwo = [RACSubject subject];
    [signalTwo subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号Two：%@",x);
    }];
    
    [[RACSignal combineLatest:@[signalOne,signalTwo]] subscribeNext:^(RACTuple * _Nullable x) {
        //解元组：合并信号得到的是一个元组,里面存放的是两个信号发送的消息
        RACTupleUnpack(NSString *str1,NSString *str2) = x;
        NSLog(@"combineLatest:str1-%@,str2-%@",str1,str2);
    }];
    
    [signalOne sendNext:@"1"];
    [signalTwo sendNext:@"2"];
}

- (void)reduce
{
    RACSignal *signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalOne"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalTwo"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[RACSignal combineLatest:@[signalOne,signalTwo] reduce:^id _Nullable(NSString *strOne,NSString *strTwo){
        return [NSString stringWithFormat:@"%@-%@",strOne,strTwo];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)merge
{
    //此代码可以将merge：后数组中的信号合并为一个信号。只要有任意一个信号完成信息的发送。那么合并后的信号就可以正常的接收到信号。
    RACSubject *signalOne = [RACSubject subject];
    [signalOne subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号one：%@",x);
    }];

    RACSubject *signalTwo = [RACSubject subject];
    [signalTwo subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号Two：%@",x);
    }];

    RACSignal *mergeSignals = [signalOne merge:signalTwo];
    //当合并后的信号被订阅时，就会订阅里面所有的信号
    [mergeSignals subscribeNext:^(id x) {
        NSLog(@"mergeSignals：%@",x);
    }];

    //只调用其中一个信号,就会触发merge合并的信号
    [signalOne sendNext:@"测试信号1"];
}

- (void)merge2
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal1"];
        return nil;
    }];

    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal2"];
        return nil;
    }];

    RACSignal *mergeSignals = [signal1 merge:signal2];
    [mergeSignals subscribeNext:^(id x) {
        NSLog(@"mergeSignals：%@",x);
    }];
}

- (void)zipWith {
    RACSubject *signalOne = [RACSubject subject];
    [signalOne subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号one：%@",x);
    }];
    
    RACSubject *signalTwo = [RACSubject subject];
    [signalTwo subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号Two：%@",x);
    }];
    
    //zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。
    RACSignal *zipSignal = [signalOne zipWith:signalTwo];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        //解元组：合并信号得到的是一个元组,里面存放的是两个信号发送的消息
        RACTupleUnpack(NSString *str1,NSString *str2) = x;
        NSLog(@"zipSignal：str1-%@,str2-%@",str1,str2);
    }];
    
    [signalOne sendNext:@"测试zipSignalMsgOne"];
    [signalTwo sendNext:@"测试zipSignalMsgTwo"];
    
}

- (void)concat
{
    RACSignal *signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalOne"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalTwo"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalThree = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalThree"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //拼接了三个信号，订阅之后，三个信号依次激活
    RACSignal *concatSignal = [[signalOne concat:signalThree] concat:signalTwo];
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"信号被激活:%@",x);
    }];
}

- (void)then
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"信号1");
        [subscriber sendNext:@"发送信号1"];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"信号2");
            [subscriber sendNext:@"发送信号2"];
            [subscriber sendCompleted];
            return nil;
        }];
    }]then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"信号3");
            [subscriber sendNext:@"发送信号3"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        //只能接收到最后一个信号的值
        NSLog(@"订阅信号：%@",x);
    }];
}

- (void)take
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送消息1"];
        [subscriber sendNext:@"发送消息2"];
        [subscriber sendNext:@"发送消息3"];
        [subscriber sendNext:@"发送消息4"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signal take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号:%@",x);
    }];
}

- (void)takeLast
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送消息1"];
        [subscriber sendNext:@"发送消息2"];
        [subscriber sendNext:@"发送消息3"];
        [subscriber sendNext:@"发送消息4"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signal takeLast:3]subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号：%@",x);
    }];
}

- (void)takeUntil
{
    RACSubject *signalA = [RACSubject subject];
    
    [signalA subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号A：%@",x);
    }];
    
    //[RACObserve(self, currentText)发送消息知道signalA信号结束
    [[RACObserve(self, currentText) takeUntil:signalA] subscribeNext:^(id  _Nullable x) {
        NSLog(@"使用%@更新currentText的值",x);
    }];
    
    self.currentText = @"0";
    self.currentText = @"1";
    self.currentText = @"2";
    [signalA sendCompleted];//信号A结束之后，监听testLabel文本的信号也不在发送消息了
    self.currentText = @"3";
    NSLog(@"代码执行到此行。。。。");
}

- (void)skip
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"第一次发送消息"];
        [subscriber sendNext:@"第二次发送消息"];
        [subscriber sendNext:@"第三次发送消息"];
        [subscriber sendNext:@"第四次发送消息"];
        return nil;
    }];
    
    [[signal skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)doNext
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送信号：1"];
        //        [subscriber sendCompleted];
        return nil;
    }];
    
    [[[signal doNext:^(id  _Nullable x) {
        NSLog(@"执行doNext");
    }] doCompleted:^{
        NSLog(@"执行doComplete");
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号：%@",x);
    }];
}

- (void)doComplete
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //        [subscriber sendNext:@"发送信号：1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[[signal doNext:^(id  _Nullable x) {
        NSLog(@"执行doNext");
    }] doCompleted:^{
        NSLog(@"执行doComplete");
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号：%@",x);
    }];
}

- (void)switchToLatest
{
    //创建一个普通信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送信号：1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建一个发送信号的信号，信号的信号
    RACSignal *signalOfSignals = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:signal];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //订阅最近发出的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        //控制台打印：switchToLatest打印：发送信号：1
        NSLog(@"switchToLatest打印：%@",x);
    }];
}

- (void)retry
{
    static int signalANum = 0;
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (signalANum == 5) {
            [subscriber sendNext:@"signalANum is 5"];
            [subscriber sendCompleted];
        }else{
            NSLog(@"signalANum错误！！!");
            [subscriber sendError:nil];
        }
        signalANum++;
        return nil;
    }];
    
    [[signalA retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"StringA-Next：%@",x);
    } error:^(NSError * _Nullable error) {
        //特别注意：这里并没有打印
        NSLog(@"signalA-Errror");
    }];
}

- (void)throttle
{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送消息11"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"发送消息21"];
            [subscriber sendNext:@"发送消息22"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"发送消息31"];
            [subscriber sendNext:@"发送消息32"];
            [subscriber sendNext:@"发送消息33"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"发送消息41"];
            [subscriber sendNext:@"发送消息42"];
            [subscriber sendNext:@"发送消息43"];
            [subscriber sendNext:@"发送消息44"];
        });
        return nil;
    }] throttle:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"Next:%@",x);
    }];
}

- (void)normal
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试1-endNext"];
            NSLog(@"测试1-当前线程：%@",[NSThread currentThread]);
            return nil;
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试1-Next:%@",x);
            NSLog(@"测试1-Next当前线程：%@",[NSThread currentThread]);
        }];
    }) ;
}

- (void)deliverON
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试2-endNext"];
            NSLog(@"测试2-当前线程：%@",[NSThread currentThread]);
            return nil;
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试2-Next:%@",x);
            NSLog(@"测试2-Next当前线程：%@",[NSThread currentThread]);
        }];
    }) ;
}

- (void)subscribeOn
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试3-sendNext"];
            NSLog(@"测试3-sendNext当前线程：%@",[NSThread currentThread]);
            return nil;
        }] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试3-Next:%@",x);
            NSLog(@"测试3-Next当前线程：%@",[NSThread currentThread]);
        }];
    }) ;
}

- (void)deliverOnMainThread
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试4-sendNext"];
            NSLog(@"测试4-sendNext当前线程：%@",[NSThread currentThread]);
            return nil;
        }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试4-Next:%@",x);
            NSLog(@"测试4-Next当前线程：%@",[NSThread currentThread]);
        }];
    }) ;
}

- (void)filter
{
    NSArray *array = @[@1,@2,@3,@3,@4];
    NSArray *filter = [[array.rac_sequence filter:^BOOL(id  _Nullable value) {
        return [value  isEqual: @1];
    }] array];
    NSLog(@"%@",filter);
}

- (void)interval
{
    RACSignal *intervalSignal = [RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]];
    [[intervalSignal take:5]subscribeNext:^(id  _Nullable x) {
        //订阅定时器信号，启动定时器，只打印5次
        NSLog(@"interval,定时器打印");
    }];
    //一直打印
//    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
//        NSLog(@"interval");
//    }];
}

- (void)timeout
{
    RACSignal *timeOutSignal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"timeOutSignal发送信号"];
//        [subscriber sendCompleted];
        return nil;
    }] timeout:5 onScheduler:[RACScheduler currentScheduler]];
       
    [timeOutSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"timeOutSignal:%@",x);
     } error:^(NSError * _Nullable error) {
        //5秒后执行打印：
        //timeOutSignal:出现Error-Error Domain=RACSignalErrorDomain Code=1 "(null)"
        NSLog(@"timeOutSignal:出现Error-%@",error);
    } completed:^{
        NSLog(@"timeOutSignal:complete");
    }];
    

}

- (void)delay
{
    RACSignal *delaySignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"delaySignal-sendNext"];
        return nil;
    }];
       
    //10秒后才收到消息，执行打印
    [[delaySignal delay:10] subscribeNext:^(id  _Nullable x) {
        NSLog(@"delaySignal:%@",x);
    }];
}

- (void)login
{
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    }
    return _tableView;
}

@end
