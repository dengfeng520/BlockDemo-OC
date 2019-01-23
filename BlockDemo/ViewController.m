//
//  ViewController.m
//  BlockDemo
//
//  Created by RP. wang on 2019/1/19.
//  Copyright © 2019 西安乐推网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

typedef void(^Block)(void);

@interface ViewController ()

@property (copy, nonatomic) Block block;
//
@property (copy, nonatomic) NSString *name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.name = @"macho";
    //------------------------------
//    __weak typeof (self) weakSelf = self;
//    self.block = ^{
//        __strong typeof (self) strongSelf = weakSelf;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            NSLog(@"--------------%@",strongSelf.name);
//        });
//        
//    };
//    self.block();
    

    self.selectBlock(@"Test").width(2.0000);
}

-(ViewController *)whereLog{
    NSLog(@"-----------------%s",__func__);
    return self;
}

-(ViewController *(^)(NSString *))selectBlock{
    
    __weak typeof (self) weakSelf = self;
    ViewController *(^block)(NSString *) = ^(NSString *word){
        
        NSLog(@"-----------------%@",word);

        return weakSelf;
    };
    
    return block;
}

-(ViewController *(^)(float))width{
    
    __weak typeof (self) weakSelf = self;
    ViewController *(^VCBlock)(float) = ^(float widthData){
      
        NSLog(@"--------------%f",widthData);
        
        return weakSelf;
    };
    return VCBlock;
}

-(void)dealloc{
    NSLog(@"--------------dealloc 来了");
}


@end
