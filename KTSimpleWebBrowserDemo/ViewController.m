//
//  ViewController.m
//  KTSimpleWebBrowserDemo
//
//  Copyright (c) 2013年 pikab1. All rights reserved.
//

#import "ViewController.h"
#import "KTSimpleWebBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPage:(id)sender {
	
	/* Simple Code
	 
	 KTSimpleWebBrowser *browser = [[KTSimpleWebBrowser alloc] initWithURLString:@"http://www.google.co.jp"];
	 [self.navigationController pushViewController:browser animated:YES];
	 
	 */
	
	
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
}

@end
