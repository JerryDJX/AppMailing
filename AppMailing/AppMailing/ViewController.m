//
//  ViewController.m
//  AppMailing
//
//  Created by DJX on 2021/2/20.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>
#import <dsBridge/dsbridge.h>

@interface ViewController ()<SKStoreProductViewControllerDelegate>
{
    DWKWebView  *dwebview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //初始化WebView
    dwebview=[[DWKWebView alloc] initWithFrame:CGRectMake(0, self.view.safeAreaInsets.top + self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2 - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom)];

    dwebview.navigationDelegate = self;
    [dwebview setOpaque:NO];
    [self.view addSubview: dwebview];

    [dwebview addJavascriptObject:[[JsApiTest alloc] init] namespace:nil];

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];

    NSString *htmlPath = [[NSString alloc]initWithFormat:@"%@/Resource/test.html", [[NSBundle mainBundle] resourcePath]];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    [dwebview loadHTMLString:htmlContent baseURL:baseURL];
}

- (IBAction)mailingFaile:(id)sender {
    NSURL *appUrl = [NSURL URLWithString:@"alipay://"];//要跳转至App的Url Scheme 前缀，注意这个前缀需要添加在Info.plist文件LSApplicationQueriesSchemes下面
    BOOL appIsExist = [[UIApplication sharedApplication] canOpenURL:appUrl];//判断该App在手机内是否存在
    
    NSDictionary *dic = [NSDictionary dictionary];//主要防止下面option传入nil报警告
    if (appIsExist) {//装了
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", appUrl]] options: dic completionHandler:^(BOOL success) {
            NSLog(@"嘿，我打开过了");
        }];
    }else{//没装
        NSLog(@"没安装");
        /*
        //第一种方案：调至AppStore
        NSString *str = @"https://apps.apple.com/cn/app/支付宝-生活好-支付宝/id333206289";//如果没有安装就调至该App在AppStore的下载页面中。
        NSString *str1 = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//将url中的汉字进行Encoding转发，不转发无法跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str1] options:dic completionHandler:^(BOOL success) {
            NSLog(@"成功到达AppStore");
        }];
        */
        
         //第二种方案：直接在本App中展示AppStore中的下载页面
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        //设置代理请求为当前控制器本身
        storeProductViewContorller.delegate = self;
        //加载一个新的视图展示
        [storeProductViewContorller loadProductWithParameters:
         //appId唯一的
         @{SKStoreProductParameterITunesItemIdentifier : @"333206289"} completionBlock:^(BOOL result, NSError *error) {
             //block回调
             if(error){
                 NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
             }else{
                 //模态弹出appstore
                 [self presentViewController:storeProductViewContorller animated:YES completion:^{

                 }
                  ];
             }
        }];
         
    }
}

#pragma mark- SKStoreProductViewControllerDelegate的代理方法：当点击下载页面左上角完成时，退出当前下载页面
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mailingSucceed:(id)sender {
    NSURL *appUrl = [NSURL URLWithString:@"appPulledAim://"];//要跳转至App的Url Scheme 前缀，注意这个前缀需要添加在Info.plist文件LSApplicationQueriesSchemes下面
    BOOL appIsExist = [[UIApplication sharedApplication] canOpenURL:appUrl];//判断该App在手机内是否存在
    NSDictionary *dic = [NSDictionary dictionary];//主要防止下面option传入nil报警告
    
    if (appIsExist) {//装了
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@canshu?AppMailing", appUrl]] options:dic completionHandler:^(BOOL success) {
            NSLog(@"嘿，我打开过了");
        }];
    }else{//没装
        NSLog(@"没安装");
    }
}

@end
