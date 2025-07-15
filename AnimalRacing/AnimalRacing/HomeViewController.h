//
//  HomeViewController.h
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *statusContainer;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *coinsLabel;
@property (nonatomic, strong) UILabel *winRateLabel;
@property (nonatomic, strong) UIButton *racingSlotButton;
@property (nonatomic, strong) UIButton *guessFirstButton;
@property (nonatomic, strong) UIButton *gameRulesButton;
@property (nonatomic, strong) UIButton *feedbackButton;
@property (nonatomic, strong) UIButton *privacyButton;

@end

NS_ASSUME_NONNULL_END 