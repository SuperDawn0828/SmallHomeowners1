//
//  ZSHomeNewsModel.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSHomeNewsModel : NSObject
@property(nonatomic,copy)NSString *tid;
@property(nonatomic,copy)NSString *listPic;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *detailHref;
@property(nonatomic,copy)NSString *pubTime;
@property(nonatomic,copy)NSString *createBy;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *content;
@end
