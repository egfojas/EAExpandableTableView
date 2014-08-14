//
//  EAExpandableTableView.m
//  EAExpandableTableView
//
//  Created by Edgar Allan Fojas on 8/14/14.
//  Copyright (c) 2014 Edgar Allan Fojas. All rights reserved.
//

#import "EAExpandableTableView.h"

@interface EAExpandableTableView()

@property(nonatomic, strong) NSMutableArray *currentItemsInTable;
@property(nonatomic, strong) NSMutableArray *originaItemsInTable;

@end

@implementation EAExpandableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - Utility Methods

- (NSArray *)itemsForTableSection:(NSInteger)section
{
    if ([self.expandableTableViewDatasource dataForTableView]) {
        id obj = [[self.expandableTableViewDatasource dataForTableView] objectAtIndex:section];
        if (![obj isKindOfClass:[NSArray class]]) {
            return @[obj];
        }
        return obj;
    }
    
    return [[NSArray alloc] init];
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
