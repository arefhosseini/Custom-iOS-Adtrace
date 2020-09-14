//
//  ADTBackoffStrategy.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ADTBackoffStrategyType) {
    ADTLongWait = 0,
    ADTShortWait = 1,
    ADTTestWait = 2,
    ADTNoWait = 3,
    ADTNoRetry = 4
};

@interface ADTBackoffStrategy : NSObject

@property (nonatomic, assign) double minRange;

@property (nonatomic, assign) double maxRange;

@property (nonatomic, assign) NSInteger minRetries;

@property (nonatomic, assign) NSTimeInterval maxWait;

@property (nonatomic, assign) NSTimeInterval secondMultiplier;

- (id) initWithType:(ADTBackoffStrategyType)strategyType;

+ (ADTBackoffStrategy *)backoffStrategyWithType:(ADTBackoffStrategyType)strategyType;

@end