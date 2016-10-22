//
//  DetailViewController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"
#import "MainCVController.h"
#import "VenueObject.h"
#import "Common.h"

@interface DetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIView *backgroundView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *tipButton;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_backgroundView];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_backgroundView addGestureRecognizer:dismiss];
    
    _centerView = [UIView new];
    _centerView.backgroundColor = [UIColor grayColor];
    _centerView.layer.cornerRadius = 10;
    _centerView.clipsToBounds = YES;
    [self.view addSubview:_centerView];
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_centerView addSubview:_imageView];
    
    _tipButton = [UIButton new];
    _tipButton.backgroundColor = [UIColor whiteColor];
    [_tipButton addTarget:self action:@selector(presentTipView) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_tipButton];
    
    [PhotoController imageForPhoto:_venue size:@"300x300" completion:^(UIImage *image) {
        _imageView.image = image;
    }];
    
    _textView = [UITextView new];
    _textView.layer.cornerRadius = 10;
    _textView.hidden = YES;
    _textView.alpha = 0;
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer *dismissTipView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTipView)];
    [_textView addGestureRecognizer:dismissTipView];
    [_centerView addSubview:_textView];
    
    [self downloadTips];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.75 animations:^{
        self.view.transform = CGAffineTransformMakeScale(.01, .01);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
//
    //if we ad a swipe gesture to the view we can call this
//    [UIView animateWithDuration:.75 animations:^{
//        //400 points to the right 0 to up o down
//        self.view.transform = CGAffineTransformMakeTranslation(400, 0);
//    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//    }];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGRect frame = _backgroundView.frame;
    frame.size.height = self.view.frame.size.height;
    frame.size.width = self.view.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _backgroundView.frame = frame;
    
    frame = _centerView.frame;
    frame.size.width = _backgroundView.frame.size.width * 0.7;
    frame.size.height = 400;
    frame.origin.x = (_backgroundView.frame.size.width - frame.size.width) / 2;
    frame.origin.y = 100;
    _centerView.frame = frame;
    
    frame = _imageView.frame;
    frame.size.height = _centerView.frame.size.height - 70;
    frame.size.width = _centerView.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _imageView.frame = frame;
    
    frame = _tipButton.frame;
    frame.size.height = 40;
    frame.size.width = 40;
    frame.origin.x = CGRectGetMaxX(_imageView.frame) - 50;
    frame.origin.y = CGRectGetMaxY(_imageView.frame) + 10;
    _tipButton.frame= frame;
    
    frame = _textView.frame;
    frame.size.height = height(_centerView);
    frame.size.width = width(_centerView);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _textView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadTips {
    
    //getting the venue ID
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accesToKEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    NSString *urlString= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/tips/?oauth_token=%@&v=%@&m=%@", _venue.venueID, accesToKEN, DATA_VERSION_DATE, DATA_FORMAT];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //create an array of text tips
        NSArray *tipsArray = [responseDict valueForKeyPath:@"response.tips.items.text"];
        self.tipString = [self formatTips:tipsArray];
    }];
    
    [task resume];
}

- (NSString *)formatTips:(NSArray *)tips {
    
    NSMutableString *tipString = [[NSMutableString alloc] initWithString:@"Tips:\n\n"];
    
    for (NSString *tip in tips) {
        [tipString appendString:[NSString stringWithFormat:@"*%@\n\n", tip]];
    }
    return (NSString *)tipString;
}


- (void)presentTipView {
    
    _textView.text = self.tipString;
    [UIView animateWithDuration:.5 animations:^{
        _textView.hidden = NO;
        _textView.alpha = 1;
    }];
}

- (void)dismissTipView {
    
    [UIView animateWithDuration:.5 animations:^{
        self.textView.alpha = 0;
    } completion:^(BOOL finished) {
        _textView.hidden = YES;
 }];
    
    [UIView animateWithDuration:.5 animations:^{
        
    }];
}



@end
