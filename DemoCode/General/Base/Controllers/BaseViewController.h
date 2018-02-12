//
//  
//
//
//  Created by user on 15/4/7.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUFailView.h"
#import "AUNodataView.h"
#import "AULoadingView.h"
#import "DBNavigationBar.h"
typedef NS_ENUM(NSInteger, TCShareType){
    TCShareLocationType = 0,
    TCShareNetworkType = 1
};

@interface BaseViewController : UIViewController <DBNavigationBarDelegate>
@property(nonatomic,weak)UIView *maskView; // 蒙版loadingView
@property(nonatomic,strong)AUFailView *faildView;     //请求失败view
@property(nonatomic,strong)AUNodataView *noDataView;    //无数据view
@property (strong, nonatomic) AULoadingView *loadingView; // 页面加载view
/**
 *@brief 使用alloc创建的控制器
 */
+ (BaseViewController *)viewController;
/**
 *  @brief 初始化View
 */
-(void)setupViews;
/**
 *  @brief 初始化Data
 */
-(void)setupDatas;

// 快速创建
UIButton *creatXRButton(CGRect frame,NSString *title,UIImage*normalImage,UIImage *hightImage);
UITextField *creatXRTextField(NSString *placeTitle,CGRect frame);
UILabel *creatXRLable(NSString *name ,CGRect frame);
UIImageView *creatXRImageView(CGRect frame,UIImage *image);

/**
 *  @brief 控制root状态栏显示与否
 */
@property (assign, nonatomic) BOOL showRootStatusBar;
/**
 *  @brief 控制root导航栏显示与否
 */
@property (assign, nonatomic) BOOL showRootNavBar;

/**
 *  @brief 导航栏相关
 需要调用addNavigationBar方法添加到self.view上
 */
@property (strong, nonatomic, readonly) DBNavigationBar *navigationBar;
- (void)addNavigationBar;
- (void)removeNavigationBar;
- (void)setNavTitle:(NSString *)title;
// 设置导航器右边按钮一个
- (void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;
// 设置导航器左边按钮一个
- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;

@end
