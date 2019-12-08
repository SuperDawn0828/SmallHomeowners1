#import "ZSOrderDeatilPhotoCell.h"
#import "ZSOrderDetailPhotoItem.h"

@interface ZSOrderDeatilPhotoCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<NSString *> *list;

@end

@implementation ZSOrderDeatilPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(119, 78.5);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 109) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[ZSOrderDetailPhotoItem class] forCellWithReuseIdentifier:@"ZSOrderDetailPhotoItem"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.list[indexPath.row];
    ZSOrderDetailPhotoItem *cell = (ZSOrderDetailPhotoItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZSOrderDetailPhotoItem" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,string]] placeholderImage:defaultImage_rectangle];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSOrderDeatilPhotoCell *cell = (ZSOrderDeatilPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = cell.imageView;
    if (imageView.image) {
        //1.创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        //2.赋值
        if (self.list.count > 0) {
            NSMutableArray<NSString *> *urlList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSString *element in self.list) {
                [urlList addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl, element]];
            }
            photoBroseView.imagesURL = urlList;
        }
        else {
            photoBroseView.images = @[defaultImage_rectangle];
        }
        photoBroseView.showFromView = cell;
        photoBroseView.hiddenToView = cell;
        photoBroseView.currentIndex = indexPath.row;
        //3.显示
        [photoBroseView show];
    }
}

- (void)setUrlStrings:(NSString *)urlStrings {
    _urlStrings = urlStrings;
    NSArray<NSString *> *list = [urlStrings componentsSeparatedByString:@","];
    self.list = list;
    [self.collectionView reloadData];
}

@end
