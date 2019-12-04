//
//  ZSCertificationView.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/28.
//  Copyright © 2018年 maven. All rights reserved.
//  资质认证view

#import <UIKit/UIKit.h>

#define KCerViewHeight  10 + CellHeight*3 + (ZSWIDTH-GapWidth*8)*0.63 + 10

@class ZSCertificationView;
@protocol ZSCertificationViewDelegate <NSObject>
- (void)sendCertificationData;
@end

@interface ZSCertificationView : UIView
@property (nonatomic,strong)UIImageView          *bussinessCardImage;  //名片
@property (nonatomic,strong)ZSInputOrSelectView  *companyView;         //公司
@property (nonatomic,strong)ZSInputOrSelectView  *positionView;        //职位
@property (nonatomic,copy  )NSString             *urlString;           //图片url
@property (nonatomic,assign)BOOL                 isCanUpload;          //是否可以上传照片
@property (weak, nonatomic )id<ZSCertificationViewDelegate> delegate;
@end
