#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZSRepaymentRepayment;
@class ZSRepaymentOveriew;

@interface ZSRepaymentDetailModel : NSObject

@property (nonatomic, strong) NSArray<ZSRepaymentRepayment *> *repayment;

@property (nonatomic, strong) ZSRepaymentOveriew *repaymentOveriew;

@end

@interface ZSRepaymentRepayment : NSObject

@property (nonatomic, strong) NSString *tid;

@property (nonatomic ,strong) NSString *seralNo;

@property (nonatomic, strong) NSString *custId;

@property (nonatomic, strong) NSString *custName;

@property (nonatomic, assign) NSInteger limits;

@property (nonatomic, assign) NSInteger curLimit;

@property (nonatomic, strong) NSString *repayMonthDate;

@property (nonatomic, assign) NSInteger repayMonthAmount;

@property (nonatomic, strong) NSString *repaidMonthDate;

@property (nonatomic, assign) NSInteger repaidMonthAmount;

@property (nonatomic, assign) NSInteger planStatus;

@property (nonatomic, assign) NSInteger overdueAmount;

@property (nonatomic, assign) NSInteger overdueAmountPaid;

@property (nonatomic, assign) NSInteger advanceMonthAmount;

@property (nonatomic, strong) NSString *advanceMonthDate;

@property (nonatomic, assign) NSInteger advanceReceiveAmount;

@property (nonatomic, strong) NSString *advanceReceiveDate;

@property (nonatomic, assign) NSInteger advanceInterest;

@property (nonatomic, assign) NSInteger advanceRepaidInterest;

@property (nonatomic, assign) NSInteger repayGuaranteeFee;

@property (nonatomic, assign) NSInteger repaidGuaranteeFee;

@property (nonatomic, strong) NSString *repaidGuaranteeDate;

@property (nonatomic, assign) NSInteger guaranteePenalties;

@property (nonatomic, assign) NSInteger repaidGuaranteePenalties;

@property (nonatomic, assign) NSInteger settleType;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *updateBy;

@property (nonatomic, strong) NSString *updator;

@property (nonatomic, strong) NSString *updateDate;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, assign) NSInteger version;

@property (nonatomic, assign) NSInteger state;

@end



@interface ZSRepaymentOveriew : NSObject

@property (nonatomic, assign) NSInteger loanRate;

@property (nonatomic, assign) NSInteger guaranteeRate;

@property (nonatomic, assign) NSInteger repayDay;

@property (nonatomic, strong) NSString *tid;

@property (nonatomic, strong) NSString *serialNo;

@property (nonatomic, strong) NSString *custTid;

@property (nonatomic, strong) NSString *custName;

@property (nonatomic, assign) NSInteger loanLimits;

@property (nonatomic, assign) NSInteger loanAmount;

@property (nonatomic, assign) NSInteger totalAmount;

@property (nonatomic, assign) NSInteger monthPay;

@property (nonatomic, assign) NSInteger guaranteeFee;

@property (nonatomic, assign) NSInteger monthRepayAmount;

@property (nonatomic, assign) NSInteger monthRepayAmountLast;

@property (nonatomic, assign) NSInteger monthRepayGuarantee;

@property (nonatomic, assign) NSInteger guaranteeLimits;

@property (nonatomic, assign) NSInteger guaranteeLimitsPaid;

@property (nonatomic, assign) NSInteger curRepayLimit;

@property (nonatomic, assign) NSInteger curRepaidLimit;

@property (nonatomic, assign) NSInteger totalRepaidAmount;

@property (nonatomic, assign) NSInteger totalRepayAmount;

@property (nonatomic, assign) NSInteger totalRepaidGuarantee;

@property (nonatomic, assign) NSInteger totalRepayGuarantee;

@property (nonatomic, assign) NSInteger overdueAmount;

@property (nonatomic, assign) NSInteger overdueDays;

@property (nonatomic, assign) NSInteger overdueGuaranteeFee;

@property (nonatomic, assign) NSInteger reimbursedDays;

@property (nonatomic, assign) NSInteger reimbursedAmount;

@property (nonatomic, assign) NSInteger reimbursedInterest;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *createBy;

@property (nonatomic, strong) NSString *updateDate;

@property (nonatomic, strong) NSString *updateBy;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger version;

@end

NS_ASSUME_NONNULL_END
