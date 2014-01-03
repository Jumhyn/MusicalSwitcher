/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <substrate.h>
#import <objc/runtime.h>


@interface SBAppSliderScrollView : UIScrollView
@end

@interface SBAppSliderScrollingViewController {
	   SBAppSliderScrollView *_scrollView;
}
-(float)_distanceBetweenCenters;
@end

%hook SBAppSliderScrollingViewController

- (void)scrollViewWillEndDragging:(id)arg1 withVelocity:(struct CGPoint)arg2 targetContentOffset:(struct CGPoint *)arg3 {
    if ([(SBAppSliderScrollView *)arg1 contentOffset].y < -20.0 && arg2.y < -2.0) {
        long long orientation;
	object_getInstanceVariable(self, "_layoutOrientation", (void **)&orientation);
        int cardWidth = (int)((orientation == UIInterfaceOrientationPortrait) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/2;
	int noteIndex = 0;
	noteIndex = (int)([(SBAppSliderScrollView *)arg1 frame].origin.x/cardWidth);
	if (noteIndex > 7) {
	    noteIndex = 7;
	}
        CFURLRef soundFileURLRef;
        soundFileURLRef = (CFURLRef)[NSURL URLWithString:[NSString stringWithFormat:@"/Library/MusicalSwitcher/note%d.m4a", noteIndex]];
        UInt32 soundID;
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    %orig;
}


%end

