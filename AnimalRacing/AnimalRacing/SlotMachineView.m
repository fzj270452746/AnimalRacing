//
//  SlotMachineView.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "SlotMachineView.h"
#import "GameDataManager.h"
#import <Masonry/Masonry.h>

@interface SlotMachineView ()

@property (nonatomic, strong) NSArray<UIImageView *> *reels;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *frameView;
@property (nonatomic, assign) NSInteger targetAnimalIndex;
@property (nonatomic, assign) BOOL isSpinning;

// New properties for enhanced animations
@property (nonatomic, strong) NSArray<NSTimer *> *reelTimers;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *reelStopDelays;
@property (nonatomic, assign) NSInteger stoppedReelsCount;

@end

@implementation SlotMachineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // Container view with enhanced casino styling
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.3 alpha:0.9];
    self.containerView.layer.cornerRadius = 15;
    self.containerView.layer.borderWidth = 4;
    self.containerView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    
    // Add neon glow effect
    self.containerView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerView.layer.shadowOpacity = 0.8;
    self.containerView.layer.shadowRadius = 15;
    
    [self addSubview:self.containerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // Frame view with enhanced styling
    self.frameView = [[UIView alloc] init];
    self.frameView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.25 alpha:1.0];
    self.frameView.layer.cornerRadius = 12;
    self.frameView.layer.borderWidth = 2;
    self.frameView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.4 blue:0.8 alpha:1.0].CGColor;
    [self.containerView addSubview:self.frameView];
    
    [self.frameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
        make.width.equalTo(self.containerView).multipliedBy(0.85);
        make.height.equalTo(self.containerView).multipliedBy(0.7);
    }];
    
    // Create enhanced reels with better styling
    NSMutableArray *reels = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *reel = [[UIImageView alloc] init];
        reel.contentMode = UIViewContentModeScaleAspectFit;
        reel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:1.0];
        reel.layer.cornerRadius = 10;
        reel.layer.borderWidth = 2;
        reel.layer.borderColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.2 alpha:1.0].CGColor;
        
        // Add individual reel glow
        reel.layer.shadowColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.2 alpha:0.8].CGColor;
        reel.layer.shadowOffset = CGSizeMake(0, 0);
        reel.layer.shadowOpacity = 0.6;
        reel.layer.shadowRadius = 8;
        
        reel.image = [UIImage imageNamed:@"animal-0"];
        reel.tag = i;  // Tag for identification
        [self.frameView addSubview:reel];
        [reels addObject:reel];
    }
    self.reels = [reels copy];
    
    // Layout reels with better spacing
    [self.reels[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.frameView).offset(8);
        make.top.equalTo(self.frameView).offset(8);
        make.bottom.equalTo(self.frameView).offset(-8);
        make.width.equalTo(self.frameView).multipliedBy(0.28);
    }];
    
    [self.reels[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.frameView);
        make.top.equalTo(self.frameView).offset(8);
        make.bottom.equalTo(self.frameView).offset(-8);
        make.width.equalTo(self.frameView).multipliedBy(0.28);
    }];
    
    [self.reels[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.frameView).offset(-8);
        make.top.equalTo(self.frameView).offset(8);
        make.bottom.equalTo(self.frameView).offset(-8);
        make.width.equalTo(self.frameView).multipliedBy(0.28);
    }];
    
    // Add enhanced glow effect
    [self addGlowEffect];
    
    // Add decorative elements
    [self addCasinoDecorations];
}

- (void)addCasinoDecorations {
    // Add corner decorations
    for (int i = 0; i < 4; i++) {
        UILabel *cornerDecor = [[UILabel alloc] init];
        cornerDecor.text = @"💎";
        cornerDecor.font = [UIFont systemFontOfSize:16];
        cornerDecor.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:cornerDecor];
        
        // Position corners
        [cornerDecor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            if (i == 0) {  // Top-left
                make.top.left.equalTo(self.containerView).offset(8);
            } else if (i == 1) {  // Top-right
                make.top.right.equalTo(self.containerView).offset(-8);
            } else if (i == 2) {  // Bottom-left
                make.bottom.left.equalTo(self.containerView).offset(8);
            } else {  // Bottom-right
                make.bottom.right.equalTo(self.containerView).offset(-8);
            }
        }];
        
        // Add twinkling animation
        CABasicAnimation *twinkle = [CABasicAnimation animationWithKeyPath:@"opacity"];
        twinkle.fromValue = @0.3;
        twinkle.toValue = @1.0;
        twinkle.duration = 0.8 + (i * 0.2);
        twinkle.repeatCount = INFINITY;
        twinkle.autoreverses = YES;
        [cornerDecor.layer addAnimation:twinkle forKey:@"twinkle"];
    }
}

- (void)addGlowEffect {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:0.4].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.6 blue:0.8 alpha:0.2].CGColor,
        (id)[UIColor clearColor].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.name = @"glowGradient";
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)spinWithAnimal:(NSInteger)animalIndex {
    if (self.isSpinning) return;
    
    self.isSpinning = YES;
    self.targetAnimalIndex = animalIndex;
    self.stoppedReelsCount = 0;
    
    // Start enhanced spinning animation
    [self startEnhancedSpinAnimation];
    
    // Set up staggered stopping with different delays for each reel
    self.reelStopDelays = [NSMutableArray arrayWithArray:@[@1.5, @2.0, @2.5]];
    
    // Schedule stopping for each reel
    for (int i = 0; i < 3; i++) {
        NSTimeInterval delay = [self.reelStopDelays[i] doubleValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopReelAtIndex:i];
        });
    }
}

- (void)spinWithRandomAnimal {
    NSInteger randomAnimal = [[GameDataManager sharedManager] getRandomAnimalIndex];
    [self spinWithAnimal:randomAnimal];
}

- (void)startEnhancedSpinAnimation {
    // Add machine shake effect
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.fromValue = @(-2);
    shakeAnimation.toValue = @2;
    shakeAnimation.duration = 0.1;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = INFINITY;
    [self.containerView.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
    
    // Add pulsing glow effect
    CABasicAnimation *pulseGlow = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    pulseGlow.fromValue = @10;
    pulseGlow.toValue = @25;
    pulseGlow.duration = 0.3;
    pulseGlow.autoreverses = YES;
    pulseGlow.repeatCount = INFINITY;
    [self.containerView.layer addAnimation:pulseGlow forKey:@"pulseGlow"];
    
    // Start rapid image switching for each reel
    NSMutableArray *timers = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *reel = self.reels[i];
        
        // Add rotation effect to each reel
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotation.fromValue = @0;
        rotation.toValue = @(2 * M_PI);
        rotation.duration = 0.3;
        rotation.repeatCount = INFINITY;
        [reel.layer addAnimation:rotation forKey:@"spinRotation"];
        
        // Create timer for rapid image switching
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(switchReelImage:) userInfo:@{@"reelIndex": @(i)} repeats:YES];
        [timers addObject:timer];
    }
    self.reelTimers = [timers copy];
}

- (void)switchReelImage:(NSTimer *)timer {
    NSInteger reelIndex = [timer.userInfo[@"reelIndex"] integerValue];
    if (reelIndex < self.reels.count) {
        UIImageView *reel = self.reels[reelIndex];
        NSInteger randomAnimal = arc4random_uniform(10);
        reel.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%ld", (long)randomAnimal]];
        
        // Add quick scale effect for visual feedback
        [UIView animateWithDuration:0.05 animations:^{
            reel.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                reel.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)stopReelAtIndex:(NSInteger)reelIndex {
    if (reelIndex >= self.reelTimers.count) return;
    
    // Stop the timer for this reel
    NSTimer *timer = self.reelTimers[reelIndex];
    [timer invalidate];
    
    UIImageView *reel = self.reels[reelIndex];
    
    // Remove rotation animation
    [reel.layer removeAnimationForKey:@"spinRotation"];
    
    // Set final image with dramatic stopping effect
    NSString *imageName = [NSString stringWithFormat:@"animal-%ld", (long)self.targetAnimalIndex];
    UIImage *finalImage = [UIImage imageNamed:imageName];
    
    // Create dramatic stopping animation
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        reel.image = finalImage;
        reel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        // Add winner glow if this is the final result
        reel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        reel.layer.shadowOpacity = 1.0;
        reel.layer.shadowRadius = 15;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            reel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // Add final sparkle effect
            [self addSparkleEffectToReel:reel];
        }];
    }];
    
    self.stoppedReelsCount++;
    
    // Check if all reels have stopped
    if (self.stoppedReelsCount >= 3) {
        [self finishSpinAnimation];
    }
}

- (void)addSparkleEffectToReel:(UIImageView *)reel {
    // Create sparkle emitter
    CAEmitterLayer *sparkleEmitter = [CAEmitterLayer layer];
    sparkleEmitter.emitterPosition = CGPointMake(CGRectGetMidX(reel.bounds), CGRectGetMidY(reel.bounds));
    sparkleEmitter.emitterSize = reel.bounds.size;
    sparkleEmitter.emitterShape = kCAEmitterLayerRectangle;
    
    CAEmitterCell *sparkle = [CAEmitterCell emitterCell];
    sparkle.birthRate = 15;
    sparkle.lifetime = 1.0;
    sparkle.velocity = 50;
    sparkle.velocityRange = 25;
    sparkle.emissionRange = 2 * M_PI;
    sparkle.scaleRange = 0.3;
    sparkle.alphaSpeed = -1.0;
    sparkle.color = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0].CGColor;
    sparkle.contents = (id)[self createSparkleImage].CGImage;
    
    sparkleEmitter.emitterCells = @[sparkle];
    [reel.layer addSublayer:sparkleEmitter];
    
    // Remove sparkle effect after animation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sparkleEmitter removeFromSuperlayer];
    });
}

- (UIImage *)createSparkleImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(8, 8), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 8, 8));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)finishSpinAnimation {
    // Remove machine effects
    [self.containerView.layer removeAnimationForKey:@"shakeAnimation"];
    [self.containerView.layer removeAnimationForKey:@"pulseGlow"];
    
    // Final celebration effect
    [self addCelebrationEffect];
    
    // Reset state
    self.isSpinning = NO;
    
    // Notify delegate after a short delay to let animations finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(slotMachineView:didFinishSpinWithAnimal:)]) {
            [self.delegate slotMachineView:self didFinishSpinWithAnimal:self.targetAnimalIndex];
        }
    });
}

- (void)addCelebrationEffect {
    // Add machine celebration glow
    CABasicAnimation *celebrationGlow = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    celebrationGlow.fromValue = @15;
    celebrationGlow.toValue = @30;
    celebrationGlow.duration = 0.5;
    celebrationGlow.autoreverses = YES;
    celebrationGlow.repeatCount = 3;
    [self.containerView.layer addAnimation:celebrationGlow forKey:@"celebrationGlow"];
    
    // Add border color animation
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    borderColorAnimation.toValue = (id)[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0].CGColor;
    borderColorAnimation.duration = 0.3;
    borderColorAnimation.autoreverses = YES;
    borderColorAnimation.repeatCount = 3;
    [self.containerView.layer addAnimation:borderColorAnimation forKey:@"borderColorAnimation"];
}

- (void)reset {
    if (self.isSpinning) {
        // Stop all timers
        for (NSTimer *timer in self.reelTimers) {
            [timer invalidate];
        }
        self.reelTimers = nil;
        self.isSpinning = NO;
    }
    
    // Remove all animations
    [self.containerView.layer removeAllAnimations];
    for (UIImageView *reel in self.reels) {
        [reel.layer removeAllAnimations];
        reel.transform = CGAffineTransformIdentity;
        reel.image = [UIImage imageNamed:@"animal-0"];
        
        // Reset reel glow
        reel.layer.shadowOpacity = 0.6;
        reel.layer.shadowRadius = 8;
        reel.layer.shadowColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.2 alpha:0.8].CGColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Update gradient layer frame
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.bounds;
            break;
        }
    }
}

@end 