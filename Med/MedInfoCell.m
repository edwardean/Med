//
//  MedInfoCell.m
//  masterDemo
//
//  Created by Edward on 13-3-12.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "MedInfoCell.h"

@implementation MedInfoCell
@synthesize NameStr,SpecifiStr,CountStr,PYMStr;
@synthesize NameLabel,SpecifiLabel,CountLabel,PYMLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setNameStr:(NSString *)Str {
    
    if (![Str isEqualToString:NameStr]) {
        [NameStr release];
        NameStr = [Str copy];
        self.NameLabel.text = NameStr;
    }
}
- (void) setSpecifiStr:(NSString *)Str {
    if (![Str isEqualToString:SpecifiStr]) {
        [SpecifiStr release];
        SpecifiStr = [Str copy];
        self.SpecifiLabel.text = SpecifiStr;
    }
}
- (void) setPYMStr:(NSString *)PYM {
    if (![PYM isEqualToString:PYMStr]) {
        [PYMStr release];
        PYMStr = [PYM copy];
        self.PYMLabel.text = PYMStr;
    }
}
- (void) setCountStr:(NSString *)Str {
    if (![Str isEqualToString:CountStr]) {
        [CountStr release];
        CountStr = [Str copy];
        self.CountLabel.text = CountStr;
    }
}
@end
