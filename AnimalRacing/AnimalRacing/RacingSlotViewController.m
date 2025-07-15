//
//  RacingSlotViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "RacingSlotViewController.h"
#import "GameDataManager.h"
#import "SlotMachineView.h"
#import "AnimalRaceView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@interface RacingSlotViewController () <SlotMachineViewDelegate, AnimalRaceViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *coinsLabel;
@property (nonatomic, strong) UILabel *targetStepsLabel;
@property (nonatomic, strong) SlotMachineView *slotMachineView;
@property (nonatomic, strong) AnimalRaceView *animalRaceView;
@property (nonatomic, strong) UIButton *spinButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *resetButton;

@property (nonatomic, assign) NSInteger currentLevel;
@property (nonatomic, assign) NSInteger targetSteps;
@property (nonatomic, assign) BOOL gameInProgress;

@end

@implementation RacingSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupGameData];
}

- (void)setupUI {
    // Cartoon-style slot machine casino gradient background
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create animated casino-themed gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.9 green:0.1 blue:0.3 alpha:1.0].CGColor,  // Casino red
        (id)[UIColor colorWithRed:0.7 green:0.0 blue:0.2 alpha:1.0].CGColor,  // Deep red
        (id)[UIColor colorWithRed:0.5 green:0.0 blue:0.1 alpha:1.0].CGColor,  // Dark red
        (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.0 alpha:1.0].CGColor   // Gold
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.view.bounds;
    gradientLayer.name = @"backgroundGradient";
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // Add animated color transition for casino lights effect
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnimation.fromValue = gradientLayer.colors;
    colorAnimation.toValue = @[
        (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.1 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.0 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.5 green:0.0 blue:0.1 alpha:1.0].CGColor
    ];
    colorAnimation.duration = 3.0;
    colorAnimation.repeatCount = INFINITY;
    colorAnimation.autoreverses = YES;
    [gradientLayer addAnimation:colorAnimation forKey:@"colorTransition"];
    
    // Add floating casino and animal emojis
    [self addFloatingCasinoEmojis];
    
    // Title label with casino-style flashing effect
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"🎰💫 Racing Slot 💫🎰";
    self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:26];  // Reduced from 32 to 26
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.8;
    
    // Add casino-style glowing text shadow
    self.titleLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.titleLabel.layer.shadowOpacity = 1.0;
    self.titleLabel.layer.shadowRadius = 10;
    
    // Add flashing animation like casino lights
    CABasicAnimation *flashAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashAnimation.fromValue = @0.7;
    flashAnimation.toValue = @1.0;
    flashAnimation.duration = 0.8;
    flashAnimation.repeatCount = INFINITY;
    flashAnimation.autoreverses = YES;
    [self.titleLabel.layer addAnimation:flashAnimation forKey:@"flashAnimation"];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);  // Reduced from 10 to 5
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Game info container with casino bubble effect
    UIView *gameInfoContainer = [[UIView alloc] init];
    gameInfoContainer.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.8 alpha:0.95];
    gameInfoContainer.layer.cornerRadius = 20;
    gameInfoContainer.layer.borderWidth = 3;
    gameInfoContainer.layer.borderColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.0 alpha:1.0].CGColor;
    
    // Add casino-style neon glow effect
    gameInfoContainer.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.0 alpha:1.0].CGColor;
    gameInfoContainer.layer.shadowOffset = CGSizeMake(0, 0);
    gameInfoContainer.layer.shadowOpacity = 0.8;
    gameInfoContainer.layer.shadowRadius = 15;
    
    // Add pulsing glow animation
    CABasicAnimation *glowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    glowAnimation.fromValue = @10;
    glowAnimation.toValue = @20;
    glowAnimation.duration = 1.5;
    glowAnimation.repeatCount = INFINITY;
    glowAnimation.autoreverses = YES;
    [gameInfoContainer.layer addAnimation:glowAnimation forKey:@"glowAnimation"];
    
    [self.view addSubview:gameInfoContainer];
    
    [gameInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);  // Reduced from 10 to 8
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.equalTo(@65);  // Reduced from 80 to 65
    }];
    
    // Level label with casino styling
    self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.text = @"🏆 Level: 1";
    self.levelLabel.textColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.2 alpha:1.0];
    self.levelLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.adjustsFontSizeToFitWidth = YES;
    self.levelLabel.minimumScaleFactor = 0.8;
    self.levelLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.levelLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.levelLabel.layer.shadowOpacity = 1.0;
    self.levelLabel.layer.shadowRadius = 3;
    [gameInfoContainer addSubview:self.levelLabel];
    
    // Coins label with golden casino effect
    self.coinsLabel = [[UILabel alloc] init];
    self.coinsLabel.text = @"💰 Coins: 3000";
    self.coinsLabel.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.0 alpha:1.0];
    self.coinsLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    self.coinsLabel.textAlignment = NSTextAlignmentCenter;
    self.coinsLabel.adjustsFontSizeToFitWidth = YES;
    self.coinsLabel.minimumScaleFactor = 0.8;
    self.coinsLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.coinsLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.coinsLabel.layer.shadowOpacity = 1.0;
    self.coinsLabel.layer.shadowRadius = 3;
    [gameInfoContainer addSubview:self.coinsLabel];
    
    // Target steps label with racing theme
    self.targetStepsLabel = [[UILabel alloc] init];
    self.targetStepsLabel.text = @"🏁 Target: 50 Steps";
    self.targetStepsLabel.textColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1.0];
    self.targetStepsLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    self.targetStepsLabel.textAlignment = NSTextAlignmentCenter;
    self.targetStepsLabel.adjustsFontSizeToFitWidth = YES;
    self.targetStepsLabel.minimumScaleFactor = 0.8;
    self.targetStepsLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.targetStepsLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.targetStepsLabel.layer.shadowOpacity = 1.0;
    self.targetStepsLabel.layer.shadowRadius = 3;
    [gameInfoContainer addSubview:self.targetStepsLabel];
    
    // Layout game info labels
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gameInfoContainer).offset(15);
        make.top.equalTo(gameInfoContainer).offset(10);  // Reduced from 15 to 10
        make.width.lessThanOrEqualTo(@120);
    }];
    
    [self.coinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(gameInfoContainer).offset(-15);
        make.top.equalTo(gameInfoContainer).offset(10);  // Reduced from 15 to 10
        make.width.lessThanOrEqualTo(@120);
    }];
    
    [self.targetStepsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(gameInfoContainer);
        make.bottom.equalTo(gameInfoContainer).offset(-10);  // Reduced from -15 to -10
        make.width.lessThanOrEqualTo(@150);
    }];
    
    // Slot machine view with casino frame
    self.slotMachineView = [[SlotMachineView alloc] init];
    self.slotMachineView.delegate = self;
    self.slotMachineView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    self.slotMachineView.layer.cornerRadius = 15;
    self.slotMachineView.layer.borderWidth = 4;
    self.slotMachineView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add slot machine glow effect
    self.slotMachineView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    self.slotMachineView.layer.shadowOffset = CGSizeMake(0, 0);
    self.slotMachineView.layer.shadowOpacity = 0.6;
    self.slotMachineView.layer.shadowRadius = 12;
    
    [self.view addSubview:self.slotMachineView];
    
    [self.slotMachineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(gameInfoContainer.mas_bottom).offset(10);  // Reduced from 15 to 10
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@100);  // Reduced from 120 to 100
    }];
    
    // Animal race view with race track styling - OPTIMIZED HEIGHT
    self.animalRaceView = [[AnimalRaceView alloc] initWithTotalSteps:50];
    self.animalRaceView.delegate = self;
    self.animalRaceView.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.1];
    // 移除重复的边框设置，因为AnimalRaceView本身已经有边框了
    // self.animalRaceView.layer.cornerRadius = 15;
    // self.animalRaceView.layer.borderWidth = 3;
    // self.animalRaceView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:1.0].CGColor;
    
    // Add race track shadow
    self.animalRaceView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor;
    self.animalRaceView.layer.shadowOffset = CGSizeMake(0, 5);
    self.animalRaceView.layer.shadowOpacity = 1.0;
    self.animalRaceView.layer.shadowRadius = 10;
    
    [self.view addSubview:self.animalRaceView];
    
    [self.animalRaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.slotMachineView.mas_bottom).offset(10);  // Reduced from 15 to 10
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@350);  // 与布局保持一致，确保10个动物轨道完全显示
    }];
    
    // Button container with flexible height
    UIView *buttonContainer = [[UIView alloc] init];
    buttonContainer.backgroundColor = [UIColor clearColor];  // 确保容器背景透明
    buttonContainer.userInteractionEnabled = YES;  // 确保容器可以传递触摸事件
    [self.view addSubview:buttonContainer];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.animalRaceView.mas_bottom).offset(5);  // Reduced from 10 to 5
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuide).offset(-10);  // Use lessThanOrEqualTo for flexibility
    }];
    
    // Spin button with casino slot machine style
    self.spinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.spinButton.backgroundColor = [UIColor clearColor];  // 确保按钮背景透明
    self.spinButton.layer.cornerRadius = 15;
    self.spinButton.layer.borderWidth = 3;
    self.spinButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add casino button glow
    self.spinButton.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0].CGColor;
    self.spinButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.spinButton.layer.shadowOpacity = 0.8;
    self.spinButton.layer.shadowRadius = 15;
    
    // Create casino red gradient
    CAGradientLayer *spinGradient = [CAGradientLayer layer];
    spinGradient.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0].CGColor
    ];
    spinGradient.startPoint = CGPointMake(0.0, 0.0);
    spinGradient.endPoint = CGPointMake(1.0, 1.0);
    spinGradient.cornerRadius = 15;
    spinGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    [self.spinButton.layer insertSublayer:spinGradient atIndex:0];
    
    [self.spinButton setTitle:@"🎰 SPIN! (20 Coins)" forState:UIControlStateNormal];
    [self.spinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.spinButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];  // Reduced from 20 to 18
    self.spinButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.spinButton.titleLabel.minimumScaleFactor = 0.8;
    self.spinButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    self.spinButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.spinButton.titleLabel.layer.shadowOpacity = 1.0;
    self.spinButton.titleLabel.layer.shadowRadius = 3;
    
    // 确保按钮可以接收触摸事件
    self.spinButton.userInteractionEnabled = YES;
    self.spinButton.layer.zPosition = 1;  // 确保按钮在最上层
    
    [self.spinButton addTarget:self action:@selector(spinButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.spinButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.spinButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.spinButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.spinButton];
    
    // Back button with simple casino style
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor clearColor];  // 确保按钮背景透明
    self.backButton.layer.cornerRadius = 10;
    self.backButton.layer.borderWidth = 2;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Create simple gradient
    CAGradientLayer *backGradient = [CAGradientLayer layer];
    backGradient.colors = @[
        (id)[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor
    ];
    backGradient.startPoint = CGPointMake(0.0, 0.0);
    backGradient.endPoint = CGPointMake(1.0, 1.0);
    backGradient.cornerRadius = 10;
    backGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    [self.backButton.layer insertSublayer:backGradient atIndex:0];
    
    [self.backButton setTitle:@"🏠 Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];  // Reduced from 16 to 14
    
    // 确保按钮可以接收触摸事件
    self.backButton.userInteractionEnabled = YES;
    self.backButton.layer.zPosition = 1;  // 确保按钮在最上层
    
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.backButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.backButton];
    
    // Reset button with casino style
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetButton.backgroundColor = [UIColor clearColor];  // 确保按钮背景透明
    self.resetButton.layer.cornerRadius = 10;
    self.resetButton.layer.borderWidth = 2;
    self.resetButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Create reset gradient
    CAGradientLayer *resetGradient = [CAGradientLayer layer];
    resetGradient.colors = @[
        (id)[UIColor colorWithRed:0.7 green:0.4 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.5 green:0.2 blue:0.1 alpha:1.0].CGColor
    ];
    resetGradient.startPoint = CGPointMake(0.0, 0.0);
    resetGradient.endPoint = CGPointMake(1.0, 1.0);
    resetGradient.cornerRadius = 10;
    resetGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    [self.resetButton.layer insertSublayer:resetGradient atIndex:0];
    
    [self.resetButton setTitle:@"🔄 Reset" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];  // Reduced from 16 to 14
    
    // 确保按钮可以接收触摸事件
    self.resetButton.userInteractionEnabled = YES;
    self.resetButton.layer.zPosition = 1;  // 确保按钮在最上层
    
    [self.resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.resetButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.resetButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.resetButton];
    
    // Layout buttons with optimized height
    [self.spinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer);
        make.top.equalTo(buttonContainer).offset(5);
        make.left.equalTo(buttonContainer).offset(20);
        make.right.equalTo(buttonContainer).offset(-20);
        make.height.equalTo(@48);  // 增加高度：从45增加到48
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonContainer).offset(20);
        make.top.equalTo(self.spinButton.mas_bottom).offset(8);  // Reduced from 10 to 8
        make.width.equalTo(buttonContainer).multipliedBy(0.45);
        make.height.equalTo(@38);  // 增加高度：从35增加到38
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonContainer).offset(-20);
        make.top.equalTo(self.spinButton.mas_bottom).offset(8);  // Reduced from 10 to 8
        make.width.equalTo(buttonContainer).multipliedBy(0.45);
        make.height.equalTo(@38);  // 增加高度：从35增加到38
        make.bottom.equalTo(buttonContainer).offset(-5);  // 添加底部约束
    }];
}

- (void)addFloatingCasinoEmojis {
    // Add floating casino and animal emojis as background decoration
    NSArray *casinoEmojis = @[@"🎰", @"💰", @"🎯", @"🔥", @"⚡", @"🌟", @"💎", @"🎲", @"🃏", @"🎪"];
    
    for (int i = 0; i < 12; i++) {
        UILabel *emojiLabel = [[UILabel alloc] init];
        emojiLabel.text = casinoEmojis[i % casinoEmojis.count];
        emojiLabel.font = [UIFont systemFontOfSize:20];
        emojiLabel.alpha = 0.3;
        emojiLabel.userInteractionEnabled = NO;  // 确保不会阻挡触摸事件
        emojiLabel.layer.zPosition = -10;  // 确保在最底层
        [self.view addSubview:emojiLabel];
        
        // Random position - 避免在按钮区域
        CGFloat x = arc4random_uniform(350) + 30;
        CGFloat y = arc4random_uniform(500) + 100;  // 减少y范围避免按钮区域
        emojiLabel.frame = CGRectMake(x, y, 25, 25);
        
        // Add casino-style pulsing animation
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulseAnimation.fromValue = @0.2;
        pulseAnimation.toValue = @0.5;
        pulseAnimation.duration = 1.5 + (arc4random_uniform(100) / 100.0);
        pulseAnimation.repeatCount = INFINITY;
        pulseAnimation.autoreverses = YES;
        pulseAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(100) / 100.0);
        [emojiLabel.layer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
        
        // Add floating animation
        CABasicAnimation *floatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        floatAnimation.fromValue = @0;
        floatAnimation.toValue = @(-20);
        floatAnimation.duration = 3.0 + (arc4random_uniform(100) / 100.0);
        floatAnimation.repeatCount = INFINITY;
        floatAnimation.autoreverses = YES;
        floatAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(200) / 100.0);
        [emojiLabel.layer addAnimation:floatAnimation forKey:@"floatAnimation"];
        
        // Add subtle rotation for casino effect
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = @(-M_PI / 16);
        rotateAnimation.toValue = @(M_PI / 16);
        rotateAnimation.duration = 4.0 + (arc4random_uniform(200) / 100.0);
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.autoreverses = YES;
        rotateAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(150) / 100.0);
        [emojiLabel.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
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

- (void)setupGameData {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    self.currentLevel = gameManager.level;
    self.targetSteps = [gameManager getAnimalTotalStepsForLevel:self.currentLevel];
    self.gameInProgress = NO;
    
    // 移除重复创建AnimalRaceView的代码，因为在setupUI中已经创建了
    // 只需要重置现有的AnimalRaceView即可
    [self.animalRaceView resetAllAnimals];
    
    [self updateUI];
}

- (void)updateUI {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    self.levelLabel.text = [NSString stringWithFormat:@"🏆 Level: %ld", (long)gameManager.level];
    self.coinsLabel.text = [NSString stringWithFormat:@"💰 Coins: %ld", (long)gameManager.coins];
    self.targetStepsLabel.text = [NSString stringWithFormat:@"🏁 Target: %ld Steps", (long)self.targetSteps];
    
    // Update spin button state
    BOOL canSpin = [gameManager canSpinWithCost:20] && !self.gameInProgress;
    self.spinButton.enabled = canSpin;
    self.spinButton.alpha = canSpin ? 1.0 : 0.5;
}

- (void)spinButtonTapped {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    if (![gameManager canSpinWithCost:20]) {
        [self showInsufficientCoinsAlert];
        return;
    }
    
    // Deduct coins
    [gameManager spendCoins:20];
    self.gameInProgress = YES;
    [self updateUI];
    
    // Start slot machine spin
    [self.slotMachineView spinWithRandomAnimal];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetButtonTapped {
    [self.animalRaceView resetAllAnimals];
    [self.slotMachineView reset];
    self.gameInProgress = NO;
    [self updateUI];
}

- (void)showInsufficientCoinsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Coins" 
                                                                   message:@"You need 20 coins to spin." 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SlotMachineViewDelegate

- (void)slotMachineView:(SlotMachineView *)slotMachineView didFinishSpinWithAnimal:(NSInteger)animalIndex {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    NSArray<NSNumber *> *moveSteps = [gameManager getAnimalMoveStepsForAnimal:animalIndex];
    
    if (moveSteps.count > 0) {
        NSInteger randomIndex = arc4random_uniform((uint32_t)moveSteps.count);
        NSInteger steps = moveSteps[randomIndex].integerValue;
        
        [self.animalRaceView updateAnimalProgress:animalIndex steps:steps];
    }
    
    self.gameInProgress = NO;
    [self updateUI];
}

#pragma mark - AnimalRaceViewDelegate

- (void)animalRaceView:(AnimalRaceView *)raceView animalDidFinish:(NSInteger)animalIndex {
    // Immediately disable spin button and update UI
    self.gameInProgress = NO;
    self.spinButton.enabled = NO;
    self.spinButton.alpha = 0.5;
    
    [self showBeautifulWinAlert:animalIndex];
}

- (void)showBeautifulWinAlert:(NSInteger)animalIndex {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    NSInteger reward = [gameManager getAnimalRewardForAnimal:animalIndex];
    
    // Create custom victory dialog
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    overlayView.alpha = 0.0;
    [self.view addSubview:overlayView];
    
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Create victory card
    UIView *victoryCard = [[UIView alloc] init];
    victoryCard.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    victoryCard.layer.cornerRadius = 25;
    victoryCard.layer.borderWidth = 5;
    victoryCard.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add victory card glow effect
    victoryCard.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    victoryCard.layer.shadowOffset = CGSizeMake(0, 0);
    victoryCard.layer.shadowOpacity = 0.8;
    victoryCard.layer.shadowRadius = 20;
    
    victoryCard.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [overlayView addSubview:victoryCard];
    
    [victoryCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(overlayView);
        make.centerY.equalTo(overlayView).offset(-50);
        make.width.equalTo(@320);
        make.height.equalTo(@400);
    }];
    
    // Add celebration gradient background
    CAGradientLayer *celebrationGradient = [CAGradientLayer layer];
    celebrationGradient.frame = CGRectMake(0, 0, 320, 400);
    celebrationGradient.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.9 blue:0.7 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.8 blue:1.0 alpha:0.9].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.9 blue:1.0 alpha:0.9].CGColor
    ];
    celebrationGradient.startPoint = CGPointMake(0.0, 0.0);
    celebrationGradient.endPoint = CGPointMake(1.0, 1.0);
    celebrationGradient.cornerRadius = 25;
    [victoryCard.layer insertSublayer:celebrationGradient atIndex:0];
    
    // Victory title with animation
    UILabel *victoryTitle = [[UILabel alloc] init];
    victoryTitle.text = @"🎉🏆 VICTORY! 🏆🎉";
    victoryTitle.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0];
    victoryTitle.font = [UIFont boldSystemFontOfSize:24];
    victoryTitle.textAlignment = NSTextAlignmentCenter;
    victoryTitle.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    victoryTitle.layer.shadowOffset = CGSizeMake(0, 2);
    victoryTitle.layer.shadowOpacity = 1.0;
    victoryTitle.layer.shadowRadius = 5;
    [victoryCard addSubview:victoryTitle];
    
    [victoryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.top.equalTo(victoryCard).offset(25);
    }];
    
    // Winner animal image with glow
    UIImageView *winnerAnimal = [[UIImageView alloc] init];
    winnerAnimal.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%ld", (long)animalIndex]];
    winnerAnimal.contentMode = UIViewContentModeScaleAspectFit;
    winnerAnimal.layer.cornerRadius = 40;
    winnerAnimal.layer.borderWidth = 4;
    winnerAnimal.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    winnerAnimal.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.8 alpha:1.0];
    
    // Add winner glow
    winnerAnimal.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    winnerAnimal.layer.shadowOffset = CGSizeMake(0, 0);
    winnerAnimal.layer.shadowOpacity = 0.8;
    winnerAnimal.layer.shadowRadius = 15;
    
    [victoryCard addSubview:winnerAnimal];
    
    [winnerAnimal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.top.equalTo(victoryTitle.mas_bottom).offset(20);
        make.width.height.equalTo(@80);
    }];
    
    // Winner info
    UILabel *winnerInfo = [[UILabel alloc] init];
    winnerInfo.text = [NSString stringWithFormat:@"🏃‍♂️ Animal-%ld Wins! 🏃‍♂️", (long)animalIndex];
    winnerInfo.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.0];
    winnerInfo.font = [UIFont boldSystemFontOfSize:20];
    winnerInfo.textAlignment = NSTextAlignmentCenter;
    winnerInfo.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    winnerInfo.layer.shadowOffset = CGSizeMake(0, 1);
    winnerInfo.layer.shadowOpacity = 1.0;
    winnerInfo.layer.shadowRadius = 2;
    [victoryCard addSubview:winnerInfo];
    
    [winnerInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.top.equalTo(winnerAnimal.mas_bottom).offset(20);
    }];
    
    // Reward info with coin animation
    UILabel *rewardInfo = [[UILabel alloc] init];
    rewardInfo.text = [NSString stringWithFormat:@"💰 Reward: %ld Coins 💰", (long)reward];
    rewardInfo.textColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.0 alpha:1.0];
    rewardInfo.font = [UIFont boldSystemFontOfSize:18];
    rewardInfo.textAlignment = NSTextAlignmentCenter;
    rewardInfo.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    rewardInfo.layer.shadowOffset = CGSizeMake(0, 1);
    rewardInfo.layer.shadowOpacity = 1.0;
    rewardInfo.layer.shadowRadius = 2;
    [victoryCard addSubview:rewardInfo];
    
    [rewardInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.top.equalTo(winnerInfo.mas_bottom).offset(15);
    }];
    
    // Level up info
    UILabel *levelInfo = [[UILabel alloc] init];
    levelInfo.text = [NSString stringWithFormat:@"🆙 Level Up to %ld! 🆙", (long)(gameManager.level + 1)];
    levelInfo.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.8 alpha:1.0];
    levelInfo.font = [UIFont boldSystemFontOfSize:16];
    levelInfo.textAlignment = NSTextAlignmentCenter;
    levelInfo.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    levelInfo.layer.shadowOffset = CGSizeMake(0, 1);
    levelInfo.layer.shadowOpacity = 1.0;
    levelInfo.layer.shadowRadius = 2;
    [victoryCard addSubview:levelInfo];
    
    [levelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.top.equalTo(rewardInfo.mas_bottom).offset(15);
    }];
    
    // Continue button with beautiful gradient
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.layer.cornerRadius = 20;
    continueButton.layer.borderWidth = 3;
    continueButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    
    // Add button glow
    continueButton.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    continueButton.layer.shadowOffset = CGSizeMake(0, 0);
    continueButton.layer.shadowOpacity = 0.8;
    continueButton.layer.shadowRadius = 10;
    
    // Create continue button gradient
    CAGradientLayer *continueGradient = [CAGradientLayer layer];
    continueGradient.frame = CGRectMake(0, 0, 200, 50);
    continueGradient.colors = @[
        (id)[UIColor colorWithRed:0.3 green:0.9 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:1.0].CGColor
    ];
    continueGradient.startPoint = CGPointMake(0.0, 0.0);
    continueGradient.endPoint = CGPointMake(1.0, 1.0);
    continueGradient.cornerRadius = 20;
    [continueButton.layer insertSublayer:continueGradient atIndex:0];
    
    [continueButton setTitle:@"🎮 Continue Playing 🎮" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    continueButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    continueButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    continueButton.titleLabel.layer.shadowOpacity = 1.0;
    continueButton.titleLabel.layer.shadowRadius = 2;
    
    [victoryCard addSubview:continueButton];
    
    [continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(victoryCard);
        make.bottom.equalTo(victoryCard).offset(-30);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    // Add button tap handler
    [continueButton addTarget:self action:@selector(continueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add tap gesture to overlay (for backup dismissal)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVictoryDialog:)];
    [overlayView addGestureRecognizer:tapGesture];
    
    // Store references for later cleanup
    objc_setAssociatedObject(self, @"victoryOverlay", overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"victoryCard", victoryCard, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"gameManager", gameManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"animalIndex", @(animalIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"reward", @(reward), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"sparkleEmitter", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC); // Clear previous emitter
    
    // Show animation
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        victoryCard.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // Add celebration animations
        [self startCelebrationAnimations:victoryCard];
    }];
}

- (void)startCelebrationAnimations:(UIView *)victoryCard {
    // Add pulsing glow to victory card
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    pulseAnimation.fromValue = @15;
    pulseAnimation.toValue = @30;
    pulseAnimation.duration = 1.0;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = INFINITY;
    [victoryCard.layer addAnimation:pulseAnimation forKey:@"pulseGlow"];
    
    // Add sparkle particles
    [self addSparkleParticles:victoryCard];
    
    // Add border color animation
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    borderColorAnimation.toValue = (id)[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0].CGColor;
    borderColorAnimation.duration = 0.8;
    borderColorAnimation.autoreverses = YES;
    borderColorAnimation.repeatCount = INFINITY;
    [victoryCard.layer addAnimation:borderColorAnimation forKey:@"borderColorAnimation"];
}

- (void)addSparkleParticles:(UIView *)victoryCard {
    // Create sparkle emitter
    CAEmitterLayer *sparkleEmitter = [CAEmitterLayer layer];
    sparkleEmitter.emitterPosition = CGPointMake(160, 200);
    sparkleEmitter.emitterSize = CGSizeMake(320, 400);
    sparkleEmitter.emitterShape = kCAEmitterLayerRectangle;
    
    CAEmitterCell *sparkle = [CAEmitterCell emitterCell];
    sparkle.birthRate = 20;
    sparkle.lifetime = 2.0;
    sparkle.velocity = 100;
    sparkle.velocityRange = 50;
    sparkle.emissionRange = 2 * M_PI;
    sparkle.scale = 0.5;
    sparkle.scaleRange = 0.3;
    sparkle.alphaSpeed = -0.5;
    sparkle.color = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    sparkle.contents = (id)[self createSparkleImage].CGImage;
    
    sparkleEmitter.emitterCells = @[sparkle];
    [victoryCard.layer addSublayer:sparkleEmitter];
    
    // Store emitter reference
    objc_setAssociatedObject(self, @"sparkleEmitter", sparkleEmitter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)createSparkleImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(12, 12), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 12, 12));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)continueButtonTapped:(UIButton *)sender {
    [self dismissVictoryDialog:nil];
}

- (void)dismissVictoryDialog:(UITapGestureRecognizer *)gesture {
    UIView *overlayView = objc_getAssociatedObject(self, @"victoryOverlay");
    UIView *victoryCard = objc_getAssociatedObject(self, @"victoryCard");
    GameDataManager *gameManager = objc_getAssociatedObject(self, @"gameManager");
    NSNumber *animalIndex = objc_getAssociatedObject(self, @"animalIndex");
    NSNumber *reward = objc_getAssociatedObject(self, @"reward");
    CAEmitterLayer *sparkleEmitter = objc_getAssociatedObject(self, @"sparkleEmitter");
    
    if (!overlayView || !victoryCard || !gameManager || !animalIndex || !reward) return;
    
    // Cleanup animations
    [victoryCard.layer removeAllAnimations];
    if (sparkleEmitter) {
        [sparkleEmitter removeFromSuperlayer];
    }
    
    // Hide animation
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 0.0;
        victoryCard.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        
        // Apply game rewards
        [gameManager earnCoins:reward.integerValue];
        [gameManager levelUp];
        [self setupGameData];
        
        // Clear associated objects
        objc_setAssociatedObject(self, @"victoryOverlay", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"victoryCard", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"gameManager", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"animalIndex", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"reward", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"sparkleEmitter", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    
    // Update button gradient frames
    [self updateButtonGradientFrames];
}

// 添加方法来更新按钮渐变层的frame
- (void)updateButtonGradientFrames {
    // Update spin button gradient
    for (CALayer *layer in self.spinButton.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.spinButton.bounds;
            break;
        }
    }
    
    // Update back button gradient
    for (CALayer *layer in self.backButton.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.backButton.bounds;
            break;
        }
    }
    
    // Update reset button gradient
    for (CALayer *layer in self.resetButton.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.resetButton.bounds;
            break;
        }
    }
} 

@end 