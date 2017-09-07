//
//
//  
//
//  Created by user on 15/4/7.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Additional.h"
#import "Helper.h"
@interface BaseViewController ()

@property (strong, nonatomic) AUNavigationBar *navigationBar; // 导航栏
@end

@implementation BaseViewController
+ (BaseViewController *)viewController{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBackgroundColor;
    self.navigationController.navigationBarHidden = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.noDataView.type = AUNodataViewNormalType;
    [self.view addSubview:self.faildView];
    [self.view addSubview:self.noDataView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)setupViews
{}
-(void)setupDatas
{}

// MARK: getter
-(UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor grayColor];
        maskView.alpha = 0.4;
        [self.view addSubview:maskView];
        _maskView=maskView;
    }
    return _maskView;
}

#pragma mark - 导航栏相关
- (AUNavigationBar *)navigationBar
{
    if (_navigationBar == nil) {
        AUNavigationBar *subview = [AUNavigationBar navigationBar];
        subview.delegate = self;
        subview.backButton.hidden = self==self.navigationController.childViewControllers.firstObject;
        _navigationBar = subview;
    }
    return _navigationBar;
}
- (void)addNavigationBar
{
    if (self.navigationBar.superview == nil) {
        [self.view addSubview:self.navigationBar];
        [self.view sendSubviewToBack:self.navigationBar];
    }
}
- (void)removeNavigationBar
{
    if (self.navigationBar.superview != nil) {
        [self.navigationBar removeFromSuperview];
    }
}
- (AUFailView *)faildView{
    if (!_faildView) {
        _faildView = [[AUFailView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupDatas)];
        [_faildView addGestureRecognizer:tap];
        _faildView.hidden = YES;
    }
    return _faildView;
}

- (AUNodataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[AUNodataView alloc] initNoDataView];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}
- (AULoadingView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[AULoadingView alloc] init];
        _loadingView.hidesWhenStopped = YES;
        _loadingView.hidden = YES;
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

// 子类可自行实现返回代理
- (void)navigationBarDidClickBack:(AUNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 设置导航栏标题
- (void)setNavTitle:(NSString *)title
{
    self.navigationBar.title = title;
}
- (void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action
{
    self.navigationBar.rightBarItems = @[[self getButtonItemWithImg:normalImg selImg:selImg title:title action:action type:1]];
}
- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action
{
    self.navigationBar.leftBarItems = @[[self getButtonItemWithImg:normalImg selImg:selImg title:title action:action type:0]];
}
//获取一个导航栏按钮对象
- (UIButton *)getButtonItemWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action type:(int)leftOrRight
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    if (norImg)
        [button setImage:[[UIImage imageNamed:norImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (selImg)
        [button setImage:[[UIImage imageNamed:selImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    if (title) {
        UIFont *textFont = KFont(15, UIFontWeightRegular);
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:textFont];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button sizeToFit];
    if (button.width < 30) {
        button.width = 30;
    }
    if (button.height < 30) {
        button.height = 30;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark - 多方向问题
- (BOOL)shouldAutorotate{
    // 是否支持旋转屏幕
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 支持哪些方向
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认显示的方向
    return UIInterfaceOrientationPortrait;
}

UITextField *creatXRTextField(NSString *placeTitle,CGRect frame){
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.placeholder =placeTitle;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    //    textField.clearsOnBeginEditing =YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

UIButton *creatXRButton(CGRect frame,NSString *title,UIImage*normalImage,UIImage *hightImage){
    UIButton *bnt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bnt setFrame:frame];
    [bnt setTitle:title forState:UIControlStateNormal];
    bnt.titleLabel.text =title;
    
    [bnt setImage:normalImage forState:UIControlStateNormal];
    [bnt setImage:hightImage forState:UIControlStateHighlighted];
    [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return bnt;
}

UILabel *creatXRLable(NSString *name ,CGRect frame){
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    [lable setText:name];
    lable.backgroundColor=[UIColor clearColor];
    lable.lineBreakMode=NSLineBreakByWordWrapping;
    lable.numberOfLines= 0;
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:20.0f];
    return lable;
}
UIImageView *creatXRImageView(CGRect frame,UIImage *image){
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.userInteractionEnabled =YES;
    imageView.image=image;
    return imageView;
}

@end
