//
//  blockView.h
//  BlockDemo
//
//  Created by rp.wang on 2019/2/18.
//  Copyright © 2019 西安乐推网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface blockView : UIView


///
-(blockView *(^ _Nonnull)(float width))width;
///
-(blockView *(^ _Nonnull)(float height))height;
///
-(blockView *(^ _Nonnull)(UIColor *__strong))withColor;

@end

NS_ASSUME_NONNULL_END
