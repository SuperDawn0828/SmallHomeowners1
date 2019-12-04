//
//  ZSAddResourceViewController.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/8/28.
//  Copyright © 2018年 maven. All rights reserved.
//  创建订单--添加/编辑人员信息--添加资料

#import "ZSBaseViewController.h"
#import "ZSSLDataCollectionView.h"

typedef void(^PhotoUrlBlock)(NSString *photoUrl);

@interface ZSAddResourceViewController : ZSBaseViewController

@property(nonatomic,copy  )NSString                   *titleString;        //标题
@property(nonatomic,assign)ZSAddResourceDataStyle     addDataStyle;        //添加按钮格式
@property(nonatomic,strong)NSString                   *photoUrl;           //上个页面传过来的URL
@property(nonatomic,copy  )PhotoUrlBlock              phototBlock;         //回传

@end
