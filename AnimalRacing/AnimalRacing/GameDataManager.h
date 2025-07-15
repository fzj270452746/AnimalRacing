//
//  GameDataManager.h
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameDataManager : NSObject

@property (nonatomic, assign) NSInteger coins;
@property (nonatomic, assign) NSInteger level;

+ (instancetype)sharedManager;

// Animal data
- (NSArray<NSNumber *> *)getAnimalMoveStepsForAnimal:(NSInteger)animalIndex;
- (NSInteger)getAnimalRewardForAnimal:(NSInteger)animalIndex;
- (NSInteger)getAnimalTotalStepsForLevel:(NSInteger)level;
- (NSInteger)getAnimalTotalStepsForGuessFirst;
- (NSInteger)getRandomAnimalIndex;

// Game actions
- (BOOL)canSpinWithCost:(NSInteger)cost;
- (void)spendCoins:(NSInteger)cost;
- (void)earnCoins:(NSInteger)reward;
- (void)levelUp;
- (void)resetGame;

// Save/Load
- (void)saveGameData;
- (void)loadGameData;

@end

NS_ASSUME_NONNULL_END 