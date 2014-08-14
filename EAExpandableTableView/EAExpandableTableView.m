//
//  EAExpandableTableView.m
//  EAExpandableTableView
//
//  Created by Edgar Allan Fojas on 8/14/14.
//  Copyright (c) 2014 Edgar Allan Fojas. All rights reserved.
//

#import "EAExpandableTableView.h"

@implementation EAExpandableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)initializeTableView
{
    [self setDataSource:self];
    [self setDelegate:self];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableFooterView = footer;
}

#pragma mark - Override Setter Method

- (void)setExpandableTableViewDatasource:(id<EAExpandableTableViewDataSource>)expandableTableViewDatasource
{
    _expandableTableViewDatasource = expandableTableViewDatasource;
    [self initializeTableView];
}

#pragma mark - UITableView Delegate Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
