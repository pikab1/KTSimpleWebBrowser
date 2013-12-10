//
//  WebViewAdditions.m
//

#import "WebViewAdditions.h"

@implementation UIWebView(WebViewAdditions)

- (CGSize)windowSize
{
	CGSize size;
	size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
	size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
	return size;
}

- (CGPoint)scrollOffset
{
	CGPoint pt;
	pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
	pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
	return pt;
}

- (NSString *)pageTitle
{
	return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString *)pageUrl
{
	return [self stringByEvaluatingJavaScriptFromString:@"document.URL"];
}

- (NSString *)pageDomain
{
	return [self stringByEvaluatingJavaScriptFromString:@"document.domain"];
}

- (UIScrollView *)privateScrollView
{
	for (NSObject *subView in [self subviews]) {
		if ([subView isKindOfClass:[UIScrollView class]]) {
			return (UIScrollView *)subView;
		}
	}
	return nil;
}

- (void)pageSubmitWithFormName:(NSString *)formName {
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.%@.submit();", formName]];
}

- (void)loadScriptFileWithFileName:(NSString *)fileName {
	[self loadScriptFileWithFileName:fileName withResourceBundlePath:@""];
}

- (void)loadScriptFileWithFileName:(NSString *)fileName withResourceBundlePath:(NSString *)bundlePath {
	NSMutableString *resourcePath = [NSMutableString stringWithString:bundlePath];
	if ([resourcePath length] != 0) {
		[resourcePath appendString:@"/"];
	}
	[resourcePath appendString:fileName];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"js"];
	NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[self stringByEvaluatingJavaScriptFromString:script];
}

- (void)loadRequestWithStringURL:(NSString *)url {
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

+ (NSString *)stringUrlWithRequest:(NSURLRequest *)request {
	return [[[request URL] standardizedURL] absoluteString];
}

//#pragma mark Required resource "script.js"
//
//- (void)insertTextFieldWithId:(NSString *)_id insertValue:(NSString *)insertValue
//{
//	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"insertTextFieldWithId('%@','%@');", _id, insertValue]];
//}
//
//- (void)insertTextFieldWithName:(NSString *)name insertValue:(NSString *)insertValue
//{
//	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"insertTextFieldWithName('%@','%@');", name, insertValue]];
//}
//
//- (NSString *)valueForAnchor:(NSString *)url
//{
//	return [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"valueForAnchor('%@');", url]];
//}

@end
