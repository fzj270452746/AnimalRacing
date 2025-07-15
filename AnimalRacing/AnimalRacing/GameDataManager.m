//
//  GameDataManager.m
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import "GameDataManager.h"

@interface GameDataManager ()

@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *animalMoveSteps;
@property (nonatomic, strong) NSArray<NSNumber *> *animalRewards;

@end

@implementation GameDataManager

+ (instancetype)sharedManager {
    static GameDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupGameData];
        [self loadGameData];
    }
    return self;
}

- (void)setupGameData {
    // Animal move steps - each animal has a FIXED step count
    // animal-0: 2, animal-1: 3, animal-2: 5, animal-3: 8, animal-4: 10
    // animal-5: 12, animal-6: 15, animal-7: 18, animal-8: 20, animal-9: 25
    self.animalMoveSteps = @[
        @[@2],   // animal-0: always moves 2 steps
        @[@3],   // animal-1: always moves 3 steps
        @[@5],   // animal-2: always moves 5 steps
        @[@8],   // animal-3: always moves 8 steps
        @[@10],  // animal-4: always moves 10 steps
        @[@12],  // animal-5: always moves 12 steps
        @[@15],  // animal-6: always moves 15 steps
        @[@18],  // animal-7: always moves 18 steps
        @[@20],  // animal-8: always moves 20 steps
        @[@25]   // animal-9: always moves 25 steps
    ];
    
    // Animal rewards (animal-0 = 800, others increase by 200)
    NSMutableArray *rewards = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [rewards addObject:@(800 + i * 200)];
    }
    self.animalRewards = [rewards copy];
}

- (NSArray<NSNumber *> *)getAnimalMoveStepsForAnimal:(NSInteger)animalIndex {
    if (animalIndex >= 0 && animalIndex < self.animalMoveSteps.count) {
        return self.animalMoveSteps[animalIndex];
    }
    return @[];
}

- (NSInteger)getAnimalRewardForAnimal:(NSInteger)animalIndex {
    if (animalIndex >= 0 && animalIndex < self.animalRewards.count) {
        // Increase reward based on level
        NSInteger baseReward = self.animalRewards[animalIndex].integerValue;
        return baseReward + (self.level - 1) * 100;
    }
    return 0;
}

- (NSInteger)getAnimalTotalStepsForLevel:(NSInteger)level {
    return 50 + (level - 1) * 10; // Base 50, increase by 10 per level
}

- (NSInteger)getAnimalTotalStepsForGuessFirst {
    return 100;
}

- (NSInteger)getRandomAnimalIndex {
    // Animals with smaller move steps have higher probability
    NSArray *probabilities = @[@30, @25, @20, @15, @10, @8, @6, @4, @3, @2]; // Total: 123
    
    NSInteger totalProbability = 0;
    for (NSNumber *prob in probabilities) {
        totalProbability += prob.integerValue;
    }
    
    NSInteger randomValue = arc4random_uniform((uint32_t)totalProbability);
    NSInteger currentSum = 0;
    
    for (NSInteger i = 0; i < probabilities.count; i++) {
        currentSum += ((NSNumber *)probabilities[i]).integerValue;
        if (randomValue < currentSum) {
            return i;
        }
    }
    
    return 0; // Fallback
}

- (BOOL)canSpinWithCost:(NSInteger)cost {
    return self.coins >= cost;
}

- (void)spendCoins:(NSInteger)cost {
    self.coins -= cost;
    [self saveGameData];
}

- (void)earnCoins:(NSInteger)reward {
    self.coins += reward;
    [self saveGameData];
}

- (void)levelUp {
    self.level++;
    [self saveGameData];
}

- (void)resetGame {
    self.coins = 3000;
    self.level = 1;
    [self saveGameData];
}

- (void)saveGameData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.coins forKey:@"GameCoins"];
    [defaults setInteger:self.level forKey:@"GameLevel"];
    [defaults synchronize];
}

- (void)loadGameData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.coins = [defaults integerForKey:@"GameCoins"];
    self.level = [defaults integerForKey:@"GameLevel"];
    
    // Set default values if first time
    if (self.coins == 0) {
        self.coins = 3000;
    }
    if (self.level == 0) {
        self.level = 1;
    }
}

@end 