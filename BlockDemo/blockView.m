//
//  blockView.m
//  BlockDemo
//
//  Created by rp.wang on 2019/2/18.
//  Copyright © 2019 西安乐推网络科技有限公司. All rights reserved.
//

#import "blockView.h"

@implementation blockView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

// MARK: - ================================= set width
-(blockView *(^ _Nonnull)(float width))width{
    __weak typeof (self) weakSelf = self;
    blockView *(^block)(float widthNumber) = ^(float logWidth) {
        
        [weakSelf setFrame:CGRectMake(weakSelf.superview.frame.size.width / 2 - logWidth / 2, weakSelf.frame.origin.y,logWidth, weakSelf.superview.frame.size.height)];
        
        NSLog(@"=======------------%.2f",logWidth);
        return self;
    };
    return block;
};

// MARK: - ================================= set height
-(blockView *(^ _Nonnull)(float height))height{
    __weak typeof (self) weakSelf = self;
    
    blockView *(^block)(float heightNumber) = ^(float logHeight) {
        
        [weakSelf setFrame:CGRectMake(weakSelf.frame.origin.x, weakSelf.superview.frame.size.height / 2 - (logHeight / 2),weakSelf.frame.size.width, logHeight)];
        
        NSLog(@"=======------------%.2f",logHeight);
        return weakSelf;
    };
    return block;
};

// MARK: - ================================= set color
-(blockView *(^ _Nonnull)(UIColor *__strong))withColor{
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *thisColor){
        weakSelf.backgroundColor = thisColor;
        
        NSLog(@"=======================withColor");
        return weakSelf;
    };
}


@end
