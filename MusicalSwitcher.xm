#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>

@interface SBAppSliderScrollingViewController{
    NSMutableArray *_items;
    int _layoutOrientation;
}
@end

@interface SBAppSliderScrollView : UIScrollView
@end

%hook SBAppSliderScrollingViewController

- (void)scrollViewWillEndDragging:(SBAppSliderScrollView *)arg1 withVelocity:(CGPoint)arg2 targetContentOffset:(CGPoint)arg3 {

    if (arg1.contentOffset.y < -20.0 && arg2.y < -2.0) {
        int orientation = MSHookIvar<int>(self, "_layoutOrientation");
        float cardWidth = ((orientation == UIInterfaceOrientationPortrait) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/2;
        float cardLocation = arg1.frame.origin.x;
        float switcherSize = cardWidth * (MSHookIvar<NSMutableArray *>(self, "_items")).count;

        // Normalize note index: ceiling(lowestNote + ((currentLocation - minimumLocation) * ((highestNote - lowestNote)/(maximumLocation - minimumLocation))))
        // ceilf(0 + ((cardLocation - 0.f) * ((7 - 0)/(switcherSize - 0.f))))
        int noteIndex = ceilf(cardLocation * (7/switcherSize));
        
        CFURLRef soundFileURLRef;
        soundFileURLRef = (CFURLRef)[NSURL URLWithString:[NSString stringWithFormat:@"/Library/MusicalSwitcher/note%i.m4a", noteIndex]];
        UInt32 soundID;
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }

    %orig;
}

%end