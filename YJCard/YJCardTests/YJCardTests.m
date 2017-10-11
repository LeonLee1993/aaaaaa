//
//  YJCardTests.m
//  YJCardTests
//
//  Created by 李颜成 on 2017/6/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HomePageViewController.h"
#import "ResetCodeWithCertifyViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface YJCardTests : XCTestCase

@end

@implementation YJCardTests{
    HomePageViewController *homePage;
    ResetCodeWithCertifyViewController *reset;
    LoginViewController *login;
    AppDelegate *delegate;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    homePage = [[HomePageViewController alloc]init];
    reset = [[ResetCodeWithCertifyViewController alloc]init];
    login = [[LoginViewController alloc]init];
    delegate.window.rootViewController = reset;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [login requestCode];
//    homePage = [[HomePageViewController alloc]init];
//    reset = [[ResetCodeWithCertifyViewController alloc]init];
//    delegate.window.rootViewController = reset;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [homePage setupTableView];
    }];
}

@end
