@interface _UILegibilityView : UIView // iOS 7 - 12
@property (nonatomic, retain) UIImage *image; // iOS 7 - 12
@end

@interface _UILegibilityImageSet : NSObject // iOS 7 - 12
@property (nonatomic,retain) UIImage *image; // iOS 7 - 12
@end

@interface UIStatusBarBatteryItemView : UIView // iOS 7 - 12
-(BOOL)_needsAccessoryImage; // iOS 7 - 12
-(UIImage *)_accessoryImage; // iOS 7 - 12
-(_UILegibilityImageSet *)_contentsImage; // iOS 7 - 12
@end

%hook UIStatusBarBatteryItemView
-(CGRect)frame {
	CGRect result = %orig;
	// remove battery icon from view hiearchy
	_UILegibilityImageSet *_contentsImageSet = [self _contentsImage];
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:%c(_UILegibilityView)]) {
			UIImage *legibilityImage = ((_UILegibilityView *)view).image;
			if ([legibilityImage isEqual:_contentsImageSet.image]) {
				[view removeFromSuperview];
				break;
			}
		}
	}
	result.size.width = [self _needsAccessoryImage] ? [self _accessoryImage].size.width : 0;
	self.clipsToBounds = YES;
	return result;
}
%end

%ctor {
	NSArray *args = [[NSProcessInfo processInfo] arguments];
	if (args != nil && args.count != 0) {
		NSString *execPath = args[0];
		if (execPath) {
			BOOL isSpringBoard = [[execPath lastPathComponent] isEqualToString:@"SpringBoard"];
			BOOL isApplication = [execPath rangeOfString:@"/Application"].location != NSNotFound;
			if (isSpringBoard || isApplication)
				%init;
		}
	}
}