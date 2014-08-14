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

@optional
- (NSInteger)numberOfSections;

@end

@protocol EAExpandableTableViewDelegate <NSObject>

@end

@interface EAExpandableTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@end
