//
//  VideoViewController.m
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [self.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
    // Do any additional setup after loading the view.
}

-(IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}
-(IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
