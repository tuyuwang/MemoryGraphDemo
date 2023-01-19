//
//  SceneTableViewController.m
//  MemoryGraphDemo
//
//  Created by tuyw on 2023/1/11.
//

#import "SceneTableViewController.h"
#import "LeaksHelper.h"
@import SDWebImage;

@interface SceneModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selector;

@end

@implementation SceneModel
+ (SceneModel *)createWithTitle:(NSString *)title selector:(NSString *)selector {
    SceneModel *model = [SceneModel new];
    model.title = title;
    model.selector = selector;
    return model;
}
@end

@interface SceneTableViewController ()

@property (nonatomic, copy) NSArray<SceneModel *> *dataSource;
@property (nonatomic, strong) UIImage *image;
@end

@implementation SceneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selector = self.dataSource[indexPath.row].selector;
    SEL sel = NSSelectorFromString(selector);
    if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
    }
}

#pragma mark - Actions

- (void)trigerRetainCycles {
    LeaksHelper *helper = [LeaksHelper new];
    [helper leak:^{
        NSLog(@"%@", helper);
    }];
}

- (void)trigerIndirectRetainCycles {
    //A -> array<item>, item -> A
    LeaksHelper *helper = [LeaksHelper new];
    SomeItem *item = [SomeItem new];
    [helper addItem:item];
    
    item.helper = helper;
}

- (void)trigerDynamicIndirectRetainCycles {
    //A -> array<item>, item -> A
    LeaksHelper *helper = [LeaksHelper new];
    SomeItem *item = [SomeItem new];
    [helper dynamicAddItem:item];
    
    item.helper = helper;
}

- (void)trigerNoActiveReferences {
    @try {
        NSString *test = @"test";
        NSString *result = @[test][3];
        NSLog(@"%@", result);
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)trigerLargeBuffers {
    UIImageView *imageView = [UIImageView new];
    NSString *url = @"https://img.zcool.cn/community/01z8xppxo2g1rcrfmjuwda3432.jpg";
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];

    //    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageAvoidDecodeImage];
}

#pragma mark - Lazy load

- (NSArray<SceneModel *> *)dataSource {
    if (!_dataSource) {
        NSArray<NSDictionary<NSString *, NSString *> *> *dataSource = @[
        @{@"Retain Cycles":@"trigerRetainCycles"},
        @{@"No Active References":@"trigerNoActiveReferences"},
        @{@"Indirect Retain Cycles":@"trigerIndirectRetainCycles"},
        @{@"Dynamic Indirect Retain Cycles":@"trigerDynamicIndirectRetainCycles"},
        @{@"Large Buffers":@"trigerLargeBuffers"}];
        
        NSMutableArray *mutableDataSource = [NSMutableArray array];
        
        [dataSource enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [mutableDataSource addObject:[SceneModel createWithTitle:key selector:obj]];
            }];
        }];
        
        _dataSource = mutableDataSource.copy;
    }
    return _dataSource;
}

@end
