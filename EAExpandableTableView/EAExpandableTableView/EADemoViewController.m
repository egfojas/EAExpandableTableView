//
//  EADemoViewController.m
//  EAExpandableTableView
//
//  Created by Edgar Allan Fojas on 8/14/14.
//  Copyright (c) 2014 Edgar Allan Fojas. All rights reserved.
//

#import "EADemoViewController.h"

@interface EADemoViewController ()

@property (nonatomic, strong) EAExpandableTableView *tableView;
@property (nonatomic, strong) NSArray *dataForTable;
@end

@implementation EADemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataForTable = @[@[@{@"title": @"main1-1", @"subitems":@[@"1-1-1", @"1-1-2"]}, @{@"title": @"main1-2", @"subitems":@[@"1-2-1"]}], @[@{@"title":@"main2-1", @"subitems":@[@"2-1-1"]}]];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[EAExpandableTableView alloc] initWithFrame:self.view.frame];
    self.tableView.expandableTableViewDatasource = self;
    self.tableView.expandableTableViewDelegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
}

- (NSInteger)numberOfSections
{
    return [self.dataForTable count];
}

- (NSArray *)dataForTableView
{
    return self.dataForTable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView itemCellForIndex:(NSInteger)itemIndex inSection:(NSInteger)sectionIndex
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView subItemCellForIndex:(NSInteger)subItemIndex withItemIndex:(NSInteger)itemIndex inSection:(NSInteger)sectionIndex
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.contentView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)tableView:(id)tableView didSelectItemIndexAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    NSLog(@"item = %@", [[[self.dataForTable objectAtIndex:section] objectAtIndex:index] objectForKey:@"title"]);
}

- (void)tableView:(id)tableView didSelectSubItemAtIndex:(NSInteger)subitemIndex itemIndex:(NSInteger)itemIndex inSection:(NSInteger)section
{
    NSLog(@"subitem = %@", [[[[self.dataForTable objectAtIndex:section] objectAtIndex:itemIndex] objectForKey:@"subitems"] objectAtIndex:subitemIndex]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
