//
//  RecordDetail.h
//  Med
//
//  Created by Edward on 13-3-24.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetail : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_table;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, copy) NSString *patient;
- (id) initWithFrame:(CGRect)frame andArray:(NSArray *)array andPatientName:(NSString *)patientname;
@end
