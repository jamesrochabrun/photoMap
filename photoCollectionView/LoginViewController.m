//
//  LoginViewController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/24/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "LoginViewController.h"
#import "API.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performIfToken:)
                                                 name:@"token"
                                               object:nil];
    if ([API token]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performIfToken:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"login" sender:notification];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"token" object:nil];

}


@end
