//
//  FirstViewController.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/5/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
#import "BotDataManager.h"
#import "ServerDataManager.h"
#import "IntegrationCollectionViewCell.h"
#import "GradientMaskView.h"

#define STANDARD_REFRESH 60
#define ACTIVE_BUILD_REFRESH 3

@interface FirstViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIAlertAction *passwordAlertAction;

@property (nonatomic, strong) UITextField *serverAddressTextField;
@property (nonatomic, strong) UITextField *descriptionTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *osVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *osServerVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *xcodeVersionLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *serverActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *botActivityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) BotDataManager *botDataManager;
@property (nonatomic, strong) BotCollection *botCollection;

@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation FirstViewController

#pragma mark - Init / Dealloc

- (void)dealloc
{
    [self invalidateRefreshTimer];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self configurePlayButtonGesture];
    
    if ([ServerDataManager isServerConfigured])
    {
        [self getServerVersions];
        [self getBots];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    GradientMaskView *maskView = (GradientMaskView *)self.collectionView.maskView;
    
    maskView.maskPosition.end = self.topLayoutGuide.length * 0.8;
    
    CGFloat maximumMaskStart = maskView.maskPosition.end + (self.topLayoutGuide.length * 0.5);
    CGFloat verticalScrollPosition = MAX(0, self.collectionView.contentOffset.y + self.collectionView.contentInset.top);
    maskView.maskPosition.start = MIN(maximumMaskStart, maskView.maskPosition.end + verticalScrollPosition);
    
    maskView.frame = CGRectMake(0, self.collectionView.contentOffset.x,
                                self.collectionView.bounds.size.width,
                                self.collectionView.bounds.size.height);
}

#pragma mark - Properties

- (BotDataManager *)botDataManager
{
    if (!_botDataManager)
    {
        _botDataManager = [BotDataManager new];
    }
    
    return _botDataManager;
}

#pragma mark - Configuration

- (void)configureCollectionView
{
    self.collectionView.maskView = [[GradientMaskView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y,
                                                                                     self.collectionView.bounds.size.width,
                                                                                      self.collectionView.bounds.size.height)];
}

- (void)configurePlayButtonGesture
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tappedPlayPauseButton:)];
    gestureRecognizer.allowedPressTypes = @[[NSNumber numberWithInt:UIPressTypePlayPause]];
    
    [self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark - Authentication

- (void)showLoginView
{
    Server *server = [ServerDataManager defaultServerConfiguration];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Configure Server"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"Server address";
        textField.text = server.hostAddress;
        
        self.serverAddressTextField = textField;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"Description";
        textField.text = server.hostDescription;
        
        self.descriptionTextField = textField;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"Username";
        textField.text = server.username;
        
        self.usernameTextField = textField;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"Password";
        textField.text = server.password;
        textField.secureTextEntry = YES;
        
        self.passwordTextField = textField;
        
        [textField addTarget:self
                      action:@selector(handleTextFieldTextDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Save"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        server.hostAddress = self.serverAddressTextField.text;
        server.hostDescription = self.descriptionTextField.text;
        server.username = self.usernameTextField.text;
        server.password = self.passwordTextField.text;
        
        [ServerDataManager saveServerConfiguration:server];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:nil
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
                                       
    }];
        
    self.passwordAlertAction = acceptAction;
    
    [alertController addAction:acceptAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        if ([ServerDataManager isServerConfigured])
        {
            [self getBots];
        }
    }];
}

#pragma mark - Data Methods

- (void)getServerVersions
{
    __weak typeof(self) weakSelf = self;
    
    Server *server = [ServerDataManager defaultServerConfiguration];
    
    self.addressLabel.text = server.hostAddress;
    
    [ServerDataManager getServerVersionsForServer:server withSuccess:^(NSDictionary *infoDictionary, id payload)
    {
        ServerVersions *serverVersions = payload;
        
        weakSelf.osVersionLabel.text = [NSString stringWithFormat:@"OS X %@", serverVersions.os];
        weakSelf.osServerVersionLabel.text = [NSString stringWithFormat:@"OS X Server %@", serverVersions.server];
        weakSelf.xcodeVersionLabel.text = [NSString stringWithFormat:@"Xcode %@", serverVersions.xcode];
        
        [weakSelf.serverActivityIndicator stopAnimating];
    }
    failure:^(NSDictionary *infoDictionary, NSError *error)
    {
        NSLog(@"");
    }];
}

- (void)getBots
{
    __weak typeof(self) weakSelf = self;
    
    [self invalidateRefreshTimer];
    
    NSIndexPath *selectedIndexPath = [self indexPathForSelecteItem];
    
    [self.botDataManager getBotsWithSuccess:^(NSDictionary *infoDictionary, id payload)
    {
        [weakSelf.botActivityIndicator stopAnimating];
        weakSelf.botCollection = payload;
        [weakSelf.collectionView reloadData];
        
        weakSelf.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", weakSelf.botCollection.totalFailureCount];
        
        if (selectedIndexPath)
        {
            [weakSelf.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        [weakSelf setupRefreshTimer];
        
    }
    failure:^(NSDictionary *infoDictionary, NSError *error)
    {
        NSLog(@"");
        //[weakSelf setupRefreshTimer];
    }];
}

#pragma mark - Events

- (void)handleTextFieldTextDidChange:(UITextField *)textField
{
    
}

- (IBAction)didSelectAdd:(id)sender
{
    [self showLoginView];
}

- (void)tappedPlayPauseButton:(id)sender
{
    [self invalidateRefreshTimer];
    
    NSInteger index = [self indexOfSelectedItem];
    
    Bot *bot = self.botCollection.results[index];
    
    __weak typeof(self) weakSelf = self;
    
    NSIndexPath *selectedIndexPath = [self indexPathForSelecteItem];
    [self.collectionView deselectItemAtIndexPath:selectedIndexPath animated:YES];
    
    [self.botDataManager triggeBuildForBot:bot withSuccess:^(NSDictionary *infoDictionary, id payload)
    {
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[selectedIndexPath]];
        
        [weakSelf.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        [weakSelf setupRefreshTimer];
    }
    failure:^(NSDictionary *infoDictionary, NSError *error)
    {
        NSLog(@"fail");
    }];
}

- (NSInteger)indexOfSelectedItem
{
    NSIndexPath *path = [self indexPathForSelecteItem];
    
    NSInteger index = [path indexAtPosition:1];
    
    return index;
}

- (NSIndexPath *)indexPathForSelecteItem
{
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    
    NSIndexPath *path = selectedIndexPaths.firstObject;
    
    return path;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.botCollection.results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[IntegrationCollectionViewCell reuseIdentifier]
                                                                           forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context
{
    // let focus perform selection
    [collectionView selectItemAtIndexPath:context.nextFocusedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(IntegrationCollectionViewCell *)cell updateWithBot:self.botCollection.results[indexPath.row]];
}

#pragma mark - Refresh Timer

- (void)invalidateRefreshTimer
{
    if (self.refreshTimer.isValid)
    {
        [self.refreshTimer invalidate];
    }
    
    self.refreshTimer = nil;
}

- (void)setupRefreshTimer
{
    if (self.botCollection.hasActiveBuilds)
    {
        [self setupRefreshTimerWithInterval:ACTIVE_BUILD_REFRESH];
    }
    else
    {
        [self setupRefreshTimerWithInterval:STANDARD_REFRESH];
    }
}

- (void)setupRefreshTimerWithInterval:(NSTimeInterval)interval
{
    [self invalidateRefreshTimer];

    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:self
                                                       selector:@selector(getBots)
                                                       userInfo:nil
                                                        repeats:NO];
}

@end
