
#import <UIKit/UIKit.h>
#import "WebViewAdditions.h"

@protocol KTSimpleWebBrowserDelegate;

/*
 シンプルで簡単に使えるブラウザを提供します
 
 Created by pikab1 on 1.0.1
 required iOS6,ARC
 
 */
@interface KTSimpleWebBrowser : UIViewController


/*
 備考
 * NSNumberを設定すると固定長スペースとして適用されます。
 * 独自で作成したUIBarButtonItemを設定する事もできます。
 */
extern NSString *const CustomBarButtonItemTypeBack;					// 戻る
extern NSString *const CustomBarButtonItemTypeForward;				// 進む
extern NSString *const CustomBarButtonItemTypeReload;				// 更新
extern NSString *const CustomBarButtonItemTypeReloadAndStop;		// 更新と中止
extern NSString *const CustomBarButtonItemTypeReloadAndIndicator;	// 更新とインジケータ
extern NSString *const CustomBarButtonItemTypeStop;					// 中止
extern NSString *const CustomBarButtonItemTypeFlexibleSpace;		// 可変長スペース
#define CustomBarButtonItemTypeFixedSpace(px) [NSNumber numberWithInteger:px] // 固定長スペース
extern NSString *const CustomBarButtonItemTypeDone;					// 閉じる
extern NSString *const CustomBarButtonItemTypeActionInActionSheet;	// アクションボタン（アクションシート）
extern NSString *const CustomBarButtonItemTypeActionInActivity;		// アクションボタン（アクティビティ）

@property (nonatomic, strong) NSArray *customLeftBarButtonItems;	// ナビゲーションバーの左側
@property (nonatomic, strong) NSArray *customRightBarButtonItems;	// ナビゲーションバーの右側
@property (nonatomic, strong) NSArray *customToolBarButtonItems;	// ツールバー


@property (nonatomic, weak) id <KTSimpleWebBrowserDelegate> delegate;
@property (nonatomic, strong, readonly) UIWebView *wv;
@property (nonatomic, strong) NSString *requestHTML;		// 表示するHTML
@property (nonatomic, strong) NSString *baseURL;			// HTMLをロードする際のベースURL
@property (nonatomic, strong) NSString *requestURL;			// 表示するURL

@property BOOL navigationbarHidden;	// ナビゲーションバーを非表示にする
@property BOOL toolbarHidden;		// ツールバーを非表示にする
@property BOOL showAutoPageTitle;	// ページタイトルを自動で表示する（ナビゲーションバー必須）
@property BOOL isCustomButtonNoneBordered; // カスタムボタンの枠を非表示にするか

- (id)initWithURLString:(NSString *)newURL;								// インスタンス生成
- (void)setUserAgent:(NSString *)userAgent;								// UAを設定します
- (void)addRequestHeaderField:(NSString *)value forKey:(NSString *)key;	// リクエストヘッダを設定します
/*
  アクションシートの設定
 （設定しない場合は「Safariで開く」のみ表示されます
 
 title:アクションシートのタイトル
 items:アクションシートのボタン
 url:ブラウザで表示しているページのURL
 index:選択したアクションシートのindex値
 */
- (void)setActionSheetDatasWithTitle:(NSString *)title items:(NSArray *)items actionSheetHandler:(void (^)(NSString *url, int index))block;

// カスタムアクティビティを設定します（設定しない場合は、URLに対応したネイティブアプリとSafariが表示されます）
- (void)setActivityObjects:(NSArray *)applicationActivities;

- (void)sendRequest __attribute__((objc_requires_super));
- (void)back __attribute__((objc_requires_super));
- (void)forward __attribute__((objc_requires_super));
- (void)reload __attribute__((objc_requires_super));
- (void)stop __attribute__((objc_requires_super));
- (void)actionInActionSheet __attribute__((objc_requires_super));
- (void)actionInActivity __attribute__((objc_requires_super));
- (void)didFinishProcess __attribute__((objc_requires_super));

// UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView __attribute__((objc_requires_super));
- (void)webViewDidFinishLoad:(UIWebView *)webView __attribute__((objc_requires_super));


@end

@protocol KTSimpleWebBrowserDelegate <NSObject>

- (void)ktSimpleWebBrowserDidFinishLoad;

@end