//
//  DQNetWorkTool.m
//  DQCommonTool
//
//  Created by dengqi on 2018/8/3.
//  Copyright © 2018年 XXX. All rights reserved.
//

#import "DQNetWorkTool.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation DQNetWorkTool

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static  DQNetWorkTool *tool = nil;
    dispatch_once(&onceToken, ^{
      tool = [DQNetWorkTool new];
    });
    return tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.netWorkModel = [DQNetWorkModel new];
    }
    return self;
}

#pragma mark -开始网络监测
- (void)startNetWork {
    
    __weak typeof(self) weakSelf = self;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    // Set the blocks 有网的回调
    reach.reachableBlock = ^(Reachability *reach)
    {
        [weakSelf getNetWorkStatusFunction:[reach currentReachabilityStatus]];
    };
    
    //无网络的回调
    reach.unreachableBlock = ^(Reachability *reach)
    {
        self.netWorkModel.netWorkStyle = notNetWork;
        self.netWorkModel.isNetWork = NO;
        self.netWorkModel.networkName = @"no network";
        self.netWorkModel.netWorkStyleName = @"no network";
        DQNetWorkModel *model = self.netWorkModel;
        self.netWorkResult(model);
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
}

#pragma mark -有网络状态的处理
- (void)getNetWorkStatusFunction:(NetworkStatus )status {
    self.netWorkModel.isNetWork = YES;//有网
    if (status == ReachableViaWiFi) {
        self.netWorkModel.netWorkStyle = wifiNetWork;
        self.netWorkModel.networkName = @"WiFi";
        self.netWorkModel.netWorkStyleName = @"WiFi";
    } else {
        CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
        CTCarrier *carrier = info.subscriberCellularProvider;
        self.netWorkModel.networkName = carrier.carrierName;
        
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                                   CTRadioAccessTechnologyGPRS,
                                   CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                                   CTRadioAccessTechnologyWCDMA,
                                   CTRadioAccessTechnologyHSUPA,
                                   CTRadioAccessTechnologyCDMAEVDORev0,
                                   CTRadioAccessTechnologyCDMAEVDORevA,
                                   CTRadioAccessTechnologyCDMAEVDORevB,
                                   CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
        NSString *accessString = info.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            self.netWorkModel.netWorkStyle = fourGNetWork;
            self.netWorkModel.netWorkStyleName = @"4G";
        } else if ([typeStrings3G containsObject:accessString]) {
            self.netWorkModel.netWorkStyle = threeGNetWork;
            self.netWorkModel.netWorkStyleName = @"3G";
        } else if ([typeStrings2G containsObject:accessString]) {
            self.netWorkModel.netWorkStyle = threeGNetWork;
            self.netWorkModel.netWorkStyleName = @"2G";
        } else {
            self.netWorkModel.netWorkStyle = unknown;
            self.netWorkModel.netWorkStyleName = @"未知";
        }
    }
    DQNetWorkModel *model = self.netWorkModel;
    self.netWorkResult(model);
}

@end

@implementation DQNetWorkModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.isNetWork = NO;//默认无网
        
        self.networkName = @"no network";
        
        self.netWorkStyle = notNetWork;//未知类型
        
        self.netWorkStyleName = @"no network";
        
    }
    return self;
    
}

@end
