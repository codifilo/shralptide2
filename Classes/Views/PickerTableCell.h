//
//  PickerTableCell.h
//  ShralpTidePro
//
//  Created by Michael Parlee on 8/5/10.
//  Copyright 2010 IntelliDOT Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PickerTableCell : UITableViewCell {
    UIImageView *flagView;
    UILabel *nameLabel;
}

@property (nonatomic,retain) IBOutlet UIImageView *flagView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;

@end