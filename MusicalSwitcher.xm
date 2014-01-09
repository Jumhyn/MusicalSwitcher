#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>


@interface SBAppSliderScrollView : UIScrollView
@end

%hook SBAppSliderScrollingViewController

- (void)scrollViewWillEndDragging:(id)arg1 withVelocity:(struct CGPoint)arg2 targetContentOffset:(struct CGPoint *)arg3 {
    if ([(SBAppSliderScrollView *)arg1 contentOffset].y < -20.0 && arg2.y < -2.0) {
        /*
        long long orientation;
	object_getInstanceVariable(self, "_layoutOrientation", (void **)&orientation);
        int cardWidth = (int)((orientation == UIInterfaceOrientationPortrait) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/2;
	int noteIndex = 0;
	noteIndex = (int)([(SBAppSliderScrollView *)arg1 frame].origin.x/cardWidth);
	if (noteIndex > 7) {
	    noteIndex = 7;
	}
	*/
	
	// Access the items array and check the index of the current SBAppSliderView
	// Then mod that index with 7 to get a nice, consistent, repeating octave.
        NSMutableArray *_items = MSHookIvar<NSMutableArray*>(self, "_items");
        int noteIndex = [_items indexOfObject:arg1] % 7;
	
        CFURLRef soundFileURLRef;
        soundFileURLRef = (CFURLRef)[NSURL URLWithString:[NSString stringWithFormat:@"/Library/MusicalSwitcher/note%d.m4a", noteIndex]];
        UInt32 soundID;
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    %orig;
}


%end

