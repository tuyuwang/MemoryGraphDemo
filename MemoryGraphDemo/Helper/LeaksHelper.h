//
//  LeaksHelper.h
//  MemoryGraphDemo
//
//  Created by tuyw on 2023/1/12.
//

#import <Foundation/Foundation.h>

@class LeaksHelper;

NS_ASSUME_NONNULL_BEGIN

@interface SomeItem : NSObject

@property (nonatomic, strong) LeaksHelper *helper;

@end

@interface LeaksHelper : NSObject

- (void)leak:(dispatch_block_t)callback;

- (void)addItem:(id)item;

@end

@interface LeaksHelper (Dynamic)

- (void)dynamicAddItem:(id)item;

@end

NS_ASSUME_NONNULL_END
