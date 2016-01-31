//
//  RootViewController.m
//  Demo
//
//  Created by moyazi on 16/1/29.
//  Copyright © 2016年 Moyazi. All rights reserved.
//

#import "RootViewController.h"
#import "MMViewContainer.h"
#import "ChildViewController.h"

@interface RootViewController ()<MMViewContainerDelegate>
@property (nonatomic,strong) MMViewContainer * containerVC;
/**
 * 当前菜单栏的index
 */
@property(nonatomic,assign) NSInteger selectedMenuIndex;
@end

@implementation RootViewController
#pragma mark - Geter/Seter
/**
 *  MMViewContainer选中按钮的ID
 *
 *  @return 选中按钮的ID
 */
-(NSInteger)selectedMenuIndex{
    if (_selectedMenuIndex) {
        return _selectedMenuIndex;
    }
    _selectedMenuIndex = 0;
    return _selectedMenuIndex;
}

/**
 *  viewController容器控制器
 *
 *  @return 控制器
 */
-(MMViewContainer *)containerVC{
    if (_containerVC) {
        return _containerVC;
    }
    //创建VC数组
    NSArray *titles =@[@"title1",@"title2",@"title3",@"title4",@"title5",@"title6",@"title7",@"title8"];
    NSMutableArray *VCS = [NSMutableArray array];
    for (NSString  *str in titles) {
        ChildViewController *childVC =[[ChildViewController alloc] init];
        childVC.title = str;//menu标题
        [VCS addObject:childVC];
    }

    CGFloat pointY = self.VStatusbarHeight+self.VNavigationBarHeight;
    //文字按钮方法创建
    _containerVC = [[MMViewContainer alloc] initWithControllers:VCS topBarHeight:pointY parentViewController:self];
    _containerVC.showItemMode = 2;//文字menu创建模式
    _containerVC.menuItemFont = [UIFont systemFontOfSize:15];//设置字体
    _containerVC.menuItemTitleColor = [UIColor blackColor];//按钮文字颜色
    _containerVC.menuItemSelectedTitleColor = [UIColor colorWithRed:72/255.0f
                                                              green:99/255.0f blue:246/255.0f alpha:1.0f];//按钮选中颜色
    _containerVC.menuIndicatorColor = [UIColor colorWithRed:72/255.0f
                                                      green:99/255.0f blue:246/255.0f alpha:1.0f];//指示器颜色
    _containerVC.menuBackGroudColor = [UIColor whiteColor];//按钮背景颜色
    _containerVC.scrollMenuViewSelectedIndex = 0;
    _containerVC.delegate = self;
    _containerVC.enableScrolled = 1;//允许手势滚动
    _containerVC.contentScrollViewMarginBottomHeight = 0.0;//距底部间距
    return _containerVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //UI frame configure
    self.VViewHeight = self.view.bounds.size.height;
    self.VViewWidth = self.view.bounds.size.width;
    self.VNavigationBarHeight = self.navigationController.navigationBar.bounds.size.height;
    self.VTabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    self.VStatusbarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.VViewCenterX = self.view.center.x;
    self.VViewCenterY = self.view.center.y;
    
    // Do any additional setup after loading the view.
    self.title = @"MMViewContainer";
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    //加载视图容器
    [self.view addSubview:self.containerVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- MMViewContainerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{   //当前index
    self.selectedMenuIndex = index;
}
@end
