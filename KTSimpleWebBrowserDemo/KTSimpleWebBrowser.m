
#import "KTSimpleWebBrowser.h"
#import "TransitionManager.h"
#import "UIImage+Additions.h"

typedef void (^ActionSheetHandler)(NSString *url, int index); // 表示中のURL、選択したindex値

NSString *const CustomBarButtonItemTypeBack = @"CustomBarButtonItemTypeBack";
NSString *const CustomBarButtonItemTypeForward = @"CustomBarButtonItemTypeForward";
NSString *const CustomBarButtonItemTypeReload = @"CustomBarButtonItemTypeReload";
NSString *const CustomBarButtonItemTypeReloadAndStop = @"CustomBarButtonItemTypeReloadAndStop";
NSString *const CustomBarButtonItemTypeReloadAndIndicator = @"CustomBarButtonItemTypeReloadAndIndicator";
NSString *const CustomBarButtonItemTypeStop = @"CustomBarButtonItemTypeStop";
NSString *const CustomBarButtonItemTypeFlexibleSpace = @"CustomBarButtonItemTypeFlexibleSpace";
NSString *const CustomBarButtonItemTypeDone = @"CustomBarButtonItemTypeDone";
NSString *const CustomBarButtonItemTypeAction = @"CustomBarButtonItemTypeAction";

@interface KTSimpleWebBrowser () <UIWebViewDelegate, UIActionSheetDelegate> {
	int _loadingCount;
	TransitionManager *_manager;
	UIActionSheet *_actionsSheet;
}

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *activityBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong) NSMutableDictionary *requestHeaderField;

// アクションシートのデータ
@property (nonatomic, strong) NSString *actionSheetTitle;
@property (nonatomic, strong) NSArray *actionSheetItems;
@property (nonatomic, strong) ActionSheetHandler actionSheetHandler;

@end

@implementation KTSimpleWebBrowser

@synthesize customLeftBarButtonItems;
@synthesize customRightBarButtonItems;
@synthesize customToolBarButtonItems;
@synthesize wv;
@synthesize requestHTML;
@synthesize baseURL;
@synthesize requestURL;
@synthesize navigationbarHidden;
@synthesize toolbarHidden;
@synthesize showAutoPageTitle;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, activityBarButtonItem, doneBarButtonItem, actionBarButtonItem;

//-------------------------------------------------------------------------------//
#pragma mark - Initialize
//-------------------------------------------------------------------------------//

- (id)initWithURLString:(NSString *)newURL {
	if (self = [super init]) {
		self.requestURL = newURL;
    }
    return self;
}

//-------------------------------------------------------------------------------//
#pragma mark - Create instance of button
//-------------------------------------------------------------------------------//

- (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imageName style:(UIBarButtonItemStyle)style action:(SEL)action {
	
	UIImage *originalIcon = [UIImage imageNamed:imageName];
	
	// https://github.com/mbcharbonneau/UIImage-Categories
	UIImage *landscapeIcon = [originalIcon resizedImage:CGSizeMake(originalIcon.size.width * 0.8, originalIcon.size.width * 0.8) interpolationQuality:kCGInterpolationHigh];
	
	return [self createBarButtonItemWithImage:originalIcon landscapeImage:landscapeIcon style:style action:action];
}

- (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imageName landscapeImageName:(NSString *)landscapeImageName style:(UIBarButtonItemStyle)style action:(SEL)action {
	
	UIImage *originalIcon = [UIImage imageNamed:imageName];
	UIImage *landscapeIcon = [UIImage imageNamed:landscapeImageName];
	
	return [self createBarButtonItemWithImage:originalIcon landscapeImage:landscapeIcon style:style action:action];
}

- (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image landscapeImage:(UIImage *)landscapeImage style:(UIBarButtonItemStyle)style action:(SEL)action {
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:landscapeImage style:style target:self action:action];
	
	if (self.isCustomButtonNoneBordered) {
		[item setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	}
	
	return item;
}

- (UIBarButtonItem *)createBarButtonSystemItem:(UIBarButtonSystemItem)systemItem action:(SEL)action {
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:action];
	
	if (self.isCustomButtonNoneBordered) {
		[item setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	}
	
	return item;
}

- (UIBarButtonItem *)createBarButtonCustomView:(UIView *)customView {
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
	
	if (self.isCustomButtonNoneBordered) {
		[item setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	}
	
	return item;
}

//-------------------------------------------------------------------------------//
#pragma mark - Getters
//-------------------------------------------------------------------------------//

- (UIBarButtonItem *)backBarButtonItem {
	
    if (!backBarButtonItem) {
		backBarButtonItem = [self createBarButtonItemWithImageName:@"WebPageView.bundle/back.png" style:UIBarButtonItemStylePlain action:@selector(back)];
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
		forwardBarButtonItem = [self createBarButtonItemWithImageName:@"WebPageView.bundle/forward.png" style:UIBarButtonItemStylePlain action:@selector(forward)];
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
		refreshBarButtonItem = [self createBarButtonSystemItem:UIBarButtonSystemItemRefresh action:@selector(reload)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
		stopBarButtonItem = [self createBarButtonSystemItem:UIBarButtonSystemItemStop action:@selector(stop)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)activityBarButtonItem {
	
	if (!activityBarButtonItem) {
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
		[activityView startAnimating];
		[activityView sizeToFit];
		[activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
		activityBarButtonItem = [self createBarButtonCustomView:activityView];
	}
	
	return activityBarButtonItem;
}

- (UIBarButtonItem *)doneBarButtonItem {
	
	if (!doneBarButtonItem) {
		doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
	}
	
	return doneBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
	
	if (!actionBarButtonItem) {
		actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
	}
	
	return actionBarButtonItem;
}

//-------------------------------------------------------------------------------//
#pragma mark - Native life cycle
//-------------------------------------------------------------------------------//

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.requestHeaderField = [NSMutableDictionary dictionary];
	
	// 前画面の状態を保持する
	_manager = [[TransitionManager alloc] init:self.navigationController];
	
	// UIWebViewの生成
	wv = [UIWebView new];
	wv.delegate = self;
	wv.scalesPageToFit = YES;
	wv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:wv];
	
	// WebViewのアクセスを開始する
	[self sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	wv.delegate = nil;
	if (wv.isLoading) {
		[self didFinishProcess];
		[wv stopLoading];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// 遷移前のスタイルに戻す
	[_manager rollBack];
}

//-------------------------------------------------------------------------------//
#pragma mark - Private methods
//-------------------------------------------------------------------------------//

- (NSMutableArray *)getBarButtonItems:(NSArray *)buttons {
	NSMutableArray *items = [NSMutableArray array];
	
	for (int i = 0; i < [buttons count]; i++) {
		
		id button = [buttons objectAtIndex:i];
		
		if ([button isKindOfClass:[NSString class]]) { // NSStringはCustomBarButtonItem
			
			if (button == CustomBarButtonItemTypeBack) {
				[items addObject:self.backBarButtonItem];
			} else if (button == CustomBarButtonItemTypeForward) {
				[items addObject:self.forwardBarButtonItem];
			} else if (button == CustomBarButtonItemTypeReload) {
				[items addObject:self.refreshBarButtonItem];
			} else if (button == CustomBarButtonItemTypeReloadAndStop) {
				[items addObject:_loadingCount > 0 ? self.stopBarButtonItem : self.refreshBarButtonItem];
			} else if (button == CustomBarButtonItemTypeReloadAndIndicator) {
				[items addObject:_loadingCount > 0 ? self.activityBarButtonItem : self.refreshBarButtonItem];
			} else if (button == CustomBarButtonItemTypeStop) {
				[items addObject:self.stopBarButtonItem];
			} else if (button == CustomBarButtonItemTypeFlexibleSpace) {
				[items addObject:[self createBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace action:nil]];
			} else if (button == CustomBarButtonItemTypeDone) {
				[items addObject:self.doneBarButtonItem];
			} else if (button == CustomBarButtonItemTypeAction) {
				[items addObject:self.actionBarButtonItem];
			} else {
				NSLog(@"*************** error!! [不明なBarTypeです] ****************");
			}
			
		} else if ([button isKindOfClass:[UIBarButtonItem class]]) { // UIBarButtonItemはそのままアイテムとして追加する
			[items addObject:button];
		} else if ([button isKindOfClass:[NSNumber class]]) { // NSNumberはFixedSpaceとして扱う
			UIBarButtonItem *item = [self createBarButtonSystemItem:UIBarButtonSystemItemFixedSpace action:nil];
			item.width = [button floatValue];
			[items addObject:item];
		}
	}
	
	return items;
}

// ナビゲーションバーの更新
- (void)updateNavigationbarItems {
	
	self.navigationController.toolbarHidden = toolbarHidden;
	self.navigationController.navigationBarHidden = navigationbarHidden;
	
	self.navigationItem.leftBarButtonItems = [self getBarButtonItems:self.customLeftBarButtonItems];
	self.navigationItem.rightBarButtonItems = [self getBarButtonItems:self.customRightBarButtonItems];
	
}

// ツールバーの更新
- (void)updateToolbarItems {
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = (_loadingCount > 0);
	
	self.toolbarItems = [self getBarButtonItems:self.customToolBarButtonItems];
	
	self.backBarButtonItem.enabled = self.wv.canGoBack;
	self.forwardBarButtonItem.enabled = self.wv.canGoForward;
	
}

- (void)updateBarItems {
	[self updateNavigationbarItems];
	[self updateToolbarItems];
}

// タイトルを更新する
- (void)updateTitle {
	if (showAutoPageTitle) {
		self.title = [wv pageTitle];
	}
}

// 画面を閉じる（モーダルで表示されている場合のみ動作）
- (void)done {
	[self dismissViewControllerAnimated:YES completion:nil];
}

// アクションシートを表示する
- (void)showActionSheet {
	
	_actionsSheet = [[UIActionSheet alloc] init];
	_actionsSheet.delegate = self;
	
	// タイトル
	_actionsSheet.title = self.actionSheetTitle ? self.actionSheetTitle : NSLocalizedString(@"Menu", nil);
	
	// コンテンツ
	if ([self.actionSheetItems count]) {
		for (NSString *item in self.actionSheetItems) {
			[_actionsSheet addButtonWithTitle:item];
		}
		_actionsSheet.cancelButtonIndex = [self.actionSheetItems count];
	} else {
		[_actionsSheet addButtonWithTitle:@"Safariで開く"];
		_actionsSheet.cancelButtonIndex = 1;
	}
	[_actionsSheet addButtonWithTitle:@"キャンセル"];
	
	_actionsSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[_actionsSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
	} else {
		if (self.toolbarHidden) {
			[_actionsSheet showInView:self.view];
		} else {
			[_actionsSheet showFromToolbar:self.navigationController.toolbar];
		}
	}
}

//-------------------------------------------------------------------------------//
#pragma mark - Public Methods
//-------------------------------------------------------------------------------//

- (void)sendRequest {
	
	wv.frame = self.view.bounds;
	[self updateBarItems];
	
	if ([requestHTML length] != 0) {
		[wv loadHTMLString:requestHTML baseURL:[NSURL URLWithString:self.baseURL]];
	} else if ([requestURL length] != 0) {
		[wv loadRequestWithStringURL:self.requestURL];
	}
	
}

- (void)setUserAgent:(NSString *)userAgent {
	[self addRequestHeaderField:userAgent forKey:@"User-Agent"];
}

- (void)addRequestHeaderField:(NSString *)value forKey:(NSString *)key {
	[self.requestHeaderField setValue:value forKey:key];
}

- (void)setActionSheetDatasWithTitle:(NSString *)title items:(NSArray *)items actionSheetHandler:(void (^)(NSString *url, int index))block {
	self.actionSheetTitle = title;
	self.actionSheetItems = items;
	self.actionSheetHandler = block;
}

//-------------------------------------------------------------------------------//
#pragma mark - UIWebViewAction
//-------------------------------------------------------------------------------//

// 戻る
- (void)back {
	[wv goBack];
}

// 進む
- (void)forward {
	[wv goForward];
}

// 更新
- (void)reload {
	[wv reload];
}

// 停止
- (void)stop {
    [wv stopLoading];
	[self updateToolbarItems];
}

//-------------------------------------------------------------------------------//
#pragma mark - UIWebViewDelegate
//-------------------------------------------------------------------------------//

- (NSURLRequest *) uiWebView:(id)webView
				  resource:(id)identifier
		   willSendRequest:(NSURLRequest *)request
		  redirectResponse:(NSURLResponse *)redirectResponse
			fromDataSource:(id)dataSource {
	
	// リクエストヘッダに追加
	if ([[self.requestHeaderField allKeys] count] != 0) {
		NSMutableURLRequest *mReq = (NSMutableURLRequest *)request;
		for (id key in [self.requestHeaderField keyEnumerator]) {
			[mReq setValue:[self.requestHeaderField valueForKey:key] forHTTPHeaderField:key];
		}
		request = mReq;
	}
	
	return request;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//キャッシュを全て消去
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	_loadingCount++;
	
	[self updateBarItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self didFinishProcess];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	//NSLog(@"didFailLoadWithError %@", [error localizedDescription]);
	[self didFinishProcess];
}

// 通信後の処理
- (void)didFinishProcess {
	_loadingCount--;
	
	if (_loadingCount > 0) {
		return;
	}
	
	_loadingCount = 0;
	
	[self updateBarItems];
	[self updateTitle];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(ktSimpleWebBrowserDidFinishLoad)]) {
		[self.delegate ktSimpleWebBrowserDidFinishLoad];
	}
}

//-------------------------------------------------------------------------------//
#pragma mark - UIActionSheetDelegate
//-------------------------------------------------------------------------------//

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet == _actionsSheet) {
		_actionsSheet = nil;
        if (buttonIndex != actionSheet.cancelButtonIndex) {
			
			if (self.actionSheetHandler) {
				self.actionSheetHandler([wv pageUrl], buttonIndex);
			} else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[wv pageUrl]]];
			}
        }
    }
}

@end
