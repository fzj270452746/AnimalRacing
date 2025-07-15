//
//  AnimalRaceView.h
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AnimalRaceView;

@protocol AnimalRaceViewDelegate <NSObject>

- (void)animalRaceView:(AnimalRaceView *)raceView animalDidFinish:(NSInteger)animalIndex;

@end

@interface AnimalRaceView : UIView

@property (nonatomic, weak) id<AnimalRaceViewDelegate> delegate;

- (instancetype)initWithTotalSteps:(NSInteger)totalSteps;
- (void)updateAnimalProgress:(NSInteger)animalIndex steps:(NSInteger)steps;
- (void)resetAllAnimals;
- (NSInteger)getCurrentStepsForAnimal:(NSInteger)animalIndex;

@end

NS_ASSUME_NONNULL_END 