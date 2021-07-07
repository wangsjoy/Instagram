//
//  ComposeViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/6/21.
//

#import "ComposeViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UITextView *captionView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add gesture recognition to the trailerView element
    UITapGestureRecognizer *fingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(onPhotoTap:)];
    [self.photoView setUserInteractionEnabled:YES];
    [self.photoView addGestureRecognizer:fingerTap];
    
}

//The event handling method for when photoView element is pressed
- (void)onPhotoTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Photo Tapped");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.photoView setImage:editedImage];
    
    //resize photo
    CGSize size = CGSizeMake(300, 215);
    UIImage *edited = [self resizeImage:editedImage withSize:(size)];
    self.image = edited;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Finished Taking Photo");
}

- (IBAction)didTapShare:(id)sender {
    if ((self.photoView != nil) && (![self.captionView.text isEqualToString:@""])){
        //can post
        
        [Post postUserImage:self.image withCaption:self.captionView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error){
                NSLog(@"Error");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"Successfully posted");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
    } else{
        //don't post
        NSLog(@"Can't post because empty");
    }
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
