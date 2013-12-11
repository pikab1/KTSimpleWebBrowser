KTSimpleWebBrowser
==================

ブラウザに必要最低限の機能を簡単に実装できます  
好きなボタンを好きな位置に配置してください、あとは勝手に管理します。  
勝手に管理されて困る場合はオーバーライドしてご利用ください。  

Required
-----------------
iOS6  
ARC  
How to use simple
-----------------

    // インスタンス生成
	KTSimpleWebBrowser *browser = [[KTSimpleWebBrowser alloc] initWithURLString:@"https://www.google.co.jp/"];
	
	// ツールバーのボタン設定
	browser.customToolBarButtonItems = @[CustomBarButtonItemTypeBack, // 戻るボタン
										 CustomBarButtonItemTypeFixedSpace(30), // 固定長スペース(30px)
										 CustomBarButtonItemTypeForward, // 進むボタン
										 CustomBarButtonItemTypeFlexibleSpace, // 可変長スペース
										 CustomBarButtonItemTypeAction]; // アクションボタン（デフォルトは「Safariで開く」）
	
	// ナビゲーションバー右上のボタン設定
	browser.customRightBarButtonItems = @[CustomBarButtonItemTypeReloadAndStop]; // 更新／停止ボタン
	
	// ページタイトルの自動表示
	browser.showAutoPageTitle = YES;
	
	// 画面遷移
	[self.navigationController pushViewController:browser animated:YES];
	

Options
---------------

	/* カスタムボタンの種類 */
	CustomBarButtonItemTypeBack					// 戻る
	CustomBarButtonItemTypeForward				// 進む
	CustomBarButtonItemTypeReload				// 更新
	CustomBarButtonItemTypeReloadAndStop		// 更新と中止
	CustomBarButtonItemTypeReloadAndIndicator	// 更新とインジケータ
	CustomBarButtonItemTypeStop					// 中止
	CustomBarButtonItemTypeFlexibleSpace		// 可変長スペース
	CustomBarButtonItemTypeFixedSpace			// 固定長スペース
	CustomBarButtonItemTypeDone					// 閉じる
	CustomBarButtonItemTypeAction				// アクションボタン
	
	@property BOOL navigationbarHidden;		// ナビゲーションバーを非表示にする
	@property BOOL toolbarHidden;			// ツールバーを非表示にする
	@property BOOL showAutoPageTitle;		// ページタイトルを自動で表示する（ナビゲーションバー必須）
	@property BOOL isCustomButtonNoneBordered; 	// カスタムボタンの枠を非表示にするか

	- (void)setUserAgent:(NSString *)userAgent;				// UAを設定します
	- (void)addRequestHeaderField:(NSString *)value forKey:(NSString *)key;	// リクエストヘッダを設定します
	- (void)setActionSheetDatasWithTitle:(NSString *)title items:(NSArray *)items actionSheetHandler:(void (^)(NSString *url, int index))block;

    /* アクションシートのカスタマイズ */
	[browser setActionSheetDatasWithTitle:@"メニュー"
									items:[NSArray arrayWithObjects:@"アプリAで開く", @"アプリBで開く", nil]
					   actionSheetHandler:^(NSString *url, int index) {
										
										NSLog(@"url=%@, index=%d", url, index);
										
										[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
										
									}];
