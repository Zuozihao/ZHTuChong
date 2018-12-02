//
//  ZHScrollMenu.h
//  ZHTuChong
//
//  Created by 左梓豪 on 2018/12/1.
//  Copyright © 2018 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHScrollMenu : UIView

@property(nonatomic, assign) CGFloat   itemWidth;//每个标题的宽度,默认80
@property(nonatomic, strong) NSArray    *titles;//所有标题
@property(nonatomic, assign) CGFloat    titleHeight;//标题栏高度
@property(nonatomic, assign) NSInteger  fontSize;//标题字体大小
@property(nonatomic, assign) NSInteger  highlightFontSize;//标题字体大小
@property(nonatomic, strong) UIColor    *fontColor;//字体颜色
@property(nonatomic, strong) UIColor    *highlightTitleColor;//选中时的颜色
@property(nonatomic, strong) UIColor    *lineColor;//线的颜色
@property(nonatomic, assign) BOOL       showBottomLine;//是否显示下划线
@property(nonatomic, assign) UIColor    *bottomLineColor;//下划线颜色

@end

NS_ASSUME_NONNULL_END
