#import "ZSRepaymentDetailsCell.h"

@interface ZSRepaymentDetailsCell ()
@property (weak, nonatomic) IBOutlet UILabel *qishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *danbaodaihuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *yinhangdaihuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *danbaoyihuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *yihangyihuanLabel;

@end

@implementation ZSRepaymentDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

/// 当前期数
- (void)setCurLimit:(NSString *)curLimit {
    _curLimit = curLimit;
    _qishuLabel.text = curLimit;
}

/// 应还款日期
- (void)setRepayMonthDate:(NSString *)repayMonthDate {
    _repayMonthDate = repayMonthDate;
    _repaymentDateLabel.text = repayMonthDate;
}

/// 担保代还
- (void)setRepayGuaranteeFee:(NSString *)repayGuaranteeFee {
    _repayGuaranteeFee = repayGuaranteeFee;
    _danbaodaihuanLabel.text =repayGuaranteeFee;
}

/// 担保已还
- (void)setRepaidGuaranteeFee:(NSString *)repaidGuaranteeFee {
    _repaidGuaranteeFee = repaidGuaranteeFee;
    _danbaoyihuanLabel.text = repaidGuaranteeFee;
}

/// 银行代还
- (void)setRepayMonthAmount:(NSString *)repayMonthAmount {
    _repayMonthAmount = repayMonthAmount;
    _yinhangdaihuanLabel.text = repayMonthAmount;
}

/// 银行已还
- (void)setRepaidMonthAmount:(NSString *)repaidMonthAmount {
    _repaidMonthAmount =repaidMonthAmount;
    _yihangyihuanLabel.text = repaidMonthAmount;
}

@end
