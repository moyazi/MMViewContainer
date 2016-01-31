//
//  MMScrollMenu.m
//  Demo
//
//  Created by moyazi on 16/1/29.
//  Copyright © 2016年 Moyazi. All rights reserved.
//

#import "MMScrollMenu.h"

//菜单栏间距、高度
static const CGFloat MMScrollMenuViewWidth  = 65;
static const CGFloat MMScrollMenuViewMargin = 3;
static const CGFloat MMIndicatorHeight = 1.5;
static const CGFloat MMIndicatorMargin = 8;

@interface MMScrollMenu ()
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation MMScrollMenu
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // default
        _viewbackgroudColor = [UIColor whiteColor];
        _itemfont = [UIFont systemFontOfSize:16];
        _itemTitleColor = [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1.0];
        _itemSelectedTitleColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
        _itemIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
        
        self.backgroundColor = _viewbackgroudColor;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

#pragma mark -- Setter
-(void)setItemImageArray:(NSArray *)itemImageArray{
    if (_itemImageArray!= itemImageArray) {
        _itemImageArray = itemImageArray;
        NSMutableArray *views = [NSMutableArray array];
        for (int i = 0; i < itemImageArray.count; i++) {
            CGRect frame = CGRectMake(0, 0, MMScrollMenuViewWidth, CGRectGetHeight(self.frame));
            UIImageView *itemView = [[UIImageView alloc] initWithFrame:frame];
            [self.scrollView addSubview:itemView];
            itemView.tag = i;
            itemView.image = i==0 ?[UIImage imageNamed:_itemSelectedImageArray[i]]:[UIImage imageNamed:itemImageArray[i]];
            itemView.userInteractionEnabled = YES;
            [views addObject:itemView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
            [itemView addGestureRecognizer:tapGesture];
        }
        self.itemViewArray = [NSArray arrayWithArray:views];
    }
}

- (void)setViewbackgroudColor:(UIColor *)viewbackgroudColor{
    if (!viewbackgroudColor) { return; }
    _viewbackgroudColor = viewbackgroudColor;
    self.backgroundColor = viewbackgroudColor;
}

- (void)setItemfont:(UIFont *)itemfont{
    if (!itemfont) { return; }
    _itemfont = itemfont;
    for (UILabel *label in _itemTitleArray) {
        label.font = itemfont;
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor{
    if (!itemTitleColor) { return; }
    _itemTitleColor = itemTitleColor;
    for (UILabel *label in _itemTitleArray) {
        label.textColor = itemTitleColor;
    }
}

- (void)setItemIndicatorColor:(UIColor *)itemIndicatorColor{
    if (!itemIndicatorColor) { return; }
    _itemIndicatorColor = itemIndicatorColor;
    _indicatorView.backgroundColor = itemIndicatorColor;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray{
    if (_itemTitleArray != itemTitleArray) {
        _itemTitleArray = itemTitleArray;
        NSMutableArray *views = [NSMutableArray array];
        
        for (int i = 0; i < itemTitleArray.count; i++) {
            CGRect frame = CGRectMake(0, 0, MMScrollMenuViewWidth, CGRectGetHeight(self.frame));
            UILabel *itemView = [[UILabel alloc] initWithFrame:frame];
            [self.scrollView addSubview:itemView];
            itemView.tag = i;
            itemView.text = itemTitleArray[i];
            itemView.userInteractionEnabled = YES;
            itemView.backgroundColor = [UIColor clearColor];
            itemView.opaque = NO;
            itemView.textAlignment = NSTextAlignmentCenter;
            itemView.font = self.itemfont;
            itemView.textColor = _itemTitleColor;
            [views addObject:itemView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
            [itemView addGestureRecognizer:tapGesture];
        }
        
        self.itemViewArray = [NSArray arrayWithArray:views];
        
        // indicator
        _indicatorView = [[UIView alloc]init];
        _indicatorView.frame = CGRectMake(MMScrollMenuViewMargin+MMIndicatorMargin/2, _scrollView.frame.size.height - MMIndicatorHeight, MMScrollMenuViewWidth-MMIndicatorMargin, MMIndicatorHeight);
        _indicatorView.backgroundColor = self.itemIndicatorColor;
        [_scrollView addSubview:_indicatorView];
    }
}

#pragma mark -- public
- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex{
    CGFloat indicatorX = 0.0;
    if (isNextItem) {
        indicatorX = ((MMScrollMenuViewMargin + MMScrollMenuViewWidth) * ratio ) + (toIndex * MMScrollMenuViewWidth) + ((toIndex + 1) * MMScrollMenuViewMargin);
    } else {
        indicatorX =  ((MMScrollMenuViewMargin + MMScrollMenuViewWidth) * (1 - ratio) ) + (toIndex * MMScrollMenuViewWidth) + ((toIndex + 1) * MMScrollMenuViewMargin);
    }
    
    if (indicatorX < MMScrollMenuViewMargin || indicatorX > self.scrollView.contentSize.width - (MMScrollMenuViewMargin + MMScrollMenuViewWidth)) {
        return;
    }
    //设置indicatorMargin
    _indicatorView.frame = CGRectMake(indicatorX+MMIndicatorMargin/2, _scrollView.frame.size.height - MMIndicatorHeight, MMScrollMenuViewWidth-MMIndicatorMargin, MMIndicatorHeight);
}

-(void)setItemImage:(UIImage *)itemImage seletedItemImage:(UIImage *)selectedItemImage currentIndex:(NSInteger)currentIndex{
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UIImageView *imageView = self.itemViewArray[i];
        if (i == currentIndex) {
            //imageView.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 imageView.image = [UIImage imageNamed: _itemSelectedImageArray[i]];
                                 // imageView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            imageView.image = [UIImage imageNamed: _itemImageArray[i]];
        }
    }
    
}

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex
{
    if (itemTextColor) { _itemTitleColor = itemTextColor; }
    if (selectedItemTextColor) { _itemSelectedTitleColor = selectedItemTextColor; }
    
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UILabel *label = self.itemViewArray[i];
        if (i == currentIndex) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 label.alpha = 1.0;
                                 label.textColor = _itemSelectedTitleColor;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            label.textColor = _itemTitleColor;
        }
    }
}

#pragma mark -- private
// menu shadow
- (void)setShadowView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.frame.size.height - 0.5, CGRectGetWidth(self.frame), 0.5);
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = MMScrollMenuViewMargin;
    for (NSUInteger i = 0; i < self.itemViewArray.count; i++) {
        CGFloat width = MMScrollMenuViewWidth;
        UIView *itemView = self.itemViewArray[i];
        itemView.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x += width + MMScrollMenuViewMargin;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
    CGRect frame = self.scrollView.frame;
    if (self.frame.size.width > x) {
        frame.origin.x = (self.frame.size.width - x) / 2;
        frame.size.width = x;
    } else {
        frame.origin.x = 0;
        frame.size.width = self.frame.size.width;
    }
    self.scrollView.frame = frame;
}

#pragma mark -- Selector
- (void)itemViewTapAction:(UITapGestureRecognizer *)Recongnizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
        [self.delegate scrollMenuViewSelectedIndex:[(UIGestureRecognizer*) Recongnizer view].tag];
    }
}
@end
