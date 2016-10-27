//
//  ViewController.m
//  SXURLCache
//
//  Created by dfpo on 16/10/27.
//  Copyright © 2016年 dfpo. All rights reserved.
//

#import "ViewController.h"
#import "SXURLCache.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = @"sdfsfsdfsf";
    id data = @[@1, @2, @3];
    [[SXURLCache sharedInstance] addCacheWithUrl:urlString data:data expiryTime:8];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSString *urlString = @"sdfsfsdfsf";
    id data = [[SXURLCache sharedInstance] cacheDataWithUrl:urlString];
    if (data != nil) {
        NSLog(@"----%@---", data);
    } else {
        NSLog(@"----%@---", @"no data");

    }
}
@end
