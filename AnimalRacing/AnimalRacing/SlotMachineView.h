//
//  SlotMachineView.h
//  AnimalRacing
//
//  Created by Hades on 7/14/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SlotMachineView;

@protocol SlotMachineViewDelegate <NSObject>

- (void)slotMachineView:(SlotMachineView *)slotMachineView didFinishSpinWithAnimal:(NSInteger)animalIndex;

@end

@interface SlotMachineView : UIView

@property (nonatomic, weak) id<SlotMachineViewDelegate> delegate;

- (void)spinWithAnimal:(NSInteger)animalIndex;
- (void)spinWithRandomAnimal;
- (void)reset;

@end

NS_ASSUME_NONNULL_END 