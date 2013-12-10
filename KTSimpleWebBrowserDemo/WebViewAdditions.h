//
//  WebViewAdditions.h
//

#import <Foundation/Foundation.h>

@interface UIWebView(WebViewAdditions)

// ウインドウのサイズを返します
- (CGSize)windowSize;

// 現在のスクロール位置を返します
- (CGPoint)scrollOffset;

// ページのタイトルを取得します
- (NSString *)pageTitle;

// ページのURLを取得します
- (NSString *)pageUrl;

// ページのドメインを取得します
- (NSString *)pageDomain;

// UIWebViewのスクロールビューを取得します。
// （iOS4か5くらいからはprivateメソッドじゃなくなったので必要ありません）
- (UIScrollView *)privateScrollView;

// JSで指定したフォーム名のサブミットボタンを押下します
- (void)pageSubmitWithFormName:(NSString *)formName;

// Scriptファイルをロードします
- (void)loadScriptFileWithFileName:(NSString *)fileName;
- (void)loadScriptFileWithFileName:(NSString *)fileName withResourceBundlePath:(NSString *)bundlePath;

// URL文字列を渡してリクエストします
- (void)loadRequestWithStringURL:(NSString *)url;

// NSURLRequestからURL文字列を取得します
+ (NSString *)stringUrlWithRequest:(NSURLRequest *)request;

///**
//	指定したidの設定されているエレメント（TextFieldを想定）のvalueに文字列を設定します
//	@param _id エレメントのID
//	@param insertValue 挿入する文字列
// */
//- (void)insertTextFieldWithId:(NSString *)_id insertValue:(NSString *)insertValue;
//
///**
//	指定したnameの設定されているエレメント（TextFieldを想定）のvalueに文字列を設定します
//	@param name エレメントのname
//	@param insertValue 挿入する文字列
// */
//- (void)insertTextFieldWithName:(NSString *)name insertValue:(NSString *)insertValue;
//
///**
// 渡したURLが設定されているAタグの文字列を取得します
// 渡したURLが存在しなかった場合はnullを返します
// 
// <a href="http://aaa.com">リンクです</a>
// http://aaa.comを渡した場合「リンクです」が返ります
// 
//	@param url 検索するURL
//	@returns Aタグの文字列
// */
//- (NSString *)valueForAnchor:(NSString *)url;


@end
