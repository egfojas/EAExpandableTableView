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
    self.currentItemsInTable = [[NSMutableArray alloc] init];
    for (int i=0; i<[self numberOfSectionsInTableView:self]; i++) {
        [self.currentItemsInTable insertObject:[[self itemsForTableSection:i] mutableCopy] atIndex:i];
    }
    self.originaItemsInTable = self.currentItemsInTable;
    
    [self setDataSource:self];
    [self setDelegate:self];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableFooterView = footer;
}

- (BOOL)isCellAtIndexPathASubItem:(NSIndexPath *)indexPath
{
    id item = [[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]] && [item objectForKey:@"subitems"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Expand/Collapse Methods

- (void)expandSubitemsInItemIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *subitems = [item valueForKey:@"subitems"];
    
    NSUInteger count = indexPath.row+1;
    NSMutableArray *subItemIndexPathArray = [NSMutableArray array];
    
    for (NSDictionary *subitem in subitems ) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:count inSection:indexPath.section];
        [subItemIndexPathArray addObject:newIndexPath];
        [[self.currentItemsInTable  objectAtIndex:indexPath.section] insertObject:subitem atIndex:count++];
    }
    
    [self insertRowsAtIndexPaths:subItemIndexPathArray withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)collapseSubitemsInItemIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *item = [[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *subitems = [item valueForKey:@"subitems"];
    
    for (id subitem in subitems) {
        NSUInteger indexToRemove = [[self.currentItemsInTable objectAtIndex:indexPath.section] indexOfObjectIdenticalTo:subitem];
        if ([[self.currentItemsInTable objectAtIndex:indexPath.section] indexOfObjectIdenticalTo:subitem] != NSNotFound) {
            [[self.currentItemsInTable objectAtIndex:indexPath.section] removeObjectIdenticalTo:subitem];
			[self deleteRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:indexToRemove inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - Override Setter Method

- (void)setExpandableTableViewDatasource:(id<EAExpandableTableViewDataSource>)expandableTableViewDatasource
{
    _expandableTableViewDatasource = expandableTableViewDatasource;
    [self initializeTableView];
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellAtIndexPathASubItem:indexPath]) {
        if ([self.expandableTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubItemAtIndex:itemIndex:inSection:)]) {
            id subitem = [[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            do {
                indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            } while ([self isCellAtIndexPathASubItem:indexPath]);
            
            NSDictionary *dic=[[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSInteger itemIndex= [[self.originaItemsInTable objectAtIndex:indexPath.section ] indexOfObjectIdenticalTo:dic];
            NSInteger subItemIndex = [[dic objectForKey:@"subitems"] indexOfObjectIdenticalTo:subitem];
            [self.expandableTableViewDelegate tableView:self didSelectSubItemAtIndex:subItemIndex itemIndex:itemIndex inSection:indexPath.section];
        }
    }
    else {
        NSDictionary *dic=[[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSArray *arr=[dic valueForKey:@"subitems"];
        BOOL isTableExpanded=NO;
        
        for (NSDictionary *subitems in arr ) {
            NSInteger index= [[self.currentItemsInTable objectAtIndex:indexPath.section ] indexOfObjectIdenticalTo:subitems];
            isTableExpanded = (index > 0 && index != NSIntegerMax);
            if (isTableExpanded) {
                break;
            }
        }
        
        if (isTableExpanded) {
            [self collapseSubitemsInItemIndexPath:indexPath];
        }
        else {
            [self expandSubitemsInItemIndexPath:indexPath];
        }
        
        if ([self.expandableTableViewDelegate respondsToSelector:@selector(tableView:didSelectItemIndexAtIndex:inSection:)]) {
            NSInteger index = 0;
            NSArray *itemsInSection = [self.originaItemsInTable objectAtIndex:indexPath.section];
            index = [itemsInSection indexOfObjectIdenticalTo:dic];
            [self.expandableTableViewDelegate tableView:self didSelectItemIndexAtIndex:index inSection:indexPath.section];
        }
    }
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.expandableTableViewDatasource respondsToSelector:@selector(numberOfSections)]) {
        return [self.expandableTableViewDatasource numberOfSections];
    }
    
    return [[self.expandableTableViewDatasource dataForTableView] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentItemsInTable objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellAtIndexPathASubItem:indexPath]) {
        id subitem = [[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        do {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        } while ([self isCellAtIndexPathASubItem:indexPath]);
        
        NSDictionary *dic=[[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSInteger itemIndex= [[self.originaItemsInTable objectAtIndex:indexPath.section ] indexOfObjectIdenticalTo:dic];
        NSInteger subItemIndex = [[dic objectForKey:@"subitems"] indexOfObjectIdenticalTo:subitem];
        
        return [self.expandableTableViewDatasource tableView:self subItemCellForIndex:subItemIndex withItemIndex:itemIndex inSection:indexPath.section];
    }
    else {
        NSDictionary *dic=[[self.currentItemsInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSInteger index= [[self.originaItemsInTable objectAtIndex:indexPath.section ] indexOfObjectIdenticalTo:dic];
        return [self.expandableTableViewDatasource tableView:self itemCellForIndex:index inSection:indexPath.section];
    }
}

@end
