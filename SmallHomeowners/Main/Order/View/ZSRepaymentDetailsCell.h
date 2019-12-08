#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSRepaymentDetailsCell : UITableViewCell

/// 当前期数
@property (nonatomic, strong) NSString *curLimit;

/// 应还款日期
@property (nonatomic, strong) NSString *repayMonthDate;

/// 担保代还
@property (nonatomic, strong) NSString *repayGuaranteeFee;

/// 担保已还
@property (nonatomic, strong) NSString *repaidGuaranteeFee;

/// 银行代还
@property (nonatomic,strong) NSString *repayMonthAmount;

/// 银行已还
@property (nonatomic, strong) NSString *repaidMonthAmount;

@end

NS_ASSUME_NONNULL_END
