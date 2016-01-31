//
//  MMViewContainer.m
//  Demo
//
//  Created by moyazi on 16/1/29.
//  Copyright © 2016年 Moyazi. All rights reserved.
//

#import "MMViewContainer.h"
#import "MMScrollMenu.h"

static const CGFloat kPYScrollMenuViewHeight = 40;

@interface MMViewContainer () <UIScrollViewDelegate, MMScrollMenuDelegate>
@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) MMScrollMenu *menuView;
@end

@implementation MMViewContainer
#pragma mark -getter
-(NSInteger)enableScrolled{
    if (_enableScrolled) {
        return _enableScrolled;
    }
    _enableScrolled = 1;//默认允许滚动
    return _enableScrolled;
}

-(NSInteger)contentScrollViewMarginBottomHeight{
    if (_contentScrollViewMarginBottomHeight) {
        return  _contentScrollViewMarginBottomHeight;
    }
    _contentScrollViewMarginBottomHeight  = 1;//默认离底部1像素
    return  _contentScrollViewMarginBottomHeight;
}

-(NSInteger)scrollMenuViewSelectedIndex{
    if (_scrollMenuViewSelectedIndex) {
        return _scrollMenuViewSelectedIndex;
    }
    _scrollMenuViewSelectedIndex = 0;
    return _scrollMenuViewSelectedIndex;
}

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
     parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self) {
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
        _topBarHeight = topBarHeight;
        _childControllers = [[NSMutableArray alloc] init];
        _childControllers = [controllers mutableCopy];
        _images = [images mutableCopy];
        _selectedImages = [selectedImages mutableCopy];
        _menuItemImage = [UIImage imageNamed:_images[0]];
        _menuItemSelectedImage = [UIImage imageNamed:_selectedImages[0]];
        self.showItemMode = 1;//图片模式
    }
    return self;
}

/**
 *  加载文字(非图片方法)
 *
 *  @param controllers          控制器
 *  @param items                menu对应的文字
 *  @param topBarHeight         topbar高度
 *  @param parentViewController 父类控制器
 *
 *  @return 当前类的实例化
 */
-(id)initWithControllers:(NSArray *)controllers topBarHeight:(CGFloat)topBarHeight parentViewController:(UIViewController *)parentViewController{
    self = [super init];
    if (self) {
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
        _topBarHeight = topBarHeight;
        _childControllers = [[NSMutableArray alloc] init];
        _childControllers = [controllers mutableCopy];
        self.showItemMode = 2;//改为非图片模式(文字模式)
        NSMutableArray *titles = [NSMutableArray array];
        for (UIViewController *vc in _childControllers) {
            [titles addObject:[vc valueForKey:@"title"]];
        }
        _titles = [titles mutableCopy];
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setupViews
    UIView *viewCover = [[UIView alloc]init];
    [self.view addSubview:viewCover];
    
    // ContentScrollview setup
    _contentScrollView = [[UIScrollView alloc]init];
    _contentScrollView.frame = CGRectMake(0,_topBarHeight + kPYScrollMenuViewHeight, self.view.frame.size.width, self.view.frame.size.height - (_topBarHeight + kPYScrollMenuViewHeight)-self.contentScrollViewMarginBottomHeight);
    
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.opaque = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    [self.view addSubview:_contentScrollView];

    _contentScrollView.contentSize =  _enableScrolled==1 ? CGSizeMake(_contentScrollView.frame.size.width * self.childControllers.count, _contentScrollView.frame.size.height):CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
    
    // ContentViewController setup
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = [self.childControllers objectAtIndex:i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            CGFloat scrollWidth = _contentScrollView.frame.size.width;
            CGFloat scrollHeght = _contentScrollView.frame.size.height;
            controller.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeght);
            [_contentScrollView addSubview:controller.view];
        }
    }
    
    // meunView
    _menuView = [[MMScrollMenu alloc]initWithFrame:CGRectMake(0, _topBarHeight, self.view.frame.size.width, kPYScrollMenuViewHeight)];
    _menuView.backgroundColor = [UIColor colorWithRed:51/255.0 green:53/255.0 blue:56/255.0 alpha:1];
    _menuView.delegate = self;
    //图片menu模式
    if (self.showItemMode ==1) {
        _menuView.itemImage = self.menuItemImage;
        _menuView.itemSelectedImage = self.menuItemSelectedImage;
        [_menuView setItemSelectedImageArray:self.selectedImages];
        [_menuView setItemImageArray:self.images];
        
    }
    //文字menu模式
    if (self.showItemMode ==2){
        _menuView.viewbackgroudColor = self.menuBackGroudColor;
        _menuView.itemfont = self.menuItemFont;
        _menuView.itemTitleColor = self.menuItemTitleColor;
        _menuView.itemIndicatorColor = self.menuIndicatorColor;
        [_menuView setItemTitleArray:self.titles];
        //[_menuView setShadowView];
    }
    _menuView.scrollView.scrollsToTop = NO;
    [self.view addSubview:_menuView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollMenuViewSelectedIndex:self.scrollMenuViewSelectedIndex];
}

#pragma mark -- private
- (void)setChildViewControllerWithCurrentIndex:(NSInteger)currentIndex
{
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = self.childControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            if (i == currentIndex) {
                [controller willMoveToParentViewController:self];
                [self addChildViewController:controller];
                [controller didMoveToParentViewController:self];
            } else {
                [controller willMoveToParentViewController:self];
                [controller removeFromParentViewController];
                [controller didMoveToParentViewController:self];
            }
        }
    }
}

#pragma mark -- YSLScrollMenuView Delegate
- (void)scrollMenuViewSelectedIndex:(NSInteger)index
{
    [_contentScrollView setContentOffset:CGPointMake(index * _contentScrollView.frame.size.width, 0.) animated:YES];
    if (self.showItemMode ==1) {
        //图片按钮
        self.menuItemImage =   [UIImage imageNamed:_images[index]];
        self.menuItemSelectedImage = [UIImage imageNamed:_selectedImages[index]];
        [_menuView setItemImage:self.menuItemImage seletedItemImage:self.menuItemSelectedImage currentIndex:index];
    }
    else{
        //文字按钮
        [_menuView setItemTextColor:self.menuItemTitleColor
               seletedItemTextColor:self.menuItemSelectedTitleColor
                       currentIndex:index];
    }
    [self setChildViewControllerWithCurrentIndex:index];
    
    if (index == self.currentIndex) { return; }
    self.currentIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
}

#pragma mark -- ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat oldPointX = self.currentIndex * scrollView.frame.size.width;
    CGFloat ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.frame.size.width;
    
    BOOL isToNextItem = (_contentScrollView.contentOffset.x > oldPointX);
    NSInteger targetIndex = (isToNextItem) ? self.currentIndex + 1 : self.currentIndex - 1;
    
    CGFloat nextItemOffsetX = 1.0f;
    CGFloat currentItemOffsetX = 1.0f;
    
    nextItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * targetIndex / (_menuView.itemViewArray.count - 1);
    currentItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * self.currentIndex / (_menuView.itemViewArray.count - 1);
    
    if (targetIndex >= 0 && targetIndex < self.childControllers.count) {
        // MenuView Move
        CGFloat indicatorUpdateRatio = ratio;
        if (isToNextItem) {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * 1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currentIndex];
        } else {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * -1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentIndex = scrollView.contentOffset.x / _contentScrollView.frame.size.width;
    
    if (currentIndex == self.currentIndex) { return; }
    self.currentIndex = currentIndex;
    if (self.showItemMode ==1) {
        [_menuView setItemImage:self.menuItemImage seletedItemImage:self.menuItemSelectedImage currentIndex:currentIndex];
    }
    if (self.showItemMode==2) {
        // item color
        [_menuView setItemTextColor:self.menuItemTitleColor
               seletedItemTextColor:self.menuItemSelectedTitleColor
                       currentIndex:currentIndex];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
    [self setChildViewControllerWithCurrentIndex:self.currentIndex];
}
@end
