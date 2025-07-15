//
//  GuessFirstViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "GuessFirstViewController.h"
#import "GameDataManager.h"
#import "SlotMachineView.h"
#import "AnimalRaceView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@interface GuessFirstViewController () <SlotMachineViewDelegate, AnimalRaceViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *coinsLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) SlotMachineView *slotMachineView;
@property (nonatomic, strong) AnimalRaceView *animalRaceView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *resetButton;

@property (nonatomic, assign) NSInteger selectedAnimalIndex;
@property (nonatomic, assign) NSInteger winnerAnimalIndex;
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, assign) BOOL gameStarted;

@end

@implementation GuessFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupGameData];
    
    // 添加调试：检查按钮设置
    // [self debugButtonSetup]; // 删除
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 测试按钮点击检测
    // [self testButtonHitTest]; // 删除
}

// 删除testButtonHitTest和debugButtonSetup调试方法

- (void)setupUI {
    // Cartoon-style prediction game gradient background
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create animated lottery/prediction themed gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0].CGColor,  // Lucky green
        (id)[UIColor colorWithRed:0.1 green:0.6 blue:0.3 alpha:1.0].CGColor,  // Forest green
        (id)[UIColor colorWithRed:0.05 green:0.4 blue:0.2 alpha:1.0].CGColor, // Dark green
        (id)[UIColor colorWithRed:0.3 green:0.9 blue:0.5 alpha:1.0].CGColor   // Bright green
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.view.bounds;
    gradientLayer.name = @"backgroundGradient";
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // Add animated color transition for lucky atmosphere
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnimation.fromValue = gradientLayer.colors;
    colorAnimation.toValue = @[
        (id)[UIColor colorWithRed:0.3 green:0.9 blue:0.5 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.1 green:0.6 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.05 green:0.4 blue:0.2 alpha:1.0].CGColor
    ];
    colorAnimation.duration = 4.0;
    colorAnimation.repeatCount = INFINITY;
    colorAnimation.autoreverses = YES;
    [gradientLayer addAnimation:colorAnimation forKey:@"colorTransition"];
    
    // Add floating prediction and animal emojis
    [self addFloatingPredictionEmojis];
    
    // Title label with lucky prediction style
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"🎯🍀 Guess First 🍀🎯";
    self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:26];  // Reduced from 32 to 26
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.8;
    
    // Add lucky golden glow effect
    self.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.0 alpha:1.0].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.titleLabel.layer.shadowOpacity = 1.0;
    self.titleLabel.layer.shadowRadius = 12;
    
    // Add lucky sparkle animation
    CABasicAnimation *sparkleAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    sparkleAnimation.fromValue = @0.5;
    sparkleAnimation.toValue = @1.0;
    sparkleAnimation.duration = 1.2;
    sparkleAnimation.repeatCount = INFINITY;
    sparkleAnimation.autoreverses = YES;
    [self.titleLabel.layer addAnimation:sparkleAnimation forKey:@"sparkleAnimation"];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);  // Reduced from 20 to 5
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Coins label with treasure chest style
    self.coinsLabel = [[UILabel alloc] init];
    self.coinsLabel.text = @"💰 Coins: 3000";
    self.coinsLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.0 alpha:1.0];
    self.coinsLabel.font = [UIFont boldSystemFontOfSize:20];  // Reduced from 24 to 20
    self.coinsLabel.textAlignment = NSTextAlignmentCenter;
    self.coinsLabel.numberOfLines = 1;
    self.coinsLabel.adjustsFontSizeToFitWidth = YES;
    self.coinsLabel.minimumScaleFactor = 0.8;
    
    // Add golden treasure glow
    self.coinsLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
    self.coinsLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.coinsLabel.layer.shadowOpacity = 0.8;
    self.coinsLabel.layer.shadowRadius = 8;
    
    [self.view addSubview:self.coinsLabel];
    
    [self.coinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);  // Reduced from 15 to 8
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Instruction label with magic style
    self.instructionLabel = [[UILabel alloc] init];
    self.instructionLabel.text = @"🔮 Pay 200 coins to start the prediction game! 🔮";
    self.instructionLabel.textColor = [UIColor whiteColor];
    self.instructionLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.numberOfLines = 0;
    
    // Add mystical glow
    self.instructionLabel.layer.shadowColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.8 alpha:1.0].CGColor;
    self.instructionLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.instructionLabel.layer.shadowOpacity = 0.6;
    self.instructionLabel.layer.shadowRadius = 6;
    
    [self.view addSubview:self.instructionLabel];
    
    [self.instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.coinsLabel.mas_bottom).offset(15);  // Increased spacing
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Game rules explanation
    UILabel *rulesLabel = [[UILabel alloc] init];
    rulesLabel.text = @"🏁 Each animal needs 100 steps to reach the finish line\n🎯 Guess which animal will finish first\n💰 Win 1000 coins if you guess correctly!";
    rulesLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:1.0];
    rulesLabel.font = [UIFont systemFontOfSize:14];
    rulesLabel.textAlignment = NSTextAlignmentCenter;
    rulesLabel.numberOfLines = 0;
    rulesLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    rulesLabel.layer.shadowOffset = CGSizeMake(0, 1);
    rulesLabel.layer.shadowOpacity = 1.0;
    rulesLabel.layer.shadowRadius = 2;
    [self.view addSubview:rulesLabel];
    
    [rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.instructionLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    // REMOVED: Animal selection container is no longer needed here
    // It will be shown as a popup dialog after clicking START
    
    // Slot machine view with prediction style
    self.slotMachineView = [[SlotMachineView alloc] init];
    self.slotMachineView.delegate = self;
    self.slotMachineView.hidden = NO;  // 修改：让slot machine一直显示
    self.slotMachineView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    self.slotMachineView.layer.cornerRadius = 15;
    self.slotMachineView.layer.borderWidth = 3;
    self.slotMachineView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    
    // Add prediction machine glow
    self.slotMachineView.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    self.slotMachineView.layer.shadowOffset = CGSizeMake(0, 0);
    self.slotMachineView.layer.shadowOpacity = 0.6;
    self.slotMachineView.layer.shadowRadius = 10;
    
    [self.view addSubview:self.slotMachineView];
    
    [self.slotMachineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(rulesLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@100);  // Reduced from 120 to 100
    }];
    
    // Animal race view with prediction track
    self.animalRaceView = [[AnimalRaceView alloc] initWithTotalSteps:100];
    self.animalRaceView.delegate = self;
    self.animalRaceView.hidden = NO;  // 修改：让动物赛道一直显示
    self.animalRaceView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.7 alpha:0.3];
    // 移除重复的边框设置，因为AnimalRaceView本身已经有边框了
    // self.animalRaceView.layer.cornerRadius = 15;
    // self.animalRaceView.layer.borderWidth = 3;
    // self.animalRaceView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.2 alpha:1.0].CGColor;
    
    // Add race prediction track shadow
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
        make.height.equalTo(@350);  // 增加高度：确保10个动物轨道完全显示在轨道容器内
    }];
    
    // Button container with flexible height
    UIView *buttonContainer = [[UIView alloc] init];
    buttonContainer.backgroundColor = [UIColor clearColor];  // 添加：确保容器背景透明
    buttonContainer.userInteractionEnabled = YES;  // 确保容器可以传递触摸事件
    buttonContainer.layer.zPosition = 10;  // 确保按钮容器在最上层
    [self.view addSubview:buttonContainer];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.animalRaceView.mas_bottom).offset(8);  // Reduced from 20 to 8
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuide).offset(-10);  // Use lessThanOrEqualTo for flexibility
    }];
    
    // Start button with prediction lottery style
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.backgroundColor = [UIColor clearColor];  // 添加：确保按钮背景透明
    self.startButton.layer.cornerRadius = 20;
    self.startButton.layer.borderWidth = 4;
    self.startButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add prediction magic glow
    self.startButton.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    self.startButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.startButton.layer.shadowOpacity = 0.8;
    self.startButton.layer.shadowRadius = 15;
    
    // Create prediction green gradient - 确保不会阻挡触摸事件
    CAGradientLayer *startGradient = [CAGradientLayer layer];
    startGradient.colors = @[
        (id)[UIColor colorWithRed:0.2 green:0.8 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1.0].CGColor
    ];
    startGradient.startPoint = CGPointMake(0.0, 0.0);
    startGradient.endPoint = CGPointMake(1.0, 1.0);
    startGradient.cornerRadius = 20;
    startGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    // frame will be updated in viewDidLayoutSubviews
    [self.startButton.layer insertSublayer:startGradient atIndex:0];
    
    [self.startButton setTitle:@"🎯✨ START PREDICTION! (200 Coins) ✨🎯" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 20 to 16
    self.startButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    self.startButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.startButton.titleLabel.layer.shadowOpacity = 1.0;
    self.startButton.titleLabel.layer.shadowRadius = 3;
    
    // 确保按钮可以接收触摸事件
    self.startButton.userInteractionEnabled = YES;
    // 确保按钮在最上层
    self.startButton.layer.zPosition = 1;
    
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.startButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.startButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.startButton];
    
    // Back button with simple style
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor clearColor];  // 添加：确保按钮背景透明
    self.backButton.layer.cornerRadius = 12;
    self.backButton.layer.borderWidth = 2;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Create simple back gradient - 确保不会阻挡触摸事件
    CAGradientLayer *backGradient = [CAGradientLayer layer];
    backGradient.colors = @[
        (id)[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor
    ];
    backGradient.startPoint = CGPointMake(0.0, 0.0);
    backGradient.endPoint = CGPointMake(1.0, 1.0);
    backGradient.cornerRadius = 12;
    backGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    // frame will be updated in viewDidLayoutSubviews
    [self.backButton.layer insertSublayer:backGradient atIndex:0];
    
    [self.backButton setTitle:@"🏠 Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    
    // 确保按钮可以接收触摸事件
    self.backButton.userInteractionEnabled = YES;
    // 确保按钮在最上层
    self.backButton.layer.zPosition = 1;
    
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.backButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.backButton];
    
    // Reset button with prediction style
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetButton.backgroundColor = [UIColor clearColor];  // 添加：确保按钮背景透明
    self.resetButton.layer.cornerRadius = 12;
    self.resetButton.layer.borderWidth = 2;
    self.resetButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Create reset gradient - 确保不会阻挡触摸事件
    CAGradientLayer *resetGradient = [CAGradientLayer layer];
    resetGradient.colors = @[
        (id)[UIColor colorWithRed:0.7 green:0.4 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.5 green:0.2 blue:0.1 alpha:1.0].CGColor
    ];
    resetGradient.startPoint = CGPointMake(0.0, 0.0);
    resetGradient.endPoint = CGPointMake(1.0, 1.0);
    resetGradient.cornerRadius = 12;
    resetGradient.zPosition = -1;  // 确保渐变层在按钮内容之下
    // frame will be updated in viewDidLayoutSubviews
    [self.resetButton.layer insertSublayer:resetGradient atIndex:0];
    
    [self.resetButton setTitle:@"🔄 Reset" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];  // Reduced from 18 to 16
    
    // 确保按钮可以接收触摸事件
    self.resetButton.userInteractionEnabled = YES;
    // 确保按钮在最上层
    self.resetButton.layer.zPosition = 1;
    
    [self.resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Add bounce animation on touch
    [self.resetButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.resetButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [buttonContainer addSubview:self.resetButton];
    
    // Layout buttons with optimized height
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer);
        make.top.equalTo(buttonContainer).offset(5);  // Reduced from 10 to 5
        make.left.equalTo(buttonContainer).offset(20);
        make.right.equalTo(buttonContainer).offset(-20);
        make.height.equalTo(@55);  // 增加高度：从50增加到55
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonContainer).offset(20);
        make.top.equalTo(self.startButton.mas_bottom).offset(8);  // Reduced from 15 to 8
        make.width.equalTo(buttonContainer).multipliedBy(0.45);
        make.height.equalTo(@40);  // 增加高度：从35增加到40
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonContainer).offset(-20);
        make.top.equalTo(self.startButton.mas_bottom).offset(8);  // Reduced from 15 to 8
        make.width.equalTo(buttonContainer).multipliedBy(0.45);
        make.height.equalTo(@40);  // 增加高度：从35增加到40
        make.bottom.equalTo(buttonContainer).offset(-5);  // 添加底部约束
    }];
}

- (void)addFloatingPredictionEmojis {
    // Add floating prediction and fortune emojis as background decoration
    NSArray *predictionEmojis = @[@"🎯", @"🍀", @"🔮", @"⭐", @"🌟", @"✨", @"🎊", @"🎉", @"🏆", @"💎"];
    
    for (int i = 0; i < 12; i++) {
        UILabel *emojiLabel = [[UILabel alloc] init];
        emojiLabel.text = predictionEmojis[i % predictionEmojis.count];
        emojiLabel.font = [UIFont systemFontOfSize:22];
        emojiLabel.alpha = 0.4;
        emojiLabel.userInteractionEnabled = NO;  // 确保不会阻挡触摸事件
        emojiLabel.layer.zPosition = -10;  // 确保在最底层
        [self.view addSubview:emojiLabel];
        
        // Random position - 避免在按钮区域
        CGFloat x = arc4random_uniform(350) + 30;
        CGFloat y = arc4random_uniform(500) + 100;  // 减少y范围避免按钮区域
        emojiLabel.frame = CGRectMake(x, y, 25, 25);
        
        // Add twinkling animation like lucky stars
        CABasicAnimation *twinkleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        twinkleAnimation.fromValue = @0.2;
        twinkleAnimation.toValue = @0.8;
        twinkleAnimation.duration = 1.0 + (arc4random_uniform(100) / 100.0);
        twinkleAnimation.repeatCount = INFINITY;
        twinkleAnimation.autoreverses = YES;
        twinkleAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(100) / 100.0);
        [emojiLabel.layer addAnimation:twinkleAnimation forKey:@"twinkleAnimation"];
        
        // Add floating animation
        CABasicAnimation *floatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        floatAnimation.fromValue = @0;
        floatAnimation.toValue = @(-15);
        floatAnimation.duration = 2.5 + (arc4random_uniform(100) / 100.0);
        floatAnimation.repeatCount = INFINITY;
        floatAnimation.autoreverses = YES;
        floatAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(200) / 100.0);
        [emojiLabel.layer addAnimation:floatAnimation forKey:@"floatAnimation"];
        
        // Add subtle rotation for mystical effect
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = @(-M_PI / 12);
        rotateAnimation.toValue = @(M_PI / 12);
        rotateAnimation.duration = 3.0 + (arc4random_uniform(200) / 100.0);
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.autoreverses = YES;
        rotateAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(150) / 100.0);
        [emojiLabel.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
}

- (void)setupGameData {
    self.selectedAnimalIndex = -1;
    self.winnerAnimalIndex = -1;
    self.gameInProgress = NO;
    self.gameStarted = NO;
    [self updateUI];
}

- (void)updateUI {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    self.coinsLabel.text = [NSString stringWithFormat:@"💰 Coins: %ld", (long)gameManager.coins];
    
    // Update start button state
    BOOL canStart = [gameManager canSpinWithCost:200] && !self.gameStarted;
    self.startButton.enabled = canStart;
    self.startButton.alpha = canStart ? 1.0 : 0.5;
    
    // Update instruction text
    if (self.gameStarted) {
        if (self.selectedAnimalIndex >= 0) {
            self.instructionLabel.text = [NSString stringWithFormat:@"🔮 You chose Animal-%ld. Auto-spinning in progress... 🔮", (long)self.selectedAnimalIndex];
        } else {
            self.instructionLabel.text = @"🔮 Auto-spinning in progress... 🔮";
        }
    } else {
        self.instructionLabel.text = @"🔮 Pay 200 coins to start the prediction game! 🔮";
    }
}

- (void)startButtonTapped {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    if (![gameManager canSpinWithCost:200]) {
        [self showInsufficientCoinsAlert];
        return;
    }
    
    // Show animal selection dialog first
    [self showAnimalSelectionDialog];
}

- (void)showAnimalSelectionDialog {
    // Create overlay
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    overlayView.alpha = 0.0;
    [self.view addSubview:overlayView];
    
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Create selection dialog
    UIView *selectionDialog = [[UIView alloc] init];
    selectionDialog.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    selectionDialog.layer.cornerRadius = 25;
    selectionDialog.layer.borderWidth = 5;
    selectionDialog.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add dialog glow effect
    selectionDialog.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    selectionDialog.layer.shadowOffset = CGSizeMake(0, 0);
    selectionDialog.layer.shadowOpacity = 0.8;
    selectionDialog.layer.shadowRadius = 20;
    
    selectionDialog.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [overlayView addSubview:selectionDialog];
    
    [selectionDialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(overlayView);
        make.centerY.equalTo(overlayView).offset(-30);
        make.width.equalTo(@340);
        make.height.equalTo(@450);
    }];
    
    // Add dialog gradient background
    CAGradientLayer *dialogGradient = [CAGradientLayer layer];
    dialogGradient.frame = CGRectMake(0, 0, 340, 450);
    dialogGradient.colors = @[
        (id)[UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:0.95].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:0.95].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.95 blue:0.8 alpha:0.95].CGColor
    ];
    dialogGradient.startPoint = CGPointMake(0.0, 0.0);
    dialogGradient.endPoint = CGPointMake(1.0, 1.0);
    dialogGradient.cornerRadius = 25;
    [selectionDialog.layer insertSublayer:dialogGradient atIndex:0];
    
    // Dialog title
    UILabel *dialogTitle = [[UILabel alloc] init];
    dialogTitle.text = @"🔮✨ Choose Your Prediction ✨🔮";
    dialogTitle.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    dialogTitle.font = [UIFont boldSystemFontOfSize:20];
    dialogTitle.textAlignment = NSTextAlignmentCenter;
    dialogTitle.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    dialogTitle.layer.shadowOffset = CGSizeMake(0, 2);
    dialogTitle.layer.shadowOpacity = 1.0;
    dialogTitle.layer.shadowRadius = 3;
    [selectionDialog addSubview:dialogTitle];
    
    [dialogTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectionDialog);
        make.top.equalTo(selectionDialog).offset(20);
    }];
    
    // Instruction
    UILabel *dialogInstruction = [[UILabel alloc] init];
    dialogInstruction.text = @"Which animal will reach 100 steps first?";
    dialogInstruction.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0];
    dialogInstruction.font = [UIFont systemFontOfSize:16];
    dialogInstruction.textAlignment = NSTextAlignmentCenter;
    [selectionDialog addSubview:dialogInstruction];
    
    [dialogInstruction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectionDialog);
        make.top.equalTo(dialogTitle.mas_bottom).offset(10);
    }];
    
    // Create animal selection grid
    UIView *gridContainer = [[UIView alloc] init];
    [selectionDialog addSubview:gridContainer];
    
    [gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectionDialog);
        make.top.equalTo(dialogInstruction.mas_bottom).offset(20);
        make.width.equalTo(@280);
        make.height.equalTo(@280);
    }];
    
    // Create 10 animal buttons in a 5x2 grid
    for (int i = 0; i < 10; i++) {
        UIButton *animalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        animalButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.95 blue:0.8 alpha:1.0];
        animalButton.layer.cornerRadius = 12;
        animalButton.layer.borderWidth = 2;
        animalButton.layer.borderColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.6 alpha:1.0].CGColor;
        animalButton.tag = i;
        
        // Add button shadow
        animalButton.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.15].CGColor;
        animalButton.layer.shadowOffset = CGSizeMake(0, 3);
        animalButton.layer.shadowOpacity = 1.0;
        animalButton.layer.shadowRadius = 5;
        
        [animalButton addTarget:self action:@selector(animalDialogButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [gridContainer addSubview:animalButton];
        
        // Animal image
        UIImageView *animalImageView = [[UIImageView alloc] init];
        animalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%d", i]];
        animalImageView.contentMode = UIViewContentModeScaleAspectFit;
        animalImageView.userInteractionEnabled = NO;
        [animalButton addSubview:animalImageView];
        
        // Animal label
        UILabel *animalLabel = [[UILabel alloc] init];
        animalLabel.text = [NSString stringWithFormat:@"%d", i];
        animalLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
        animalLabel.font = [UIFont boldSystemFontOfSize:14];
        animalLabel.textAlignment = NSTextAlignmentCenter;
        animalLabel.userInteractionEnabled = NO;
        [animalButton addSubview:animalLabel];
        
        // Layout in 5x2 grid
        CGFloat buttonSize = 50;
        CGFloat spacing = 6;
        NSInteger row = i / 5;
        NSInteger col = i % 5;
        
        [animalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gridContainer).offset(col * (buttonSize + spacing));
            make.top.equalTo(gridContainer).offset(row * (buttonSize + spacing) + row * 80);
            make.width.height.equalTo(@(buttonSize));
        }];
        
        [animalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(animalButton);
            make.top.equalTo(animalButton).offset(8);
            make.width.height.equalTo(@28);
        }];
        
        [animalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(animalButton);
            make.bottom.equalTo(animalButton).offset(-5);
        }];
    }
    
    // Cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.borderWidth = 2;
    cancelButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0].CGColor;
    
    CAGradientLayer *cancelGradient = [CAGradientLayer layer];
    cancelGradient.frame = CGRectMake(0, 0, 100, 40);
    cancelGradient.colors = @[
        (id)[UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1.0].CGColor
    ];
    cancelGradient.cornerRadius = 15;
    [cancelButton.layer insertSublayer:cancelGradient atIndex:0];
    
    [cancelButton setTitle:@"❌ Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancelAnimalSelection:) forControlEvents:UIControlEventTouchUpInside];
    [selectionDialog addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectionDialog);
        make.bottom.equalTo(selectionDialog).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    // Store references
    objc_setAssociatedObject(self, @"selectionOverlay", overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"selectionDialog", selectionDialog, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Show animation
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        selectionDialog.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)animalDialogButtonTapped:(UIButton *)sender {
    // Store selected animal
    self.selectedAnimalIndex = sender.tag;
    
    // Dismiss dialog
    [self dismissAnimalSelectionDialog];
    
    // Start the game
    [self startGameWithSelectedAnimal];
}

- (void)cancelAnimalSelection:(UIButton *)sender {
    [self dismissAnimalSelectionDialog];
}

- (void)dismissAnimalSelectionDialog {
    UIView *overlayView = objc_getAssociatedObject(self, @"selectionOverlay");
    UIView *selectionDialog = objc_getAssociatedObject(self, @"selectionDialog");
    
    if (!overlayView || !selectionDialog) return;
    
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 0.0;
        selectionDialog.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        
        // Clear references
        objc_setAssociatedObject(self, @"selectionOverlay", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"selectionDialog", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (void)startGameWithSelectedAnimal {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    
    // Deduct coins
    [gameManager spendCoins:200];
    self.gameStarted = YES;
    self.gameInProgress = YES;
    
    // 移除：不再需要显示视图，因为它们已经一直显示
    // self.slotMachineView.hidden = NO;
    // self.animalRaceView.hidden = NO;
    
    [self updateUI];
    
    // Start auto-spinning
    [self startAutoSpinning];
}

- (void)startAutoSpinning {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gameInProgress) {
            [self.slotMachineView spinWithRandomAnimal];
        }
    });
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetButtonTapped {
    // Reset all game state
    [self.animalRaceView resetAllAnimals];
    [self.slotMachineView reset];
    
    // 移除：不再需要隐藏视图，因为它们应该一直显示
    // self.slotMachineView.hidden = YES;
    // self.animalRaceView.hidden = YES;
    
    [self setupGameData];
}

- (void)showInsufficientCoinsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Coins" 
                                                                   message:@"You need 200 coins to start this game." 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showGameResultAlert:(NSInteger)winnerIndex {
    GameDataManager *gameManager = [GameDataManager sharedManager];
    BOOL isCorrectGuess = (winnerIndex == self.selectedAnimalIndex);
    
    // Create custom result dialog overlay
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    overlayView.alpha = 0.0;
    [self.view addSubview:overlayView];
    
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Create result card
    UIView *resultCard = [[UIView alloc] init];
    resultCard.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    resultCard.layer.cornerRadius = 25;
    resultCard.layer.borderWidth = 5;
    
    if (isCorrectGuess) {
        resultCard.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
        resultCard.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    } else {
        resultCard.layer.borderColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0].CGColor;
        resultCard.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0].CGColor;
    }
    
    resultCard.layer.shadowOffset = CGSizeMake(0, 0);
    resultCard.layer.shadowOpacity = 0.8;
    resultCard.layer.shadowRadius = 20;
    
    resultCard.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [overlayView addSubview:resultCard];
    
    [resultCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(overlayView);
        make.centerY.equalTo(overlayView).offset(-50);
        make.width.equalTo(@340);
        make.height.equalTo(@450);
    }];
    
    // Add result gradient background
    CAGradientLayer *resultGradient = [CAGradientLayer layer];
    resultGradient.frame = CGRectMake(0, 0, 340, 450);
    if (isCorrectGuess) {
        resultGradient.colors = @[
            (id)[UIColor colorWithRed:0.7 green:1.0 blue:0.7 alpha:0.9].CGColor,
            (id)[UIColor colorWithRed:0.8 green:0.9 blue:1.0 alpha:0.9].CGColor,
            (id)[UIColor colorWithRed:0.9 green:0.8 blue:1.0 alpha:0.9].CGColor
        ];
    } else {
        resultGradient.colors = @[
            (id)[UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:0.9].CGColor,
            (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:0.9].CGColor,
            (id)[UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:0.9].CGColor
        ];
    }
    resultGradient.startPoint = CGPointMake(0.0, 0.0);
    resultGradient.endPoint = CGPointMake(1.0, 1.0);
    resultGradient.cornerRadius = 25;
    [resultCard.layer insertSublayer:resultGradient atIndex:0];
    
    // Result title
    UILabel *resultTitle = [[UILabel alloc] init];
    if (isCorrectGuess) {
        resultTitle.text = @"🎉🔮 CORRECT GUESS! 🎉";
        resultTitle.textColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    } else {
        resultTitle.text = @"😔🔮 WRONG GUESS 🔮😔";
        resultTitle.textColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    }
    resultTitle.font = [UIFont boldSystemFontOfSize:22];
    resultTitle.textAlignment = NSTextAlignmentCenter;
    resultTitle.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    resultTitle.layer.shadowOffset = CGSizeMake(0, 2);
    resultTitle.layer.shadowOpacity = 1.0;
    resultTitle.layer.shadowRadius = 5;
    [resultCard addSubview:resultTitle];
    
    [resultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultCard);
        make.top.equalTo(resultCard).offset(20);
    }];
    
    // Winner animal image
    UIImageView *winnerAnimal = [[UIImageView alloc] init];
    winnerAnimal.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%ld", (long)winnerIndex]];
    winnerAnimal.contentMode = UIViewContentModeScaleAspectFit;
    winnerAnimal.layer.cornerRadius = 35;
    winnerAnimal.layer.borderWidth = 3;
    winnerAnimal.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    winnerAnimal.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.8 alpha:1.0];
    
    winnerAnimal.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    winnerAnimal.layer.shadowOffset = CGSizeMake(0, 0);
    winnerAnimal.layer.shadowOpacity = 0.8;
    winnerAnimal.layer.shadowRadius = 12;
    
    [resultCard addSubview:winnerAnimal];
    
    [winnerAnimal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultCard).offset(-60);
        make.top.equalTo(resultTitle.mas_bottom).offset(15);
        make.width.height.equalTo(@70);
    }];
    
    // Your guess animal image
    UIImageView *guessAnimal = [[UIImageView alloc] init];
    guessAnimal.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%ld", (long)self.selectedAnimalIndex]];
    guessAnimal.contentMode = UIViewContentModeScaleAspectFit;
    guessAnimal.layer.cornerRadius = 35;
    guessAnimal.layer.borderWidth = 3;
    guessAnimal.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.8 alpha:1.0].CGColor;
    guessAnimal.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0];
    
    guessAnimal.layer.shadowColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.8 alpha:1.0].CGColor;
    guessAnimal.layer.shadowOffset = CGSizeMake(0, 0);
    guessAnimal.layer.shadowOpacity = 0.8;
    guessAnimal.layer.shadowRadius = 12;
    
    [resultCard addSubview:guessAnimal];
    
    [guessAnimal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultCard).offset(60);
        make.top.equalTo(resultTitle.mas_bottom).offset(15);
        make.width.height.equalTo(@70);
    }];
    
    // Winner label
    UILabel *winnerLabel = [[UILabel alloc] init];
    winnerLabel.text = @"🏆 Winner";
    winnerLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    winnerLabel.font = [UIFont boldSystemFontOfSize:14];
    winnerLabel.textAlignment = NSTextAlignmentCenter;
    [resultCard addSubview:winnerLabel];
    
    [winnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(winnerAnimal);
        make.top.equalTo(winnerAnimal.mas_bottom).offset(5);
    }];
    
    // Your guess label
    UILabel *guessLabel = [[UILabel alloc] init];
    guessLabel.text = @"🔮 Your Guess";
    guessLabel.textColor = [UIColor colorWithRed:0.6 green:0.4 blue:0.8 alpha:1.0];
    guessLabel.font = [UIFont boldSystemFontOfSize:14];
    guessLabel.textAlignment = NSTextAlignmentCenter;
    [resultCard addSubview:guessLabel];
    
    [guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(guessAnimal);
        make.top.equalTo(guessAnimal.mas_bottom).offset(5);
    }];
    
    // Result message
    UILabel *resultMessage = [[UILabel alloc] init];
    if (isCorrectGuess) {
        resultMessage.text = [NSString stringWithFormat:@"🎯 Amazing! You predicted Animal-%ld would win first!\\n\\n💰 Reward: 1000 Coins! 💰", (long)winnerIndex];
        resultMessage.textColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:1.0];
    } else {
        resultMessage.text = [NSString stringWithFormat:@"😔 Animal-%ld won first, but you guessed Animal-%ld.\\n\\n💸 No reward this time. 💸", (long)winnerIndex, (long)self.selectedAnimalIndex];
        resultMessage.textColor = [UIColor colorWithRed:0.7 green:0.3 blue:0.3 alpha:1.0];
    }
    resultMessage.font = [UIFont systemFontOfSize:16];
    resultMessage.textAlignment = NSTextAlignmentCenter;
    resultMessage.numberOfLines = 0;
    resultMessage.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    resultMessage.layer.shadowOffset = CGSizeMake(0, 1);
    resultMessage.layer.shadowOpacity = 1.0;
    resultMessage.layer.shadowRadius = 2;
    [resultCard addSubview:resultMessage];
    
    [resultMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultCard);
        make.top.equalTo(winnerLabel.mas_bottom).offset(20);
        make.left.equalTo(resultCard).offset(20);
        make.right.equalTo(resultCard).offset(-20);
    }];
    
    // OK button
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.layer.cornerRadius = 20;
    okButton.layer.borderWidth = 3;
    
    if (isCorrectGuess) {
        okButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
        okButton.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    } else {
        okButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.0 alpha:1.0].CGColor;
        okButton.layer.shadowColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.0 alpha:1.0].CGColor;
    }
    
    okButton.layer.shadowOffset = CGSizeMake(0, 0);
    okButton.layer.shadowOpacity = 0.8;
    okButton.layer.shadowRadius = 10;
    
    // Create OK button gradient
    CAGradientLayer *okGradient = [CAGradientLayer layer];
    okGradient.frame = CGRectMake(0, 0, 200, 50);
    if (isCorrectGuess) {
        okGradient.colors = @[
            (id)[UIColor colorWithRed:0.3 green:0.9 blue:0.3 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:1.0].CGColor
        ];
    } else {
        okGradient.colors = @[
            (id)[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.8 green:0.4 blue:0.0 alpha:1.0].CGColor
        ];
    }
    okGradient.startPoint = CGPointMake(0.0, 0.0);
    okGradient.endPoint = CGPointMake(1.0, 1.0);
    okGradient.cornerRadius = 20;
    [okButton.layer insertSublayer:okGradient atIndex:0];
    
    [okButton setTitle:@"🎮 Play Again 🎮" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    okButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    okButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    okButton.titleLabel.layer.shadowOpacity = 1.0;
    okButton.titleLabel.layer.shadowRadius = 2;
    
    [resultCard addSubview:okButton];
    
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultCard);
        make.bottom.equalTo(resultCard).offset(-25);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    // Add button tap handler
    [okButton addTarget:self action:@selector(okButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add tap gesture to overlay
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissResultDialog:)];
    [overlayView addGestureRecognizer:tapGesture];
    
    // Store references
    objc_setAssociatedObject(self, @"resultOverlay", overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"resultCard", resultCard, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"gameManager", gameManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"isCorrectGuess", @(isCorrectGuess), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Apply reward if correct guess
    if (isCorrectGuess) {
        [gameManager earnCoins:1000];
    }
    
    // Show animation
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        resultCard.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (isCorrectGuess) {
            [self startCelebrationAnimations:resultCard];
        } else {
            [self startConsoleAnimations:resultCard];
        }
    }];
}

- (void)startCelebrationAnimations:(UIView *)resultCard {
    // Success pulsing glow
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    pulseAnimation.fromValue = @15;
    pulseAnimation.toValue = @30;
    pulseAnimation.duration = 1.0;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = INFINITY;
    [resultCard.layer addAnimation:pulseAnimation forKey:@"pulseGlow"];
    
    // Success sparkle particles
    [self addSparkleParticles:resultCard];
    
    // Success border color animation
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = (id)[UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    borderColorAnimation.toValue = (id)[UIColor colorWithRed:0.8 green:1.0 blue:0.2 alpha:1.0].CGColor;
    borderColorAnimation.duration = 0.8;
    borderColorAnimation.autoreverses = YES;
    borderColorAnimation.repeatCount = INFINITY;
    [resultCard.layer addAnimation:borderColorAnimation forKey:@"borderColorAnimation"];
}

- (void)startConsoleAnimations:(UIView *)resultCard {
    // Console gentle glow
    CABasicAnimation *gentleGlow = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    gentleGlow.fromValue = @15;
    gentleGlow.toValue = @25;
    gentleGlow.duration = 1.5;
    gentleGlow.autoreverses = YES;
    gentleGlow.repeatCount = INFINITY;
    [resultCard.layer addAnimation:gentleGlow forKey:@"gentleGlow"];
}

- (void)addSparkleParticles:(UIView *)resultCard {
    // Create sparkle emitter
    CAEmitterLayer *sparkleEmitter = [CAEmitterLayer layer];
    sparkleEmitter.emitterPosition = CGPointMake(170, 225);
    sparkleEmitter.emitterSize = CGSizeMake(340, 450);
    sparkleEmitter.emitterShape = kCAEmitterLayerRectangle;
    
    CAEmitterCell *sparkle = [CAEmitterCell emitterCell];
    sparkle.birthRate = 15;
    sparkle.lifetime = 2.0;
    sparkle.velocity = 80;
    sparkle.velocityRange = 40;
    sparkle.emissionRange = 2 * M_PI;
    sparkle.scale = 0.4;
    sparkle.scaleRange = 0.2;
    sparkle.alphaSpeed = -0.5;
    sparkle.color = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor;
    sparkle.contents = (id)[self createSparkleImage].CGImage;
    
    sparkleEmitter.emitterCells = @[sparkle];
    [resultCard.layer addSublayer:sparkleEmitter];
    
    // Store emitter reference
    objc_setAssociatedObject(self, @"sparkleEmitter", sparkleEmitter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)createSparkleImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 10, 10));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)okButtonTapped:(UIButton *)sender {
    [self dismissResultDialog:nil];
}

- (void)dismissResultDialog:(UITapGestureRecognizer *)gesture {
    UIView *overlayView = objc_getAssociatedObject(self, @"resultOverlay");
    UIView *resultCard = objc_getAssociatedObject(self, @"resultCard");
    CAEmitterLayer *sparkleEmitter = objc_getAssociatedObject(self, @"sparkleEmitter");
    
    if (!overlayView || !resultCard) return;
    
    // Cleanup animations
    [resultCard.layer removeAllAnimations];
    if (sparkleEmitter) {
        [sparkleEmitter removeFromSuperlayer];
    }
    
    // Hide animation
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 0.0;
        resultCard.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        
        // Reset the game
        [self resetButtonTapped];
        
        // Clear associated objects
        objc_setAssociatedObject(self, @"resultOverlay", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"resultCard", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"gameManager", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"isCorrectGuess", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"sparkleEmitter", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
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
    
    // Check if any animal has reached the finish line
    BOOL gameFinished = NO;
    for (int i = 0; i < 10; i++) {
        if ([self.animalRaceView getCurrentStepsForAnimal:i] >= 100) {
            gameFinished = YES;
            break;
        }
    }
    
    if (!gameFinished && self.gameInProgress) {
        // Continue auto-spinning
        [self startAutoSpinning];
    }
}

#pragma mark - AnimalRaceViewDelegate

- (void)animalRaceView:(AnimalRaceView *)raceView animalDidFinish:(NSInteger)animalIndex {
    self.winnerAnimalIndex = animalIndex;
    self.gameInProgress = NO;
    
    // Disable the start button immediately
    self.startButton.enabled = NO;
    self.startButton.alpha = 0.5;
    
    // Show result after a short delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showGameResultAlert:animalIndex];
    });
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
    // Update start button gradient
    for (CALayer *layer in self.startButton.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.startButton.bounds;
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

@end 