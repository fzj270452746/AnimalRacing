//
//  AnimalRaceView.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "AnimalRaceView.h"
#import <Masonry/Masonry.h>

@interface AnimalRaceView ()

@property (nonatomic, strong) NSMutableArray<UIView *> *trackViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *animalViews;
@property (nonatomic, strong) NSMutableArray<UIView *> *progressViews;
@property (nonatomic, strong) NSMutableArray<UILabel *> *progressLabels;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *animalSteps;
@property (nonatomic, assign) NSInteger totalSteps;

@end

@implementation AnimalRaceView

- (instancetype)initWithTotalSteps:(NSInteger)totalSteps {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.totalSteps = totalSteps;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.1 alpha:1.0];
    self.layer.cornerRadius = 15;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.3 alpha:1.0].CGColor;
    
    self.trackViews = [NSMutableArray array];
    self.animalViews = [NSMutableArray array];
    self.progressViews = [NSMutableArray array];
    self.progressLabels = [NSMutableArray array];
    self.animalSteps = [NSMutableArray array];
    
    // Initialize animal steps
    for (int i = 0; i < 10; i++) {
        [self.animalSteps addObject:@(0)];
    }
    
    // Create tracks for each animal
    for (int i = 0; i < 10; i++) {
        [self createTrackForAnimal:i];
    }
    
    // Add finish line
    [self addFinishLine];
}

- (void)createTrackForAnimal:(NSInteger)animalIndex {
    // Track container
    UIView *trackContainer = [[UIView alloc] init];
    trackContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:0.5];
    trackContainer.layer.cornerRadius = 5;
    [self addSubview:trackContainer];
    [self.trackViews addObject:trackContainer];
    
    // Track background
    UIView *trackBackground = [[UIView alloc] init];
    trackBackground.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
    trackBackground.layer.cornerRadius = 3;
    [trackContainer addSubview:trackBackground];
    
    // Progress view
    UIView *progressView = [[UIView alloc] init];
    progressView.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.3 alpha:0.8];
    progressView.layer.cornerRadius = 3;
    [trackContainer addSubview:progressView];
    [self.progressViews addObject:progressView];
    
    // Animal image
    UIImageView *animalView = [[UIImageView alloc] init];
    animalView.contentMode = UIViewContentModeScaleAspectFit;
    animalView.image = [UIImage imageNamed:[NSString stringWithFormat:@"animal-%ld", (long)animalIndex]];
    animalView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    animalView.layer.cornerRadius = 12;  // Reduced from 15 to 12
    [trackContainer addSubview:animalView];
    [self.animalViews addObject:animalView];
    
    // Progress label
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont boldSystemFontOfSize:11];  // Reduced from 12 to 11
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.totalSteps];
    [trackContainer addSubview:progressLabel];
    [self.progressLabels addObject:progressLabel];
    
    // Layout constraints - ADJUSTED for tighter spacing
    [trackContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10 + animalIndex * 32);  // Reduced from 35 to 32 spacing
        make.height.equalTo(@28);  // Reduced from 30 to 28 height
    }];
    
    [trackBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trackContainer).offset(32);  // Reduced from 35 to 32
        make.right.equalTo(trackContainer).offset(-55);  // Reduced from 60 to 55
        make.centerY.equalTo(trackContainer);
        make.height.equalTo(@5);  // Reduced from 6 to 5
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trackBackground);
        make.centerY.equalTo(trackBackground);
        make.height.equalTo(trackBackground);
        make.width.equalTo(@0);
    }];
    
    [animalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trackContainer).offset(4);  // Reduced from 5 to 4
        make.centerY.equalTo(trackContainer);
        make.width.height.equalTo(@24);  // Reduced from 30 to 24
    }];
    
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(trackContainer).offset(-4);  // Reduced from 5 to 4
        make.centerY.equalTo(trackContainer);
        make.width.equalTo(@45);  // Reduced from 50 to 45
    }];
}

- (void)addFinishLine {
    UIView *finishLine = [[UIView alloc] init];
    finishLine.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.8];
    [self addSubview:finishLine];
    
    [finishLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-55);  // Adjusted to match new track layout
        make.top.equalTo(self).offset(10);     // Adjusted to match new top spacing
        make.bottom.equalTo(self).offset(-10); // Adjusted for tighter bottom spacing
        make.width.equalTo(@3);
    }];
    
    // Add finish flag
    UILabel *finishLabel = [[UILabel alloc] init];
    finishLabel.text = @"🏁";
    finishLabel.font = [UIFont systemFontOfSize:18];  // Reduced from 20 to 18
    finishLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:finishLabel];
    
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(finishLine);
        make.top.equalTo(self).offset(2);     // Adjusted top position
        make.width.height.equalTo(@22);       // Reduced from 25 to 22
    }];
}

- (void)updateAnimalProgress:(NSInteger)animalIndex steps:(NSInteger)steps {
    if (animalIndex < 0 || animalIndex >= self.animalSteps.count) return;
    
    NSInteger currentSteps = self.animalSteps[animalIndex].integerValue;
    NSInteger newSteps = currentSteps + steps;
    
    if (newSteps > self.totalSteps) {
        newSteps = self.totalSteps;
    }
    
    self.animalSteps[animalIndex] = @(newSteps);
    
    // Update progress view
    UIView *progressView = self.progressViews[animalIndex];
    UIView *trackContainer = self.trackViews[animalIndex];
    
    CGFloat progress = (CGFloat)newSteps / self.totalSteps;
    CGFloat trackWidth = CGRectGetWidth(trackContainer.frame) - 87; // 32 (animal) + 55 (label) - updated calculation
    
    [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(trackWidth * progress));
    }];
    
    // Update animal position
    UIImageView *animalView = self.animalViews[animalIndex];
    [animalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trackContainer).offset(4 + (trackWidth * progress));  // Updated base offset from 5 to 4
    }];
    
    // Update progress label
    UILabel *progressLabel = self.progressLabels[animalIndex];
    progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)newSteps, (long)self.totalSteps];
    
    // Animate updates
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [trackContainer layoutIfNeeded];
        
        // Add bounce effect for animal
        animalView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            animalView.transform = CGAffineTransformIdentity;
        }];
        
        // Check if animal finished
        if (newSteps >= self.totalSteps) {
            [self animalFinished:animalIndex];
        }
    }];
}

- (void)animalFinished:(NSInteger)animalIndex {
    UIImageView *animalView = self.animalViews[animalIndex];
    
    // Add celebration animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        animalView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:nil];
    
    // Add glow effect
    CALayer *glowLayer = [CALayer layer];
    glowLayer.frame = animalView.bounds;
    glowLayer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5].CGColor;
    glowLayer.cornerRadius = 15;
    [animalView.layer insertSublayer:glowLayer atIndex:0];
    
    // Notify delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(animalRaceView:animalDidFinish:)]) {
        [self.delegate animalRaceView:self animalDidFinish:animalIndex];
    }
}

- (void)resetAllAnimals {
    for (int i = 0; i < 10; i++) {
        self.animalSteps[i] = @(0);
        
        // Reset progress view
        UIView *progressView = self.progressViews[i];
        [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        
        // Reset animal position
        UIImageView *animalView = self.animalViews[i];
        [animalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.trackViews[i]).offset(4);  // Updated from 5 to 4
        }];
        
        // Reset progress label
        UILabel *progressLabel = self.progressLabels[i];
        progressLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.totalSteps];
        
        // Remove animations
        [animalView.layer removeAllAnimations];
        animalView.transform = CGAffineTransformIdentity;
        
        // Remove glow effect
        if (animalView.layer.sublayers.count > 1) {
            [animalView.layer.sublayers.firstObject removeFromSuperlayer];
        }
    }
    
    // Animate reset
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *trackView in self.trackViews) {
            [trackView layoutIfNeeded];
        }
    }];
}

- (NSInteger)getCurrentStepsForAnimal:(NSInteger)animalIndex {
    if (animalIndex < 0 || animalIndex >= self.animalSteps.count) return 0;
    return self.animalSteps[animalIndex].integerValue;
}

@end 