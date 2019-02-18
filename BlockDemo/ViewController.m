//
//  ViewController.m
//  BlockDemo
//
//  Created by RP. wang on 2019/1/19.
//  Copyright © 2019 西安乐推网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "blockView.h"


typedef void(^Block)(void);

@interface ViewController ()

@property (copy, nonatomic) Block testBlock;
//
@property (strong, nonatomic) NSString *testName;
@property (weak, nonatomic) UIView *listView;

@property (strong, nonatomic) blockView *blockTetsView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testName = @"macho";
    
    
    
    //------------------------------
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //!!!: - 1、Block的本质
    int a = 1;
    void(^block)(void) = ^{
        NSLog(@"a=============%d",a);
    };
    block();
    NSLog(@"Block===============%@",block);
    NSLog(@"test Block===========%@",^{
        NSLog(@"test Block==================%d",a);
    });
    //Block的分类
    //__NSGlobalBlock__  全局Block,存储于程序数据区
    //__NSMallocBlock__ 堆Block
    //__NSStackBlock__ 栈Block
    
    // !!!: - 2、Block循环引用
    //造成循环引用的原因
//    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 100, 100)];
//    testView.backgroundColor = [UIColor redColor];
//    self.listView = testView;
//    [self.view addSubview:testView];
    
    self.testName = @"test Name";
    
    // __weak
    __weak typeof (self) weakSelf = self;
    self.testBlock = ^{
        
        NSLog(@"testtestName11111================%@",weakSelf.testName);
        
        __strong typeof (self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"testtestName22222================%@",strongSelf.testName);
        });
    };
    self.testBlock();
    
    // __block
    __block ViewController *blockSelf = self;
    self.testBlock = ^{
        NSLog(@"blockSelf====================%@",blockSelf.testName);
    };
    self.testBlock();
    
    // !!!: - 3、Block原理相关
    // !!!: - 4、Block实际应用
    
    
    
    
    //----------------------------
    __block int testCount = 10;
    void (^testBlock)(void) = ^{
        testCount = testCount + 1;
        NSLog(@"======================%d",testCount);
    };
    testBlock();
    
    
    //================================
    // ^ 返回值类型  参数列表  表达式
    NSString *(^blocks)(NSString *) = ^(NSString *testChar){

        NSLog(@"testChar--------------%@",testChar);
        return testChar;
    };
    
 
    //================================
    ViewController *(^blockview)(NSString *) = ^(NSString *testCharStr){
        
        NSLog(@"testCharStr-----------------%@",testCharStr);
        return weakSelf;
    };
    //================================
    blocks(@"--------------test");
    
    blockview(@"blockview");
    
    
    //================================
    id listArray = [NSMutableArray array];
    __block int b = 0;
    void(^listBlock)(void) = ^{
        [listArray addObject:@"1"];
        b = 1;
        NSLog(@"listBlock------------%@,%d",listArray,a);
    };
    listBlock();
    
    //================================
    // 链式编程
    self.blockTetsView.withColor([UIColor redColor]).width(100).height(100);
}



-(void)dealloc{
    NSLog(@"--------------dealloc 来了");
}


-(blockView *)blockTetsView{
    if(_blockTetsView == nil){
        _blockTetsView = [[blockView alloc]init];
        [self.view addSubview:_blockTetsView];
    }
    return _blockTetsView;
}


@end
