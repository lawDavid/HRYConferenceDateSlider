//
//  OSWebViewController.m
//  so
//
//  Created by DavidLaw on 2017/9/23.
//  Copyright © 2017年 几何. All rights reserved.
//

#import "OSWebViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"

@interface OSWebViewController () <WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (strong,nonatomic)  WKUserContentController* userContentController;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) UIStatusBarStyle lastBarStyle;

@property (nonatomic, strong) NSString *callBackId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIButton *button;

@end

@implementation OSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    [self addSubviewConstraints];
    
    _webView.UIDelegate = self;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    [_webView loadFileURL:url allowingReadAccessToURL:url];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // status Bar
    _lastBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:_lastBarStyle];
}

- (void)setupViewController {
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"回调按钮" forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    
    _userContentController =[[WKUserContentController alloc] init];
    [_userContentController addScriptMessageHandler:self name:@"getUserInfo"];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = _userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.tintColor = [UIColor blueColor];
    [self.view addSubview:_progressView];
    
    if (_urlString) {
        NSURL *url = [[NSURL alloc] initWithString:_urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addSubviewConstraints {
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.bottom.equalTo(self.view).offset(-40);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if (_urlString) {
        NSURL *url = [[NSURL alloc] initWithString:_urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)callback {
    NSString *str = [NSString stringWithFormat:@"用户id是：%@", _userId];
    NSString *javaScriptStr = [NSString stringWithFormat:@"hryapp.execCallBack(%@, {\"name\":\"%@\"})", _callBackId, str];
    
    NSLog(@"%@", javaScriptStr);
    [_webView evaluateJavaScript:javaScriptStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"");
    }];
}

#pragma mark - JS Hander
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@", message.body);
    
    _callBackId = message.body[@"callBackId"];
    _userId = message.body[@"userId"];
//    [_webView evaluateJavaScript:@"alert(\"call back...123\");" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"");
//    }];
    
//    if ([message.name isEqualToString:@"openDetails"]) {
//        [self jumpToViewControllerWithBody:message.body];
//    }
}

//- (void)jumpToViewControllerWithBody:(NSDictionary *)dic{
//    if ([dic isKindOfClass:[NSDictionary class]]) {
//        NSInteger dealId = [dic[@"id"] integerValue];
//        NSString *url = [NSString stringWithFormat:@"app://zzhw/deal?dealId=%ld", dealId];
//        [OSRouter jumpURL:url fromViewController:self];
//    }
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //estimatedProgress
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:_webView.estimatedProgress animated:YES];
        if (_webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self->_progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    //title
    else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

@end

