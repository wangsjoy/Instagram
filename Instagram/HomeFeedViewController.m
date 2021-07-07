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
#import "GramCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfGram;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchGram];
    
    //refresh controls
    self.refreshControl = [[UIRefreshControl alloc] init]; //instantiate refreshControl
    [self.refreshControl addTarget:self action:@selector(fetchGram) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //so that the refresh icon doesn't hover over any cells
    
}

- (void)fetchGram{
    //fetch 20 instagram posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query whereKey:@"likesCount" greaterThan:@100];
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
            [self.tableView reloadData];
            [self.refreshControl endRefreshing]; //end refreshing

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)didLogout:(id)sender {

    //clear the current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Errror:%@", error.localizedDescription);
            
        } else {
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.rootViewController = loginViewController;
            NSLog(@"Successfully logged out user!");//dismiss last view controller
        }
        
    }];

}

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DetailsSegue"]){
        NSLog(@"Entering Post Details");
        DetailsViewController *detailsViewController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender; //sender is just table view cell that was tapped on
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell]; //grabs index path
        Post *post = self.arrayOfGram[indexPath.row]; //right post associated with right row
        detailsViewController.post = post; //pass post to detailsViewController
    }
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GramCell"];
    Post *post = self.arrayOfGram[indexPath.row];
    NSLog(@"Post:");
    NSLog(@"%@", post.caption);
    cell.captionLabel.text = post.caption;
    
    NSString *URLString = post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
    cell.photoImageView.image = nil;
    [cell.photoImageView setImageWithURL:url];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

@end
