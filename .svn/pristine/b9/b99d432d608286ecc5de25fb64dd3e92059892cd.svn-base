//
//  ZSProductListViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/25.
//  Copyright © 2018 maven. All rights reserved.
//

#import "ZSProductListViewController.h"
#import "ZSProductDetailViewController.h"
#import "ZSProductViewTableViewCell.h"

@interface ZSProductListViewController ()

@end

@implementation ZSProductListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"产品列表" withBackBtn:YES];
    [self configureTableView:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT - self.navView.height) withStyle:UITableViewStylePlain];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 15)];
    footerView.backgroundColor = ZSColorWhite;
    self.tableView.tableFooterView = footerView;
}

#pragma mark /*---------------------------------------tableView---------------------------------------*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return productsImageHeight + GapWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return global.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSProductViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (!cell) {
        cell = [[ZSProductViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    if (global.productArray.count > 0)
    {
        ZSCreateOrderPopupModel *model = global.productArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZSCreateOrderPopupModel *model = global.productArray[indexPath.row];
    global.prdType = model.prdType;
    
    ZSProductDetailViewController *detailVC = [[ZSProductDetailViewController alloc]init];
    detailVC.imageUrlString = model.detailImg;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
