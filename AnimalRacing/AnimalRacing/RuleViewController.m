//
//  RuleViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "RuleViewController.h"
#import <Masonry/Masonry.h>

@interface RuleViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // Cartoon-style colorful gradient background
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create animated animal-themed gradient background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.4 green:0.8 blue:0.9 alpha:1.0].CGColor,  // Sky blue
        (id)[UIColor colorWithRed:0.6 green:0.9 blue:0.4 alpha:1.0].CGColor,  // Grass green
        (id)[UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.0].CGColor,  // Deep blue
        (id)[UIColor colorWithRed:0.3 green:0.7 blue:0.5 alpha:1.0].CGColor   // Forest green
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
        (id)[UIColor colorWithRed:0.6 green:0.9 blue:0.4 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.7 blue:0.5 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.4 green:0.8 blue:0.9 alpha:1.0].CGColor
    ];
    colorAnimation.duration = 5.0;
    colorAnimation.repeatCount = INFINITY;
    colorAnimation.autoreverses = YES;
    [gradientLayer addAnimation:colorAnimation forKey:@"colorTransition"];
    
    // Add floating rule-related emojis
    [self addFloatingRuleEmojis];
    
    // Title label with bouncing animation
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"📖🎮 Game Rules 🎮📖";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.8;
    
    // Add colorful text shadow
    self.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 3);
    self.titleLabel.layer.shadowOpacity = 0.8;
    self.titleLabel.layer.shadowRadius = 6;
    
    // Add bounce animation
    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    bounceAnimation.fromValue = @0;
    bounceAnimation.toValue = @(-8);
    bounceAnimation.duration = 1.8;
    bounceAnimation.repeatCount = INFINITY;
    bounceAnimation.autoreverses = YES;
    [self.titleLabel.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    // Back button with cartoon bubble effect
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1.0];
    self.backButton.layer.cornerRadius = 20;
    self.backButton.layer.borderWidth = 3;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
    
    // Add cartoon shadow
    self.backButton.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.backButton.layer.shadowOffset = CGSizeMake(0, 8);
    self.backButton.layer.shadowOpacity = 1.0;
    self.backButton.layer.shadowRadius = 12;
    
    // Create gradient for back button
    CAGradientLayer *buttonGradient = [CAGradientLayer layer];
    buttonGradient.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.7 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:1.0].CGColor
    ];
    buttonGradient.startPoint = CGPointMake(0.0, 0.0);
    buttonGradient.endPoint = CGPointMake(1.0, 1.0);
    buttonGradient.cornerRadius = 20;
    [self.backButton.layer insertSublayer:buttonGradient atIndex:0];
    
    [self.backButton setTitle:@"🏠 Back to Home" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.backButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    self.backButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    self.backButton.titleLabel.layer.shadowOpacity = 1.0;
    self.backButton.titleLabel.layer.shadowRadius = 3;
    
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
        make.height.equalTo(@60);
    }];
    
    // Scroll view with cartoon styling
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
    
    // Add rule sections
    [self addRuleSections];
}

- (void)addFloatingRuleEmojis {
    // Add floating rule-related emojis as background decoration
    NSArray *ruleEmojis = @[@"🎰", @"🎯", @"🏆", @"💰", @"🎮", @"📖", @"⚡", @"🌟", @"🎊", @"🎉"];
    
    for (int i = 0; i < 10; i++) {
        UILabel *emojiLabel = [[UILabel alloc] init];
        emojiLabel.text = ruleEmojis[i % ruleEmojis.count];
        emojiLabel.font = [UIFont systemFontOfSize:22];
        emojiLabel.alpha = 0.4;
        [self.view addSubview:emojiLabel];
        
        // Random position
        CGFloat x = arc4random_uniform(320) + 40;
        CGFloat y = arc4random_uniform(500) + 150;
        emojiLabel.frame = CGRectMake(x, y, 25, 25);
        
        // Add floating animation
        CABasicAnimation *floatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        floatAnimation.fromValue = @0;
        floatAnimation.toValue = @(-25);
        floatAnimation.duration = 2.5 + (arc4random_uniform(150) / 100.0);
        floatAnimation.repeatCount = INFINITY;
        floatAnimation.autoreverses = YES;
        floatAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(200) / 100.0);
        [emojiLabel.layer addAnimation:floatAnimation forKey:@"floatAnimation"];
        
        // Add twinkling animation
        CABasicAnimation *twinkleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        twinkleAnimation.fromValue = @0.2;
        twinkleAnimation.toValue = @0.8;
        twinkleAnimation.duration = 1.5 + (arc4random_uniform(100) / 100.0);
        twinkleAnimation.repeatCount = INFINITY;
        twinkleAnimation.autoreverses = YES;
        twinkleAnimation.beginTime = CACurrentMediaTime() + (arc4random_uniform(100) / 100.0);
        [emojiLabel.layer addAnimation:twinkleAnimation forKey:@"twinkleAnimation"];
    }
}

- (void)addRuleSections {
    UIView *previousView = nil;
    
    // Game Overview
    UIView *overviewSection = [self createSectionWithTitle:@"🎮 Game Overview" 
                                                    content:@"Animals Slot Racing is an exciting game combining slot machine mechanics with animal racing. You start with 3000 coins and can play two different game modes to earn more coins and advance through levels."];
    [self.contentView addSubview:overviewSection];
    
    [overviewSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = overviewSection;
    
    // Game Mode 1: Racing Slot
    UIView *racingSlotSection = [self createSectionWithTitle:@"🎰 Game Mode 1: Racing Slots"
                                                     content:@"• Cost: 20 coins per spin\n• Spin the slot machine to get a random animal\n• Each animal moves forward with FIXED steps:\n  - Animal-0: 2 steps\n  - Animal-1: 3 steps  \n  - Animal-2: 5 steps\n  - Animal-3: 8 steps\n  - Animal-4: 10 steps\n  - Animal-5: 12 steps\n  - Animal-6: 15 steps\n  - Animal-7: 18 steps\n  - Animal-8: 20 steps\n  - Animal-9: 25 steps\n• Animals with smaller steps have higher probability\n• First animal to reach the target wins\n• Target increases by 10 steps each level (Level 1: 50 steps)\n• Rewards: Animal-0 gives 800 coins, increases by 200 for each animal\n• Level up when any animal wins"];
    [self.contentView addSubview:racingSlotSection];
    
    [racingSlotSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = racingSlotSection;
    
    // Game Mode 2: Guess First
    UIView *guessFirstSection = [self createSectionWithTitle:@"🎯 Game Mode 2: Guess First" 
                                                     content:@"• Cost: 200 coins per game\n• Choose which animal you think will win first\n• Click START to begin auto-spinning\n• All animals race to 100 steps finish line\n• Slot machine spins automatically until someone wins\n• If your chosen animal wins: +1000 coins reward\n• If wrong guess: No reward\n• Game resets after each round"];
    [self.contentView addSubview:guessFirstSection];
    
    [guessFirstSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = guessFirstSection;
    
    // Animal Movement Patterns
    UIView *movementSection = [self createSectionWithTitle:@"🐾 Animal Movement Patterns" 
                                                   content:@"Each animal has a FIXED movement step:\n• Animal-0: 2 steps (highest probability)\n• Animal-1: 3 steps\n• Animal-2: 5 steps\n• Animal-3: 8 steps\n• Animal-4: 10 steps\n• Animal-5: 12 steps\n• Animal-6: 15 steps\n• Animal-7: 18 steps\n• Animal-8: 20 steps\n• Animal-9: 25 steps (lowest probability)\n\nLower numbered animals are more likely to appear but give smaller rewards. Higher numbered animals are rarer but give bigger rewards."];
    [self.contentView addSubview:movementSection];
    
    [movementSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    previousView = movementSection;
    
    // Tips & Strategy
    UIView *tipsSection = [self createSectionWithTitle:@"💡 Tips & Strategy" 
                                                content:@"• Start with Racing Slots to build up coins\n• Lower animals appear more often but give smaller rewards\n• Use Guess First when you have enough coins for bigger rewards\n• Watch animal movement patterns to make better guesses\n• Level progression increases both difficulty and rewards\n• Manage your coins wisely - don't spend all at once!"];
    [self.contentView addSubview:tipsSection];
    
    [tipsSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previousView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (UIView *)createSectionWithTitle:(NSString *)title content:(NSString *)content {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    sectionView.layer.cornerRadius = 20;
    sectionView.layer.borderWidth = 3;
    sectionView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1.0].CGColor;
    
    // Add cartoon bubble shadow
    sectionView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor;
    sectionView.layer.shadowOffset = CGSizeMake(0, 8);
    sectionView.layer.shadowOpacity = 1.0;
    sectionView.layer.shadowRadius = 15;
    
    // Add subtle gradient background
    CAGradientLayer *sectionGradient = [CAGradientLayer layer];
    sectionGradient.colors = @[
        (id)[UIColor colorWithRed:0.95 green:0.98 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.95 blue:0.98 alpha:1.0].CGColor
    ];
    sectionGradient.startPoint = CGPointMake(0.0, 0.0);
    sectionGradient.endPoint = CGPointMake(1.0, 1.0);
    sectionGradient.cornerRadius = 20;
    [sectionView.layer insertSublayer:sectionGradient atIndex:0];
    
    // Title label with cartoon styling
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.numberOfLines = 0;
    titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.shadowRadius = 2;
    [sectionView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView).offset(20);
        make.left.equalTo(sectionView).offset(20);
        make.right.equalTo(sectionView).offset(-20);
    }];
    
    // Content label with better readability
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = content;
    contentLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [sectionView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(sectionView).offset(20);
        make.right.equalTo(sectionView).offset(-20);
        make.bottom.equalTo(sectionView).offset(-20);
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
