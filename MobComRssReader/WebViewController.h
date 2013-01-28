//
//  WebViewController.h
//  MobComRssReader
//
//  Created by Salvador Aguinaga on 9/12/12.
//  Copyright (c) 2012 Salvador Aguinaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIWebView *webView;

@end
