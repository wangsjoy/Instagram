//
//  ComposeViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/6/21.
//

#import "ComposeViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"
#import "SceneDelegate.h"
#import "HomeFeedViewController.h"


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
    
    //add gesture recognition to the imageView element
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Photo"
                                                                               message:@"Choose photo from camera roll or take photo"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create a take photo action
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
        //take photo if camera available, otherwise use photo library
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }];
    // add the cancel action to the alertController
    [alert addAction:takePhotoAction];

    // create a choose photo from photo library action
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
        //choose photo from photo library
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:photoLibraryAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (IBAction)onBackTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Back to Home Timeline");
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
                
                //note: cannot just dismiss View Controller since this would not allow for the user post to load into home timeline
                SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeFeedViewController *homeFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeedViewController"];
                myDelegate.window.rootViewController = homeFeedViewController;
                NSLog(@"Successfully returned to home feed!");//dismiss last view controller
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
