//
//  PrivacyViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "PrivacyViewController.h"
#import <Masonry/Masonry.h>

@interface PrivacyViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // Modern gradient background
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create multi-layer gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.view.bounds;
    gradientLayer.name = @"backgroundGradient";
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // Title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"🔒 Privacy Policy";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.8;
    
    // Add text shadow for better readability
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.titleLabel.layer.shadowOpacity = 0.8;
    self.titleLabel.layer.shadowRadius = 4;
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Back button with modern style
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.backButton.layer.cornerRadius = 15;
    self.backButton.layer.borderWidth = 1;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor;
    
    // 确保按钮可以接收触摸事件
    self.backButton.userInteractionEnabled = YES;
    self.backButton.layer.zPosition = 1;  // 确保按钮在最上层
    
    // Add backdrop blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.layer.cornerRadius = 15;
    blurView.clipsToBounds = YES;
    blurView.userInteractionEnabled = NO;  // 确保blur view不会阻挡触摸事件
    [self.backButton addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backButton);
    }];
    
    [self.backButton setTitle:@"🏠 Back to Home" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.backButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:self.backButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@50);
    }];
    
    // Scroll view with proper constraints
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.backButton.mas_top).offset(-20);
    }];
    
    // Content view with proper sizing
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // Add privacy policy sections
    [self addPrivacyPolicySections];
}

- (void)addPrivacyPolicySections {
    UIView *previousView = nil;
    
    // Last Updated
    UIView *lastUpdatedSection = [self createSectionWithTitle:@"📅 Last Updated" 
                                                       content:@"This Privacy Policy was last updated on July 14, 2025."];
    [self.contentView addSubview:lastUpdatedSection];
    
    [lastUpdatedSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = lastUpdatedSection;
    
    // Information We Collect
    UIView *infoCollectSection = [self createSectionWithTitle:@"📊 Information We Collect" 
                                                       content:@"Animals Slot Racing is designed to protect your privacy. We collect minimal information to provide you with the best gaming experience:\n\n• Game Progress: Your current level, coins, and game statistics are stored locally on your device using NSUserDefaults.\n\n• No Personal Data: We do not collect, store, or transmit any personal information such as your name, email address, phone number, or location.\n\n• No Account Required: You can play the game without creating an account or providing any personal information."];
    [self.contentView addSubview:infoCollectSection];
    
    [infoCollectSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = infoCollectSection;
    
    // Data Storage
    UIView *dataStorageSection = [self createSectionWithTitle:@"💾 Data Storage" 
                                                       content:@"• Local Storage Only: All game data (coins, level, progress) is stored locally on your device and never transmitted to external servers.\n\n• No Cloud Backup: Your game progress is not automatically backed up to iCloud or any other cloud service.\n\n• Device Reset: If you delete the app or reset your device, your game progress will be lost as no data is stored externally."];
    [self.contentView addSubview:dataStorageSection];
    
    [dataStorageSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = dataStorageSection;
    
    // Third-Party Services
    UIView *thirdPartySection = [self createSectionWithTitle:@"🔗 Third-Party Services" 
                                                      content:@"• No Analytics: We do not use any third-party analytics services to track your usage or behavior.\n\n• No Advertisements: The game does not display any advertisements or use advertising networks.\n\n• No Social Media Integration: We do not integrate with social media platforms or share any information with them.\n\n• Open Source Libraries: We use Masonry for UI layout constraints, which is an open-source library that does not collect user data."];
    [self.contentView addSubview:thirdPartySection];
    
    [thirdPartySection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = thirdPartySection;
    
    // Permissions
    UIView *permissionsSection = [self createSectionWithTitle:@"🛡️ Permissions" 
                                                       content:@"• Minimal Permissions: The app only requests the minimum permissions necessary to function.\n\n• No Location Access: We do not request access to your location.\n\n• No Camera/Microphone: We do not request access to your camera or microphone.\n\n• No Contacts: We do not request access to your contacts or address book.\n\n• No Network Access: The app does not require internet connectivity to function."];
    [self.contentView addSubview:permissionsSection];
    
    [permissionsSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = permissionsSection;
    
    // Children's Privacy
    UIView *childrenSection = [self createSectionWithTitle:@"👶 Children's Privacy" 
                                                    content:@"• Family-Friendly: Our game is designed to be safe for players of all ages.\n\n• No Data Collection from Children: We do not knowingly collect any information from children under 13.\n\n• Parental Control: Parents can monitor their children's use of the app since all data is stored locally on the device.\n\n• Educational Value: The game involves strategy and probability concepts that can be educational for young players."];
    [self.contentView addSubview:childrenSection];
    
    [childrenSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = childrenSection;
    
    // Data Security
    UIView *securitySection = [self createSectionWithTitle:@"🔐 Data Security" 
                                                    content:@"• Local Security: Since all data is stored locally on your device, it is protected by your device's security measures.\n\n• No Data Transmission: No game data is transmitted over the internet, eliminating the risk of data breaches during transmission.\n\n• Device Protection: We recommend using your device's built-in security features (passcode, Face ID, Touch ID) to protect your device and game progress."];
    [self.contentView addSubview:securitySection];
    
    [securitySection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = securitySection;
    
    // Changes to Privacy Policy
    UIView *changesSection = [self createSectionWithTitle:@"📝 Changes to This Privacy Policy" 
                                                   content:@"• Updates: We may update this Privacy Policy from time to time. Any changes will be reflected in the app update.\n\n• Notification: We will notify users of any significant changes to this Privacy Policy through app store update notes.\n\n• Continued Use: Your continued use of the app after any changes to this Privacy Policy constitutes acceptance of those changes."];
    [self.contentView addSubview:changesSection];
    
    [changesSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = changesSection;
    
    // Contact Information
    UIView *contactSection = [self createSectionWithTitle:@"📞 Contact Us" 
                                                   content:@"If you have any questions about this Privacy Policy or the app, please contact us through:\n\n• In-App Feedback: Use the feedback feature within the app to send us your questions or concerns.\n\n• Privacy Commitment: We are committed to protecting your privacy and will respond to your inquiries promptly.\n\n• Transparency: We believe in being transparent about our privacy practices and welcome your feedback."];
    [self.contentView addSubview:contactSection];
    
    [contactSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (UIView *)createSectionWithTitle:(NSString *)title content:(NSString *)content {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
    sectionView.layer.cornerRadius = 15;
    sectionView.layer.borderWidth = 1;
    sectionView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    
    // Title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 0;
    [sectionView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView).offset(15);
        make.left.equalTo(sectionView).offset(15);
        make.right.equalTo(sectionView).offset(-15);
    }];
    
    // Content label
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = content;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [sectionView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(sectionView).offset(15);
        make.right.equalTo(sectionView).offset(-15);
        make.bottom.equalTo(sectionView).offset(-15);
    }];
    
    return sectionView;
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonTouchDown:(UIButton *)sender {
    // Bounce down animation
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
        sender.alpha = 0.8;
    }];
}

- (void)buttonTouchUp:(UIButton *)sender {
    // Bounce back animation
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.alpha = 1.0;
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Update gradient frame
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:@"backgroundGradient"]) {
            layer.frame = self.view.bounds;
            break;
        }
    }
}

@end 