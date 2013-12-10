KTSimpleWebBrowser
==================

ブラウザに必要最低限の機能を簡単に実装できます

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
										 [NSNumber numberWithInteger:30], // 30pxのスペース
										 CustomBarButtonItemTypeForward, // 進むボタン
										 CustomBarButtonItemTypeFlexibleSpace, // フレキシブルスペース
										 CustomBarButtonItemTypeAction]; // アクションボタン
	
	// ナビゲーションバー右上のボタン設定
	browser.customRightBarButtonItems = @[CustomBarButtonItemTypeReloadAndStop]; // 更新／停止ボタン
	
	// ページタイトルの自動表示
	browser.showAutoPageTitle = YES;
	
	// アクションシートの設定
	[browser setActionSheetDatasWithTitle:@"メニュー"
									items:[NSArray arrayWithObjects:@"アプリAで開く", @"アプリBで開く", nil]
					   actionSheetHandler:^(NSString *url, int index) {
										
										NSLog(@"url=%@, index=%d", url, index);
										
										[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
										
									}];
	
	// 画面遷移
	[self.navigationController pushViewController:browser animated:YES];
	

Options
---------------
    
    

