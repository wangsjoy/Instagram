//
//  DetailsViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set caption
    self.captionLabel.text = self.post.caption;
    
    //date created
    NSDate *createdAt = self.post.createdAt;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"E MMM d HH:mm:ss Z y";
//    dd/MM/yyyy
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [dateFormatter stringFromDate:createdAt];
//    self.timeLabel.text = dateString;
    
    self.timeLabel.text = createdAt.timeAgoSinceNow;

    //set image
    NSString *URLString = self.post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
    self.photoImageView.image = nil;
    [self.photoImageView setImageWithURL:url];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
