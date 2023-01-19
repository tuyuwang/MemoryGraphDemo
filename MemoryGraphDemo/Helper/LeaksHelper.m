//
//  LeaksHelper.m
//  MemoryGraphDemo
//
//  Created by tuyw on 2023/1/12.
//

#import "LeaksHelper.h"
#import <objc/message.h>

@implementation SomeItem

@end

@interface LeaksHelper ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation LeaksHelper {
    dispatch_block_t _callback;
}

- (void)leak:(dispatch_block_t)callback {
    _callback = callback;
    callback();
}

- (void)addItem:(id)item {
    if (item) {
        [self.items addObject:item];
    }
}

#pragma mark - Lazy load

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end


@interface LeaksHelper (Dynamic)

@property (nonatomic, strong) NSMutableArray *dynamicItems;

@end

static NSString *const dynamicItemsKey = @"dynamicItemsKey";
@implementation LeaksHelper (Dynamic)

- (void)dynamicAddItem:(id)item {
    
    if (!self.dynamicItems) {
        self.dynamicItems = [NSMutableArray array];
    }
    
    if (item) {
        [self.dynamicItems addObject:item];
    }
}

- (NSMutableArray *)dynamicItems {
    return objc_getAssociatedObject(self, &dynamicItemsKey);
}

- (void)setDynamicItems:(NSMutableArray *)dynamicItems {
    objc_setAssociatedObject(self, &dynamicItemsKey, dynamicItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
