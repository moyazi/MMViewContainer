//
//  MMScrollMenu.h
//  Demo
//
//  Created by moyazi on 16/1/29.
//  Copyright © 2016年 Moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMScrollMenuDelegate <NSObject>
- (void)scrollMenuViewSelectedIndex:(NSInteger)index;
@end

@interface MMScrollMenu : UIView
@property (nonatomic, weak) id <MMScrollMenuDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

//menu为图片时相关属性
@property (nonatomic, strong) NSArray *itemImageArray;
@property (nonatomic, strong) NSArray *itemSelectedImageArray;
@property (nonatomic, strong) NSArray *itemViewArray;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) UIImage *itemSelectedImage;

//menu为文字时相关属性
@property (nonatomic, strong) NSArray *itemTitleArray;
@property (nonatomic, strong) UIColor *viewbackgroudColor;
@property (nonatomic, strong) UIFont *itemfont;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *itemSelectedTitleColor;
@property (nonatomic, strong) UIColor *itemIndicatorColor;


- (void)setShadowView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

/**
 * 设置 菜单栏Title背景
 * menu为图片时调用
 */
- (void)setItemImage:(UIImage *)itemImage
    seletedItemImage:(UIImage *)selectedItemImage
        currentIndex:(NSInteger)currentIndex;

/**
 * 设置菜单栏Title颜色
 * menu为文字时调用
 */
- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;

@end