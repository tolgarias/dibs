//
//  SimpleTableCell.h
//  dibs
//
//  Created by Tolga Saglam on 4/17/13.
//
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;


@end
