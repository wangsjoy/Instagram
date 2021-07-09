//
//  ProfileViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/8/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "ProfileGramCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfGram;
@property (nonatomic, strong) PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Do any additional setup after loading the view.
    
    PFUser *user = [PFUser currentUser];
    self.user = user;
    NSString *username = user.username;
    self.usernameLabel.text = username;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 0;
    
    CGFloat photosPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (photosPerLine - 1)) / photosPerLine;
    CGFloat itemHeight = itemWidth * 0.75;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //add gesture recognition to the imageView element
    UITapGestureRecognizer *fingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(onPhotoTap:)];
    [self.pictureView setUserInteractionEnabled:YES];
    [self.pictureView addGestureRecognizer:fingerTap];
    
    [self fetchGram];
    
}

- (void)fetchGram{
    //fetch 20 instagram posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query whereKey:@"likesCount" greaterThan:@100];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            NSLog(@"20 posts retrieved");
            for (Post *single_post in posts){
                NSLog(@"%@", single_post);
            }
            NSLog(@"%@", posts);
            NSLog(@"Found posts");
            self.arrayOfGram = posts;
            [self.collectionView reloadData];
//            [self.refreshControl endRefreshing]; //end refreshing

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
//        [self.refreshControl endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileGramCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileGramCell" forIndexPath:indexPath];
    
    Post *post = self.arrayOfGram[indexPath.item];
    //post photo
    NSString *URLString = post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
//    cell.photoView.image = nil;
    cell.photoView.image = nil;
    [cell.photoView setImageWithURL:url];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfGram.count;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.pictureView setImage:editedImage];
    
    //resize photo
//    CGSize size = CGSizeMake(300, 215);
//    UIImage *edited = [self resizeImage:editedImage withSize:(size)];
//    self.image = edited;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Finished Taking Photo");
}

@end
