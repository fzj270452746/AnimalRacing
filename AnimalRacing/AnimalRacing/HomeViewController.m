//
//  HomeViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "HomeViewController.h"
#import "GameDataManager.h"
#import "RacingSlotViewController.h"
#import "GuessFirstViewController.h"
#import "RuleViewController.h"
#import "FeedbackViewController.h"
#import "PrivacyViewController.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h> // Added for objc_setAssociatedObject

@interface HomeViewController ()

@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *gameInfoContainer;
@property (nonatomic, strong) CAEmitterLayer *particleEmitter;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupParticleEffects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateGameInfo];
}

- (void)setupUI {
    // Cartoon-style colorful gradient background
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create animated rainbow gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.4 blue:0.8 alpha:0.9].CGColor,  // Pink
        (id)[UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:0.9].CGColor,  // Sky blue
        (id)[UIColor colorWithRed:0.8 green:1.0 blue:0.4 alpha:0.9].CGColor,  // Light green
        (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:0.9].CGColor,  // Yellow
        (id)[UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:0.9].CGColor   // Purple
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.view.bounds;
    gradientLayer.name = @"backgroundGradient";
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // Add animated color transition
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnimation.fromValue = gradientLayer.colors;
    colorAnimation.toValue = @[
        (id)[UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:0.4 green:1.0 blue:0.8 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.4 blue:0.8 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:0.9].CGColor
    ];
    colorAnimation.duration = 4.0;
    colorAnimation.repeatCount = INFINITY;
    colorAnimation.autoreverses = YES;
    [gradientLayer addAnimation:colorAnimation forKey:@"colorTransition"];
    
    // Add floating animal emojis as background decoration
    [self addFloatingAnimals];
    
    // Main title with cartoon bounce effect
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"🎰🐾 Animal Racing 🐾🎰";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.7;
    
    // Add rainbow text shadow
    self.titleLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.8 alpha:1.0].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 3);
    self.titleLabel.layer.shadowOpacity = 0.8;
    self.titleLabel.layer.shadowRadius = 6;
    
    // Add pulsing animation to title
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.fromValue = @1.0;
    pulseAnimation.toValue = @1.1;
    pulseAnimation.duration = 1.5;
    pulseAnimation.repeatCount = INFINITY;
    pulseAnimation.autoreverses = YES;
    [self.titleLabel.layer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Status container with cartoon bubble effect
    self.statusContainer = [[UIView alloc] init];
    self.statusContainer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    self.statusContainer.layer.cornerRadius = 25;
    self.statusContainer.layer.borderWidth = 4;
    self.statusContainer.layer.borderColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
    
    // Add cartoon bubble shadow
    self.statusContainer.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.statusContainer.layer.shadowOffset = CGSizeMake(0, 8);
    self.statusContainer.layer.shadowOpacity = 1.0;
    self.statusContainer.layer.shadowRadius = 12;
    
    [self.view addSubview:self.statusContainer];
    
    [self.statusContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@120);
    }];
    
    // Level label with cartoon style
    self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.text = @"🏆 Level: 1";
    self.levelLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    self.levelLabel.font = [UIFont boldSystemFontOfSize:20];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.levelLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.levelLabel.layer.shadowOpacity = 1.0;
    self.levelLabel.layer.shadowRadius = 3;
    [self.statusContainer addSubview:self.levelLabel];
    
    // Coins label with golden effect
    self.coinsLabel = [[UILabel alloc] init];
    self.coinsLabel.text = @"💰 Coins: 3000";
    self.coinsLabel.textColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.0 alpha:1.0];
    self.coinsLabel.font = [UIFont boldSystemFontOfSize:20];
    self.coinsLabel.textAlignment = NSTextAlignmentCenter;
    self.coinsLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.coinsLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.coinsLabel.layer.shadowOpacity = 1.0;
    self.coinsLabel.layer.shadowRadius = 3;
    [self.statusContainer addSubview:self.coinsLabel];
    
    // Win rate label with fun style
    self.winRateLabel = [[UILabel alloc] init];
    self.winRateLabel.text = @"🎯 Win Rate: 0%";
    self.winRateLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    self.winRateLabel.font = [UIFont boldSystemFontOfSize:20];
    self.winRateLabel.textAlignment = NSTextAlignmentCenter;
    self.winRateLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.winRateLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.winRateLabel.layer.shadowOpacity = 1.0;
    self.winRateLabel.layer.shadowRadius = 3;
    [self.statusContainer addSubview:self.winRateLabel];
    
    // Layout status labels
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusContainer).offset(20);
        make.top.equalTo(self.statusContainer).offset(25);
    }];
    
    [self.coinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusContainer).offset(-20);
        make.top.equalTo(self.statusContainer).offset(25);
    }];
    
    [self.winRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusContainer);
        make.bottom.equalTo(self.statusContainer).offset(-25);
    }];
    
    // Main game buttons with cartoon style
    self.racingSlotButton = [self createCartoonButtonWithTitle:@"🎰 Racing Slots"
                                                      subtitle:@"💰 20 coins per spin"
                                                gradientColors:@[
                                                    (id)[UIColor colorWithRed:1.0 green:0.2 blue:0.4 alpha:1.0].CGColor,
                                                    (id)[UIColor colorWithRed:0.8 green:0.1 blue:0.3 alpha:1.0].CGColor
                                                ]
                                                        action:@selector(racingSlotButtonTapped)];
    [self.view addSubview:self.racingSlotButton];
    
    self.guessFirstButton = [self createCartoonButtonWithTitle:@"🎯 Guess First" 
                                                      subtitle:@"💰 200 coins, win 1000!"
                                                gradientColors:@[
                                                    (id)[UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0].CGColor,
                                                    (id)[UIColor colorWithRed:0.1 green:0.6 blue:0.3 alpha:1.0].CGColor
                                                ]
                                                        action:@selector(guessFirstButtonTapped)];
    [self.view addSubview:self.guessFirstButton];
    
    // Function buttons with simpler cartoon style
    self.gameRulesButton = [self createSimpleCartoonButtonWithTitle:@"📖 Game Rules"
                                                      gradientColors:@[
                                                          (id)[UIColor colorWithRed:0.4 green:0.6 blue:1.0 alpha:1.0].CGColor,
                                                          (id)[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0].CGColor
                                                      ]
                                                              action:@selector(gameRulesButtonTapped)];
    [self.view addSubview:self.gameRulesButton];
    
    self.feedbackButton = [self createSimpleCartoonButtonWithTitle:@"💬 Feedback"
                                                    gradientColors:@[
                                                        (id)[UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1.0].CGColor,
                                                        (id)[UIColor colorWithRed:0.8 green:0.4 blue:0.1 alpha:1.0].CGColor
                                                    ]
                                                            action:@selector(feedbackButtonTapped)];
    [self.view addSubview:self.feedbackButton];
    
    self.privacyButton = [self createSimpleCartoonButtonWithTitle:@"🔒 Privacy Policy"
                                                   gradientColors:@[
                                                       (id)[UIColor colorWithRed:0.6 green:0.4 blue:0.8 alpha:1.0].CGColor,
                                                       (id)[UIColor colorWithRed:0.4 green:0.2 blue:0.6 alpha:1.0].CGColor
                                                   ]
                                                           action:@selector(privacyButtonTapped)];
    [self.view addSubview:self.privacyButton];
    
    // Layout buttons with more spacing for cartoon feel
    [self.racingSlotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.statusContainer.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@80);
    }];
    
    [self.guessFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.racingSlotButton.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@80);
    }];
    
    [self.gameRulesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.guessFirstButton.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@60);
    }];
    
    [self.feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.gameRulesButton.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@60);
    }];
    
    [self.privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.feedbackButton.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@60);
        make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
    }];
}

- (void)addFloatingAnimals {
    // Add floating animal emojis as background decoration
    NSArray *animalEmojis = @[@"🐰", @"🐱", @"🐶", @"🐺", @"🦊", @"🐸", @"🐼", @"🐨", @"🦁", @"🐯"];
    
    for (int i = 0; i < 8; i++) {
        UILabel *animalLabel = [[UILabel alloc] init];
        animalLabel.text = animalEmojis[i % animalEmojis.count];
        animalLabel.font = [UIFont systemFontOfSize:25];
        animalLabel.alpha = 0.3;
        [self.view addSubview:animalLabel];
        
        // Random position
        CGFloat x = arc4random_uniform(300) + 50;
        CGFloat y = arc4random_uniform(600) + 100;
        animalLabel.frame = CGRectMake(x, y, 30, 30);
        
        // Add floating animation
        CABasicAnimation *floatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        floatAnimation.fromValue = @0;
        floatAnimation.toValue = @(-30);
        floatAnimation.duration = 3.0 + (arc4random_uniform(200) / 100.0);
        floatAnimation.repeatCount = INFINITY;
        floatAnimation.autoreverses = YES;
        floatAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(200) / 100.0);
        [animalLabel.layer addAnimation:floatAnimation forKey:@"floatAnimation"];
        
        // Add rotation animation
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = @(-M_PI / 8);
        rotateAnimation.toValue = @(M_PI / 8);
        rotateAnimation.duration = 4.0 + (arc4random_uniform(200) / 100.0);
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.autoreverses = YES;
        rotateAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(300) / 100.0);
        [animalLabel.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title subtitle:(NSString *)subtitle color:(UIColor *)color action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = NO;
    [button addSubview:titleLabel];
    
    // Subtitle label
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.userInteractionEnabled = NO;
    [button addSubview:subtitleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button).offset(15);
    }];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    // Add button press animation
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    
    return button;
}

- (UIButton *)createPremiumButtonWithTitle:(NSString *)title subtitle:(NSString *)subtitle gradientColors:(NSArray<UIColor *> *)colors action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
    button.layer.masksToBounds = NO;
    
    // Add subtle shadow
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 6);
    button.layer.shadowOpacity = 0.3;
    button.layer.shadowRadius = 12;
    
    // Store gradient colors for later use
    objc_setAssociatedObject(button, @"gradientColors", colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Add glassmorphism backdrop
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.layer.cornerRadius = 20;
    blurView.clipsToBounds = YES;
    blurView.userInteractionEnabled = NO;
    [button addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
    // Add gradient overlay
    UIView *gradientContainer = [[UIView alloc] init];
    gradientContainer.backgroundColor = [UIColor clearColor];
    gradientContainer.layer.cornerRadius = 20;
    gradientContainer.clipsToBounds = YES;
    gradientContainer.userInteractionEnabled = NO;
    [button addSubview:gradientContainer];
    
    [gradientContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
    // Create gradient layer that will be updated in viewDidLayoutSubviews
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)colors.firstObject.CGColor, (id)colors.lastObject.CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.name = @"buttonGradient";
    [gradientContainer.layer addSublayer:gradientLayer];
    
    // Add title label with better text handling
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.8;
    titleLabel.userInteractionEnabled = NO;
    
    // Add text shadow for better readability
    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    titleLabel.layer.shadowOpacity = 0.7;
    titleLabel.layer.shadowRadius = 2;
    
    [button addSubview:titleLabel];
    
    // Add subtitle label with better text handling
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 1;
    subtitleLabel.adjustsFontSizeToFitWidth = YES;
    subtitleLabel.minimumScaleFactor = 0.8;
    subtitleLabel.userInteractionEnabled = NO;
    
    [button addSubview:subtitleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button).offset(18);
        make.left.equalTo(button).offset(15);
        make.right.equalTo(button).offset(-15);
    }];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(button).offset(15);
        make.right.equalTo(button).offset(-15);
    }];
    
    // Add button press animation
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)createSimpleButtonWithTitle:(NSString *)title gradientColors:(NSArray<UIColor *> *)colors action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
    button.layer.masksToBounds = NO;
    
    // Add subtle shadow
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 6);
    button.layer.shadowOpacity = 0.3;
    button.layer.shadowRadius = 12;
    
    // Store gradient colors for later use
    objc_setAssociatedObject(button, @"gradientColors", colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Add glassmorphism backdrop
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.layer.cornerRadius = 20;
    blurView.clipsToBounds = YES;
    blurView.userInteractionEnabled = NO;
    [button addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
    // Add gradient overlay
    UIView *gradientContainer = [[UIView alloc] init];
    gradientContainer.backgroundColor = [UIColor clearColor];
    gradientContainer.layer.cornerRadius = 20;
    gradientContainer.clipsToBounds = YES;
    gradientContainer.userInteractionEnabled = NO;
    [button addSubview:gradientContainer];
    
    [gradientContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
    // Create gradient layer that will be updated in viewDidLayoutSubviews
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)colors.firstObject.CGColor, (id)colors.lastObject.CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.name = @"buttonGradient";
    [gradientContainer.layer addSublayer:gradientLayer];
    
    // Add only title label - centered and larger
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.8;
    titleLabel.userInteractionEnabled = NO;
    
    // Add text shadow for better readability
    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    titleLabel.layer.shadowOpacity = 0.7;
    titleLabel.layer.shadowRadius = 2;
    
    [button addSubview:titleLabel];
    
    // Center the title label in the button
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
        make.left.equalTo(button).offset(15);
        make.right.equalTo(button).offset(-15);
    }];
    
    // Add button press animation
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)createCartoonButtonWithTitle:(NSString *)title 
                                  subtitle:(NSString *)subtitle 
                            gradientColors:(NSArray *)colors 
                                    action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 3;
    button.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add cartoon shadow
    button.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 8);
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowRadius = 12;
    
    // Create gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.cornerRadius = 20;
    [button.layer insertSublayer:gradientLayer atIndex:0];
    
    // Title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.shadowRadius = 3;
    [button addSubview:titleLabel];
    
    // Subtitle label
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.7 alpha:1.0];
    subtitleLabel.font = [UIFont boldSystemFontOfSize:16];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    subtitleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    subtitleLabel.layer.shadowOpacity = 1.0;
    subtitleLabel.layer.shadowRadius = 2;
    [button addSubview:subtitleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button).offset(12);
    }];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(button).offset(-12);
    }];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    return button;
}

- (UIButton *)createSimpleCartoonButtonWithTitle:(NSString *)title 
                                  gradientColors:(NSArray *)colors 
                                          action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add cartoon shadow
    button.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 6);
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowRadius = 8;
    
    // Create gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.cornerRadius = 15;
    [button.layer insertSublayer:gradientLayer atIndex:0];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    button.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    button.titleLabel.layer.shadowOpacity = 1.0;
    button.titleLabel.layer.shadowRadius = 3;
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    return button;
}

- (void)setupParticleEffects {
    self.particleEmitter = [CAEmitterLayer layer];
    self.particleEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, -50);
    self.particleEmitter.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
    self.particleEmitter.emitterShape = kCAEmitterLayerLine;
    self.particleEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 3;
    cell.lifetime = 8.0;
    cell.velocity = 20;
    cell.velocityRange = 10;
    cell.emissionRange = M_PI / 8;
    cell.spin = M_PI / 4;
    cell.spinRange = M_PI / 8;
    cell.scaleRange = 0.3;
    cell.scaleSpeed = -0.02;
    cell.alphaRange = 0.5;
    cell.alphaSpeed = -0.1;
    cell.color = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    cell.contents = (id)[self createStarImage].CGImage;
    
    self.particleEmitter.emitterCells = @[cell];
    [self.view.layer addSublayer:self.particleEmitter];
}

- (UIImage *)createStarImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 10, 10));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)addGlowEffectToView:(UIView *)view {
    CALayer *glowLayer = [CALayer layer];
    glowLayer.frame = view.bounds;
    glowLayer.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:0.3].CGColor;
    glowLayer.cornerRadius = view.layer.cornerRadius;
    glowLayer.masksToBounds = NO;
    glowLayer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    glowLayer.shadowOffset = CGSizeZero;
    glowLayer.shadowRadius = 10;
    glowLayer.shadowOpacity = 0.5;
    [view.layer insertSublayer:glowLayer atIndex:0];
}

- (void)addPulsingAnimationToView:(UIView *)view {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.fromValue = @(1.0);
    pulseAnimation.toValue = @(1.05);
    pulseAnimation.duration = 2.0;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:pulseAnimation forKey:@"pulse"];
}

- (void)addPremiumPulsingAnimationToView:(UIView *)view {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.fromValue = @(1.0);
    pulseAnimation.toValue = @(1.05);
    pulseAnimation.duration = 2.0;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:pulseAnimation forKey:@"pulse"];
}

- (void)updateGameInfo {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    self.coinsLabel.text = [NSString stringWithFormat:@"💰 Coins: %ld", (long)gameManager.coins];
    self.levelLabel.text = [NSString stringWithFormat:@"🏆 Level: %ld", (long)gameManager.level];
}

- (void)buttonPressed:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];
}

- (void)buttonReleased:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformIdentity;
    }];
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

- (void)racingSlotButtonTapped {
    RacingSlotViewController *racingSlotVC = [[RacingSlotViewController alloc] init];
    racingSlotVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:racingSlotVC animated:YES completion:nil];
}

- (void)guessFirstButtonTapped {
    GuessFirstViewController *guessFirstVC = [[GuessFirstViewController alloc] init];
    guessFirstVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:guessFirstVC animated:YES completion:nil];
}

- (void)gameRulesButtonTapped {
    RuleViewController *rulesVC = [[RuleViewController alloc] init];
    rulesVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:rulesVC animated:YES completion:nil];
}

- (void)feedbackButtonTapped {
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
    feedbackVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:feedbackVC animated:YES completion:nil];
}

- (void)privacyButtonTapped {
    PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
    privacyVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:privacyVC animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Update primary gradient frame
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:@"backgroundGradient"]) {
            layer.frame = self.view.bounds;
            break;
        }
    }
    
    // Update button gradient frames
    NSArray *buttons = @[self.racingSlotButton, self.guessFirstButton, self.gameRulesButton, self.feedbackButton, self.privacyButton];
    for (UIButton *button in buttons) {
        if (button) {
            // Find the gradient container view and update its gradient layer
            for (UIView *subview in button.subviews) {
                if (subview.layer.sublayers.count > 0) {
                    for (CALayer *layer in subview.layer.sublayers) {
                        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:@"buttonGradient"]) {
                            layer.frame = subview.bounds;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    // Update particle emitter position
    if (self.particleEmitter) {
        self.particleEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, -50);
        self.particleEmitter.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
    }
}

@end 
