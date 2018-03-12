//
//
//
//  Created by 阔 on 14-4-17.
//

#import "BaseNavigationController.h"
#import "UIImage+Additional.h"
#import "AppDelegate.h"
#import "DBPushAnimationDetailViewController.h"
#import "DBPushAnimationListViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign) CGRect origionRect;
@property (nonatomic, assign) CGRect desRect;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, weak) id  animationDelegate;

@end

@implementation BaseNavigationController
{
    BOOL _isEnablePop; //打开pop响应手势
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak BaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}


#pragma mark - 屏幕旋转布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:nil];
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    BaseNavigationController* nvc = [super initWithRootViewController:rootViewController];
    nvc.delegate = self;
    return nvc;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.viewControllers.count <= 1){
        return NO;
    }
    return _isEnablePop;
}

//控制根Controller不能右滑动
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _isEnablePop = YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _isEnablePop = NO;
    
    if (self.viewControllers.count>0) {
        ///第二层viewcontroller 隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.isPush = NO;
    if (self.viewControllers.count == 2) {

    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - 多方向问题
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}
- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

#pragma mark - 转场
- (void)pushViewController:(UIViewController *)viewController withImageView:(UIImageView *)imageView desRect:(CGRect)desRect delegate:(id<DBNavAnimationManagerDelegate>)delegate{
    
    self.delegate = self;
    self.imageView = imageView;
    self.origionRect = [imageView convertRect:imageView.frame toView:self.view];
    self.desRect = desRect;
    self.isPush = YES;
    self.animationDelegate = delegate;
    [self pushViewController:viewController animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (([toVC isMemberOfClass:[DBPushAnimationDetailViewController class]] || [toVC isMemberOfClass:[DBPushAnimationListViewController class]]) && ([fromVC isMemberOfClass:[DBPushAnimationDetailViewController class]] || [fromVC isMemberOfClass:[DBPushAnimationListViewController class]])) {
        DBNavAnimationManager* animation = [[DBNavAnimationManager alloc] init];
        animation.imageView = self.imageView;
        animation.origionRect = self.origionRect;
        animation.desRect = self.desRect;
        animation.isPush = self.isPush;
        animation.delegate = self.animationDelegate;
        
        if (!self.isPush && self.delegate) {
            self.delegate = nil;
        }
        return animation;
    }
    else
    {
        return nil;
    }
    
}

@end
