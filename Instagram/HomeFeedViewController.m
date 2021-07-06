//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Sophia Joy Wang on 7/6/21.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"

@interface HomeFeedViewController ()

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didLogout:(id)sender {

    //clear the current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Errror:%@", error.localizedDescription);
            
        } else {
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [self performSegueWithIdentifier:@"logoutSegue" sender:self];
            [self.navigationController performSegueWithIdentifier:@"logoutSegue" sender:self];
            NSLog(@"Successfully logged out user!");//dismiss last view controller
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIStoryboard *storyboard = [self storyboard];
//            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            UIWindow *window = [UIApplication sharedApplication].delegate.window;
//            window.rootViewController = loginViewController;
            
        }
        // PFUser.current() will now be nil
                
        
    }];

}

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];

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
