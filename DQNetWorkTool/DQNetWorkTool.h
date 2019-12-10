//
//  DQNetWorkTool.h
//  DQCommonTool
//
//  Created by dengqi on 2018/8/3.
//  Copyright © 2018年 XXX. All rights reserved.
//

typedef enum {
    unknown = -1,//未知网络
    notNetWork = 0,//无网
    towGNetWork = 1,//2G网络
    threeGNetWork = 2,//3G网络
    fourGNetWork = 3,//4G网络
    wifiNetWork = 4//wifi
} DQNetWorkStatus;


#import <Foundation/Foundation.h>


@class DQNetWorkModel;

typedef void (^DQNetWorkResult)(DQNetWorkModel * model);

/**
 网络监测工具
 */
@interface DQNetWorkTool : NSObject

/**
 网络模型
 */
@property (nonatomic, strong) DQNetWorkModel *netWorkModel;

/**
 网络监测的回调
 */
@property (nonatomic, copy) DQNetWorkResult netWorkResult;

/**
 单列
 */
+ (instancetype)shareInstance;

/**
 监测网络
 */
- (void)startNetWork;

@end


/**
 自定义网络模型
 */
@interface DQNetWorkModel : NSObject

/**
 网络类型
 */
@property (nonatomic, assign) DQNetWorkStatus netWorkStyle;

/**
 自定义的名字 可不用
 */
@property (nonatomic, copy) NSString *netWorkStyleName;

/**
 网络名称(运营商) “中国移动4G”
 */
@property (nonatomic, copy) NSString *networkName;

/**
 是否有网络的状态 默认无网
 */
@property (nonatomic, assign) BOOL isNetWork;

@end
