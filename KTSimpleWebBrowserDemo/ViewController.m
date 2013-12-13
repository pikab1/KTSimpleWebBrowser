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
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPage:(id)sender {
	
	// 一番シンプルな使い方 Pushの場合
	/*
	KTSimpleWebBrowser *browser = [[KTSimpleWebBrowser alloc] initDefaultSettingsWithURLString:@"https://www.google.co.jp/"];
	[self.navigationController pushViewController:browser animated:YES];
	*/
	
	// 一番シンプルな使い方 Modalの場合
	KTSimpleWebBrowser *browser = [[KTSimpleWebBrowser alloc] initDefaultSettingsWithURLString:@"https://www.google.co.jp/"];
	browser.customLeftBarButtonItems = @[CustomBarButtonItemTypeDone]; // 閉じるボタン
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:browser];
	[self.navigationController presentViewController:navi animated:YES completion:nil];
	 
	
/*	カスタマイズの使い方
	
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
	
	// ページタイトルの自動表示
	browser.showAutoPageTitle = YES;
	
	// 画面遷移
	[self.navigationController pushViewController:browser animated:YES];
	
	// モーダルで出す場合はこちら
//	browser.customLeftBarButtonItems = @[CustomBarButtonItemTypeDone]; // 閉じる
//	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:browser];
//	[self.navigationController presentViewController:navi animated:YES completion:nil];
 
*/
 
}

@end
