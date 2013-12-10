//
//  TransitionManager.m
//

#import "TransitionManager.h"

@interface TransitionManager () {
	UIBarStyle preNavigationBarStyle;
	UIBarStyle preToolBarStyle;
	BOOL preNavigationBarHidden;
	BOOL preToolBarHidden;
	int viewControllersCount;
	__weak UINavigationController *nc;
}

@end

@implementation TransitionManager

- (id)init:(UINavigationController *)navigationController {
    if(self = [super init]){
		
		nc = navigationController;
		
		viewControllersCount = [navigationController.viewControllers count];
		
		// 遷移前のスタイルを保持
		preNavigationBarHidden = navigationController.navigationBarHidden;
		preToolBarHidden = navigationController.toolbarHidden;
		preNavigationBarStyle = navigationController.navigationBar.barStyle;
		preToolBarStyle = navigationController.toolbar.barStyle;
    }
    return self;
}

// 遷移前のスタイルに戻す
- (void)rollBack {
	if ([nc.viewControllers count] < viewControllersCount) {
		[nc setNavigationBarHidden:preNavigationBarHidden animated:YES];
		[nc setToolbarHidden:preToolBarHidden animated:YES];
		nc.navigationBar.barStyle = preNavigationBarStyle;
		nc.toolbar.barStyle = preToolBarStyle;
	}
}

- (void)dealloc {
	
}

@end
