#import "ZSIdentityAuthentionCell.h"

@implementation ZSIdentityAuthentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.frame = CGRectMake(15,0,80,44);
        self.leftLabel.numberOfLines = 0;
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self.contentView addSubview:self.leftLabel];

        self.textField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 215, 0, 200, 44)];
        self.textField.font = [UIFont systemFontOfSize:15];
        self.textField.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.borderStyle = UITextBorderStyleNone;
        [self.contentView addSubview:self.textField];
    }
    return self;
}

@end
