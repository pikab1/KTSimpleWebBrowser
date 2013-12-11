//
//  ViewController.m
//  KTSimpleWebBrowserDemo
//
//  Copyright (c) 2013年 pikab1. All rights reserved.
//

#import "ViewController.h"
#import "KTSimpleWebBrowser.h"
#import "SafariActivity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
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
										 CustomBarButtonItemTypeFixedSpace(30), // 固定長スペース(30px)
										 CustomBarButtonItemTypeForward, // 進むボタン
										 CustomBarButtonItemTypeFlexibleSpace, // 可変長スペース
										 CustomBarButtonItemTypeActionInActivity]; // アクションボタン
	
	// ナビゲーションバー右上のボタン設定
	browser.customRightBarButtonItems = @[CustomBarButtonItemTypeReloadAndStop]; // 更新／停止ボタン
	
	// 自分で生成したアイテムも設定できます
//	UIBarButtonItem *originalItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
//	browser.customRightBarButtonItems = @[originalItem, CustomBarButtonItemTypeReloadAndStop];
	
	// ページタイトルの自動表示
	browser.showAutoPageTitle = YES;
	
	// アクションシートのカスタマイズ
//	[browser setActionSheetDatasWithTitle:@"メニュー"
//									items:[NSArray arrayWithObjects:@"アプリAで開く", @"アプリBで開く", nil]
//					   actionSheetHandler:^(NSString *url, int index) {
//										
//										NSLog(@"url=%@, index=%d", url, index);
//										
//										[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//										
//									}];
	
	// アクティビティのカスタマイズ
//	SafariActivity *safari = [SafariActivity new];
//	[browser setActivityObjects:[NSArray arrayWithObjects:safari, nil]];
	
	
	// 画面遷移
	[self.navigationController pushViewController:browser animated:YES];
	
	// モーダルで出す場合はこちら
//	browser.customLeftBarButtonItems = @[CustomBarButtonItemTypeDone]; // 閉じる
//	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:browser];
//	[self.navigationController presentViewController:navi animated:YES completion:nil];
}

@end
