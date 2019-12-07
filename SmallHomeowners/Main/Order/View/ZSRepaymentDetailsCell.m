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

@end
