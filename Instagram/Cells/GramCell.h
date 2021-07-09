//
//  GramCell.h
//  Instagram
//
//  Created by Sophia Joy Wang on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
//@import Parse;
#import <Parse/Parse.h>

@interface GramCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;

@end
