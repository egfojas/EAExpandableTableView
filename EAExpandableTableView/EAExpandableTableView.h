//
//  EAExpandableTableView.h
//  EAExpandableTableView
//
//  Created by Edgar Allan Fojas on 8/14/14.
//  Copyright (c) 2014 Edgar Allan Fojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EAExpandableTableViewDataSource <NSObject>

@required
- (NSArray *)dataForTableView;
- (UITableViewCell *)tableView:(UITableView *)tableView subItemCellForIndex:(NSInteger)subItemIndex withItemIndex:(NSInteger)itemIndex inSection:(NSInteger)sectionIndex;
- (UITableViewCell *)tableView:(UITableView *)tableView itemCellForIndex:(NSInteger)itemIndex inSection:(NSInteger)sectionIndex;

@optional
- (NSInteger)numberOfSections;

@end

@protocol EAExpandableTableViewDelegate <NSObject>

@optional
- (void *)tableView:tableView didSelectSubItemAtIndex:(NSInteger)subitemIndex itemIndex:(NSInteger)parentIndex inSection:(NSInteger)section;
- (void *)tableView:tableView didSelectItemIndexAtIndex:(NSInteger)index inSection:(NSInteger)section;

@end

@interface EAExpandableTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id<EAExpandableTableViewDelegate> expandableTableViewDelegate;
@property(nonatomic, weak) id<EAExpandableTableViewDataSource> expandableTableViewDatasource;

@end
