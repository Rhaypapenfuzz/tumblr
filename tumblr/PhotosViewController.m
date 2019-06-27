//
//  PhotosViewController.m
//  tumblr
//
//  Created by rhaypapenfuzz on 6/27/19.
//  Copyright © 2019 rhaypapenfuzz. All rights reserved.
//

#import "PhotosViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CustomTableViewCell.h"

@interface PhotosViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *photoURLs;
@property (strong, nonatomic) NSMutableArray *photoNames;
@property (strong, nonatomic) NSMutableArray *photoHeights;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoURLs = [[NSMutableArray alloc] init];
    self.photoNames = [[NSMutableArray alloc] init];
    self.photoHeights = [[NSMutableArray alloc] init];

    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
//            NSLog(@"%@", dataDictionary);
            for (NSDictionary *post in dataDictionary[@"response"][@"posts"]) {
                [self.photoURLs addObject: post[@"photos"][0][@"original_size"][@"url"]];
                [self.photoNames addObject: post[@"summary"]];
                [self.photoHeights addObject: [NSNumber numberWithDouble: [post[@"photos"][0][@"original_size"][@"height"] doubleValue]]];

            }
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.PhotoImageView.image = nil;
    int row = indexPath.row;
    NSURL *imageURL = [[NSURL alloc] initWithString: self.photoURLs[row]];
    [cell.PhotoImageView setImageWithURL:imageURL];
    cell.titleLabel.text = self.photoNames[row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoURLs.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [(NSNumber *) self.photoHeights[indexPath.row] doubleValue];
    return 275.0;
}

@end
