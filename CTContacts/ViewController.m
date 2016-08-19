//
//  ViewController.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/8.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "ViewController.h"
#import "ContactsViewController.h"
#import "CTFBContact.h"
#import "CTGoogleContact.h"
#import "CTAddressBook.h"

#import "CTGoogleSignIn.h"

@interface ViewController () <GIDSignInUIDelegate, GIDSignInDelegate>

@property (nonatomic, weak) IBOutlet UIButton *friendButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GIDSignInUIDelegate
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    if (error == nil) {
        
    }
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        NSObject<CTContactsProtocol> *contacts = [[CTGoogleContact alloc] initWithSignIn:signIn];
        [contacts getWithAfterToken:@"" completionHandler:^(id result, NSString *afterToken, NSError *error) {
            [self performSegueWithIdentifier:@"ContactsSegue" sender:result];
        }];
    }
    else {
        
    }
}

- (IBAction)friendButtonAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請選擇" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *fbAction = [UIAlertAction actionWithTitle:@"FB" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
            NSObject<CTContactsProtocol> *contacts = [[CTFBContact alloc] initWithSignIn:[FBSDKAccessToken currentAccessToken]];
            [contacts getWithAfterToken:@"" completionHandler:^(id result, NSString *afterToken, NSError *error) {
                [self performSegueWithIdentifier:@"ContactsSegue" sender:result];
            }];
        }
        else {
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logInWithReadPermissions:@[@"user_friends", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error == nil) {
                    NSObject<CTContactsProtocol> *contacts = [[CTFBContact alloc] initWithSignIn:[FBSDKAccessToken currentAccessToken]];
                    [contacts getWithAfterToken:@"" completionHandler:^(id result, NSString *afterToken, NSError *error) {
                        [self performSegueWithIdentifier:@"ContactsSegue" sender:result];
                    }];
                }
            }];
        }
    }];
    
    UIAlertAction *googleAction = [UIAlertAction actionWithTitle:@"Google" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate = self;
        [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/contacts.readonly",
                             @"https://www.google.com/m8/feeds/"]];
        [[GIDSignIn sharedInstance] signIn];
    }];
    
    UIAlertAction *addressAction = [UIAlertAction actionWithTitle:@"Address" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSObject<CTContactsProtocol> *contacts = [[CTAddressBook alloc] initWithSignIn:[CTAddressBookManager manager]];
        [contacts getWithAfterToken:@"" completionHandler:^(id result, NSString *afterToken, NSError *error) {
            [self performSegueWithIdentifier:@"ContactsSegue" sender:result];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:fbAction];
    [alertController addAction:googleAction];
    [alertController addAction:addressAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ContactsViewController *viewController = [segue destinationViewController];
    [viewController setDataSource:sender];
}

@end
