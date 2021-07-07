//
//  DetailsViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set caption
    self.captionLabel.text = self.post.caption;
    
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
