//
//  JsApiTest.m
//  AppMailing
//
//  Created by KANG HAN on 2021/2/23.
//

#import "JsApiTest.h"
#import "NSString+UrlEncode.h"

@interface JsApiTest(){
  NSTimer * timer ;
  void(^hanlder)(id value,BOOL isComplete);
  int value;
}
@end

@implementation JsApiTest
- (NSString *) testSyn: (NSString *) msg
{
    
    
    NSURL *appUrl = [NSURL URLWithString:@"weixin://"];//要跳转至App的Url Scheme 前缀，注意这个前缀需要添加在Info.plist文件LSApplicationQueriesSchemes下面
    BOOL appIsExist = [[UIApplication sharedApplication] canOpenURL:appUrl];//判断该App在手机内是否存在
    NSDictionary *dic = [NSDictionary dictionary];//主要防止下面option传入nil报警告，后续可以传入参数
    
    if (appIsExist) {//装了
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", appUrl]] options:dic completionHandler:^(BOOL success) {
            NSLog(@"嘿，我打开过了");
        }];
    }else{//没装
        NSLog(@"没安装");
    }
    
    return [msg stringByAppendingString:@"[ syn call]"];
}

- (NSString *) testSyn2: (NSString *) msg
{
   
    
    NSURL *appUrl = [NSURL URLWithString:@"appPulledAim://"];
    BOOL appIsExist = [[UIApplication sharedApplication] canOpenURL:appUrl];//判断该App在手机内是否存在
    NSDictionary *dic = [NSDictionary dictionary];//主要防止下面option传入nil报警告，后续可以传入参数
    
    if (appIsExist) {//装了
        NSString *encodedMsg = [msg URLEncodedString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@canshu?%@", appUrl, encodedMsg]] options:dic completionHandler:^(BOOL success) {
            NSLog(@"嘿，我打开过了");
        }];
    }else{//没装
        NSLog(@"没安装");
    }
    
    return [msg stringByAppendingString:@"[ syn call]"];
}

- (void) testAsyn:(NSString *) msg :(JSCallback) completionHandler
{
    completionHandler([msg stringByAppendingString:@" [ asyn call]"],YES);
}

- (NSString *)testNoArgSyn:(NSDictionary *) args
{
    return  @"testNoArgSyn called [ syn call]";
}

- ( void )testNoArgAsyn:(NSDictionary *) args :(JSCallback)completionHandler
{
    completionHandler(@"testNoArgAsyn called [ asyn call]",YES);
}

- ( void )callProgress:(NSDictionary *) args :(JSCallback)completionHandler
{
    value=10;
    hanlder=completionHandler;
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)onTimer:t{
    if(value!=-1){
        hanlder([NSNumber numberWithInt:value--],NO);
    }else{
        hanlder(0,YES);
        [timer invalidate];
    }
}

/**
 * Note: This method is for Fly.js
 * In browser, Ajax requests are sent by browser, but Fly can
 * redirect requests to native, more about Fly see  https://github.com/wendux/fly
 * @param requestInfo passed by fly.js, more detail reference https://wendux.github.io/dist/#/doc/flyio-en/native
 */
-(void)onAjaxRequest:(NSDictionary *) requestInfo  :(JSCallback)completionHandler{
   
}
@end
