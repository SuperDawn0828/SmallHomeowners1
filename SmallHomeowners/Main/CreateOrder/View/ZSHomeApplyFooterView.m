#import "ZSHomeApplyFooterView.h"

@interface ZSHomeApplyFooterView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *clickButton;

@end

@implementation ZSHomeApplyFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(15,8.5,14,14);
        self.imageView.image = [UIImage imageNamed:@"duigou_buxuanzhong_icon"];
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.frame = CGRectMake(39.5,0,95,31);
        self.textLabel.text = @"小房主法律条款";
        self.textLabel.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.textLabel];
        
        self.clickButton = [[UIButton alloc] init];
        self.clickButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self.clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clickButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15,8.5,14,14);
    self.textLabel.frame = CGRectMake(39.5,0,95,31);
    self.clickButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.imageView.image = [UIImage imageNamed:@"duigou_xuanzhong_icon"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"duigou_buxuanzhong_icon"];
    }
}

- (void)clickButtonAction:(UIButton *)sender {
    self.selected = !self.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeApplyFooterViewDidSelected:)]) {
        [self.delegate homeApplyFooterViewDidSelected:self];
    }
}

@end
