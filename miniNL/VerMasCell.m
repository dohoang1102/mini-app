//
//  VerMasCell.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 9/08/12.
//
//

#import "VerMasCell.h"

@implementation VerMasCell

@synthesize btnVerMas = _btnVerMas;

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

@end
