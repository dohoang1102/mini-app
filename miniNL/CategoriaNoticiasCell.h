//
//  CategoriaNoticiasCell.h
//  Mini Colombia
//
//  Created by German Villegas on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriaNoticiasCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * lbFecha;
@property (nonatomic, weak) IBOutlet UILabel * lbTitulo;
@property (nonatomic, weak) IBOutlet UITextView * txtResumen;
@property (nonatomic, weak) IBOutlet UIImageView * thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIImageView * fondoImageView;

@end
