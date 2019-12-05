#import "ZSHomeApplyFooterView.h"

@interface ZSHomeApplyFooterView ()

@end

@implementation ZSHomeApplyFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(39.5,0,95,31);
        label.text = @"小房主法律条款";
        label.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
    }
    return self;
}

@end
