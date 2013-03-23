//
//  MedInfoCell.h
//  masterDemo
//
//  Created by Edward on 13-3-12.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedInfoCell : UITableViewCell {
    IBOutlet UILabel *NameLabel;
    IBOutlet UILabel *SpecifiLabel;
    IBOutlet UILabel *CountLabel;
    IBOutlet UILabel *PYMLabel;
}

@property (nonatomic, retain) UILabel *NameLabel;
@property (nonatomic, retain) UILabel *SpecifiLabel;
@property (nonatomic, retain) UILabel *CountLabel;
@property (nonatomic, retain) UILabel *PYMLabel;
@property (copy, nonatomic) NSString *NameStr;
@property (copy, nonatomic) NSString *SpecifiStr;
@property (copy, nonatomic) NSString *CountStr;
@property (copy, nonatomic) NSString *PYMStr;

@end
