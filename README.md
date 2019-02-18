###1、Block的本质

#####(1)、Block的分类
 定义一个`Block`,一般的代码如下:
 
 ```
 void(^block)(void) = ^{
     
  };
  block();
 ```
 此时可以打印`Block`可以查看`Block`相关信息,
 
 ```
 NSLog(@"Block===============%@",block);
 ```
 
 
 ```
 Block===============<__NSMallocBlock__: 0x6000013be940>
 ```
此时可以看出`Block`的类型为`__NSMallocBlock__`,为全局`Block`,存储于程序数据区，在程序的任何地方都可以调用。此时我在代码上做作一个小修改,在`Block`内部做一些操作。

```
int a = 1;
void(^block)(void) = ^{
    NSLog(@"a=============%d",a);
};
block();
NSLog(@"Block===============%@",block);
``` 
```
Block===============<__NSMallocBlock__: 0x600000a20f60>
```
现在发现打印的`Block`类型居然变成了`__NSMallocBlock__`类型，究竟发生了什么造成的呢？

**`a`原本存储在栈区，当`a`被操作时会自动`copy`到相应的堆区，如果`Block`内部要访问`a`，要处于相同的内存区才能操作，所以此时`Block`会自动的从栈区变为堆区。**

```
NSLog(@"test Block===========%@",^{
   NSLog(@"test Block==================%d",a);
});
 
test Block===========<__NSStackBlock__: 0x7ffee8ea13c0>
```
此时`Block`直接访问栈区变量，一般而言，在开发中如果只是一个打印操作，没必要使用`__NSStackBlock__`。


**通过上面的操作，可得出结论`Block`分为三种类型:**
**1、`__NSMallocBlock__`全局Block,存储于程序数据区**
**2、`__NSMallocBlock__` 堆Block**
**3、`__NSStackBlock__` 栈Block**


###2、Block循环引用

**（1）、weak引起的循环引用**

```
///
@property (weak, nonatomic) UIView *listView;
```
```
_listView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 100, 100)];
[self.view addSubview:_listView];
_listView.backgroundColor = [UIColor redColor];
```
`Xcode`已经检查出问题了:
```Assigning retained object to weak variable; object will be released after assignment```

修改代码：

```
UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 100, 100)];
testView.backgroundColor = [UIColor redColor];
self.listView = testView;
[self.view addSubview:testView];
```


**（2）、__weak引起的循环引用**

**（3）、__block引起的循环引用**
    
###3、Block原理相关

###4、Block实际应用
**（1）、链式编程**


```
///
-(blockView *(^ _Nonnull)(float width))width;
///
-(blockView *(^ _Nonnull)(float height))height;
///
-(blockView *(^ _Nonnull)(UIColor *__strong))withColor;

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
```

```
@property (strong, nonatomic) blockView *blockTetsView;

```

```
-(blockView *)blockTetsView{
    if(_blockTetsView == nil){
        _blockTetsView = [[blockView alloc]init];
        [self.view addSubview:_blockTetsView];
    }
    return _blockTetsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     //----------------------------
    self.blockTetsView.withColor([UIColor redColor]).width(100).height(100);
}
```



运行代码，可以看到在屏幕显示了一个`View`.

![demo](https://github.com/dengfeng520/BlockDemo-OC/blob/master/BlockDemo1.png?raw=true)