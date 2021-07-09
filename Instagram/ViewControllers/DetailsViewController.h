//
//  DetailsViewController.h
//  Instagram
//
//  Created by Sophia Joy Wang on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
