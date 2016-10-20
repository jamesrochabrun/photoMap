//
//  DetailViewController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIView *backgroundView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *tipButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_backgroundView];
    
    _centerView = [UIView new];
    _centerView.backgroundColor = [UIColor grayColor];
    _centerView.layer.cornerRadius = 10;
    [self.view addSubview:_centerView];
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_centerView addSubview:_imageView];
    
    [PhotoController imageForPhoto:_photoDict size:@"300x300" completion:^(UIImage *image) {
        _imageView.image = image;
    }];
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_backgroundView addGestureRecognizer:dismiss];

}

- (void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];    
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
    frame.size.width = _backgroundView.frame.size.width *0.7;
    frame.size.height = 300;
    frame.origin.x = (_backgroundView.frame.size.width - frame.size.width) /2;
    frame.origin.y = 100;
    _centerView.frame = frame;
    
    frame = _imageView.frame;
    frame.size.height = _centerView.frame.size.height - 100;
    frame.size.width = _centerView.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _imageView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
