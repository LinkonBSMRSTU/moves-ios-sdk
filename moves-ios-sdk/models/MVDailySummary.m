//
//  MVDailySummary.m
//  Move-iOS-SDK
//
//  Created by Vito on 13-7-11.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import "MVDailySummary.h"
#import "MVSummary.h"
#import "DFDateFormatterFactory.h"

@implementation MVDailySummary

- (MVDailySummary *)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    
    if (self && [dic isKindOfClass:[NSDictionary class]]) {
        if (!isNull(dic[@"date"])) {
            NSDateFormatter *formatter = [[DFDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyyMMdd"];
            formatter.calendar = [MVCalendarFactory calendarWithIdentifier:NSGregorianCalendar];
            _date = [formatter dateFromString:dic[@"date"]];
        }
        if (!isNull(dic[@"caloriesIdle"])) {
            _caloriesIdle = [dic[@"caloriesIdle"] integerValue];
        }
        
        if (!isNull(dic[@"lastUpdate"])) {
            NSDateFormatter *formatter = [[DFDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyyMMdd'T'HHmmssZ"];
            formatter.calendar = [MVCalendarFactory calendarWithIdentifier:NSGregorianCalendar];
            _lastUpdate = [formatter dateFromString:dic[@"lastUpdate"]];
        }
        
        if ([dic[@"summary"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *summaries = [[NSMutableArray alloc] init];
            for (NSDictionary *summary in dic[@"summary"]) {
                [summaries addObject:[[MVSummary alloc] initWithDictionary:summary]];
            }
            if (summaries.count>0) {
                _summaries = summaries;
            }
        }
    }
    
    return self;
}

- (NSInteger)dailyCalories {
    NSInteger dailyCalories = 0;
    if (self.summaries && self.summaries.count > 0) {
        for (MVSummary *summary in self.summaries) {
            dailyCalories += summary.calories;
        }
    }
    return dailyCalories;
}

@end
