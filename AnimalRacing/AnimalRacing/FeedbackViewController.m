//
//  FeedbackViewController.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "FeedbackViewController.h"
#import <Masonry/Masonry.h>

@interface FeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UIView *feedbackContainer;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *characterCountLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation FeedbackViewController

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
        (id)[UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.3 blue:0.1 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.5 green:0.2 blue:0.05 alpha:1.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.view.bounds;
    gradientLayer.name = @"backgroundGradient";
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // Title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"💬 Feedback";
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
    
    // Instruction label
    self.instructionLabel = [[UILabel alloc] init];
    self.instructionLabel.text = @"We value your feedback! Please share your thoughts, suggestions, or report any issues you've encountered.";
    self.instructionLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    self.instructionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.adjustsFontSizeToFitWidth = YES;
    self.instructionLabel.minimumScaleFactor = 0.9;
    [self.view addSubview:self.instructionLabel];
    
    [self.instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
    }];
    
    // Feedback container with glassmorphism effect
    self.feedbackContainer = [[UIView alloc] init];
    self.feedbackContainer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.feedbackContainer.layer.cornerRadius = 20;
    self.feedbackContainer.layer.borderWidth = 1;
    self.feedbackContainer.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
    
    // Add backdrop blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.layer.cornerRadius = 20;
    blurView.clipsToBounds = YES;
    [self.feedbackContainer addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.feedbackContainer);
    }];
    
    [self.view addSubview:self.feedbackContainer];
    
    [self.feedbackContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.instructionLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@250);
    }];
    
    // Feedback text view
    self.feedbackTextView = [[UITextView alloc] init];
    self.feedbackTextView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.25 alpha:1.0];
    self.feedbackTextView.textColor = [UIColor whiteColor];
    self.feedbackTextView.font = [UIFont systemFontOfSize:16];
    self.feedbackTextView.layer.cornerRadius = 10;
    self.feedbackTextView.layer.borderWidth = 1;
    self.feedbackTextView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0].CGColor;
    self.feedbackTextView.delegate = self;
    [self.feedbackContainer addSubview:self.feedbackTextView];
    
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackContainer).offset(15);
        make.left.equalTo(self.feedbackContainer).offset(15);
        make.right.equalTo(self.feedbackContainer).offset(-15);
        make.bottom.equalTo(self.feedbackContainer).offset(-50);
    }];
    
    // Placeholder label
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Share your thoughts here...";
    self.placeholderLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.placeholderLabel.font = [UIFont systemFontOfSize:16];
    self.placeholderLabel.userInteractionEnabled = NO;
    [self.feedbackTextView addSubview:self.placeholderLabel];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackTextView).offset(8);
        make.left.equalTo(self.feedbackTextView).offset(5);
    }];
    
    // Character count label
    self.characterCountLabel = [[UILabel alloc] init];
    self.characterCountLabel.text = @"0/500";
    self.characterCountLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.characterCountLabel.font = [UIFont systemFontOfSize:14];
    self.characterCountLabel.textAlignment = NSTextAlignmentRight;
    [self.feedbackContainer addSubview:self.characterCountLabel];
    
    [self.characterCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedbackContainer).offset(-15);
        make.bottom.equalTo(self.feedbackContainer).offset(-15);
    }];
    
    // Button container
    UIView *buttonContainer = [[UIView alloc] init];
    [self.view addSubview:buttonContainer];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.feedbackContainer.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide).offset(-20);
    }];
    
    // Submit button
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:1.0];
    self.submitButton.layer.cornerRadius = 15;
    self.submitButton.layer.borderWidth = 2;
    self.submitButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    [self.submitButton setTitle:@"📨 Submit Feedback" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:self.submitButton];
    
    // Back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    self.backButton.layer.cornerRadius = 10;
    self.backButton.layer.borderWidth = 1;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    [self.backButton setTitle:@"🏠 Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:self.backButton];
    
    // Layout buttons
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer);
        make.top.equalTo(buttonContainer).offset(10);
        make.left.equalTo(buttonContainer).offset(20);
        make.right.equalTo(buttonContainer).offset(-20);
        make.height.equalTo(@60);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer);
        make.top.equalTo(self.submitButton.mas_bottom).offset(15);
        make.left.equalTo(buttonContainer).offset(60);
        make.right.equalTo(buttonContainer).offset(-60);
        make.height.equalTo(@45);
    }];
    
    // Update submit button state
    [self updateSubmitButtonState];
}

- (void)updateSubmitButtonState {
    BOOL hasText = self.feedbackTextView.text.length > 0;
    self.submitButton.enabled = hasText;
    self.submitButton.alpha = hasText ? 1.0 : 0.5;
}

- (void)submitButtonTapped {
    if (self.feedbackTextView.text.length == 0) {
        [self showAlert:@"Empty Feedback" message:@"Please enter your feedback before submitting."];
        return;
    }
    
    // Simulate feedback submission
    [self showAlert:@"Thank You!" 
            message:@"Your feedback has been submitted successfully. We appreciate your input!" 
         completion:^{
             [self backButtonTapped];
         }];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    [self showAlert:title message:message completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:^(UIAlertAction *action) {
                                                         if (completion) {
                                                             completion();
                                                         }
                                                     }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    // Update placeholder visibility
    self.placeholderLabel.hidden = textView.text.length > 0;
    
    // Limit text length
    if (textView.text.length > 500) {
        textView.text = [textView.text substringToIndex:500];
    }
    
    // Update character count
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
    
    // Update character count color
    if (textView.text.length > 450) {
        self.characterCountLabel.textColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    } else {
        self.characterCountLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    
    // Update submit button state
    [self updateSubmitButtonState];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // Animate container border color
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation.fromValue = (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    colorAnimation.toValue = (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.2 alpha:1.0].CGColor;
    colorAnimation.duration = 0.3;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.feedbackContainer.layer addAnimation:colorAnimation forKey:@"borderColor"];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // Animate container border color back
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation.fromValue = (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.2 alpha:1.0].CGColor;
    colorAnimation.toValue = (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.3 alpha:1.0].CGColor;
    colorAnimation.duration = 0.3;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.feedbackContainer.layer addAnimation:colorAnimation forKey:@"borderColor"];
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