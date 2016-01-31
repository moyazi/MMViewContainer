//
//  MMViewContainer.h
//  Demo
//
//  Created by moyazi on 16/1/29.
//  Copyright © 2016年 Moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMViewContainerDelegate <NSObject>
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller;
@end

@interface MMViewContainer : UIViewController
@property (nonatomic, weak) id <MMViewContainerDelegate> delegate;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong, readonly) NSMutableArray *images;
@property (nonatomic, strong, readonly) NSMutableArray *selectedImages;
@property (nonatomic, strong, readonly) NSMutableArray *childControllers;
@property (nonatomic, strong) UIImage *menuItemImage;
@property (nonatomic, strong) UIImage *menuItemSelectedImage;
@property (nonatomic, strong) UIImage *menuBackgroundImage;
@property (nonatomic, strong) UIColor *menuBackgroundColor;

/**
 *  当为文字menu时的一些参数
 */
@property (nonatomic, strong, readonly) NSMutableArray *titles;//文字数组
@property (nonatomic, strong) UIFont  *menuItemFont;//文字字体
@property (nonatomic, strong) UIColor *menuItemTitleColor;//文字颜色
@property (nonatomic, strong) UIColor *menuItemSelectedTitleColor;//文字选中颜色
@property (nonatomic, strong) UIColor *menuBackGroudColor;//文字背景颜色
@property (nonatomic, strong) UIColor *menuIndicatorColor;//文字指示器颜色

/**
 *  菜单显示方法 =1 图片(默认) =2 是文字
 */
@property(nonatomic,assign) NSInteger showItemMode;

/**
 *  滚动区域离底部的高度
 */
@property(nonatomic,assign) NSInteger contentScrollViewMarginBottomHeight;

/**
 *  是否允许其滚动 =1 允许,其他不允许
 */
@property(nonatomic,assign)  NSInteger enableScrolled;

@property(nonatomic,assign) NSInteger scrollMenuViewSelectedIndex;

/**
 *  加载图片menu方法
 *
 *  @param controllers          控制器
 *  @param images               图片
 *  @param selectedImages       被选中的图片
 *  @param topBarHeight         topbar高度
 *  @param parentViewController 父类控制器
 *
 *  @return 当前类的实例化
 */
- (id)initWithControllers:(NSArray *)controllers
                   images:(NSArray *)images
           selectedImages:(NSArray *)selectedImages
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;


/**
 *  加载文字(非图片方法)
 *
 *  @param controllers          控制器
 *  @param topBarHeight         topbar高度
 *  @param parentViewController 父类控制器
 *
 *  @return 当前类的实例化
 */
-(id)initWithControllers:(NSArray *)controllers topBarHeight:(CGFloat)topBarHeight parentViewController:(UIViewController *)parentViewController;

@end
