@interface UIStatusBarBatteryItemView : UIView
-(BOOL)_needsAccessoryImage; // iOS 7 - 11
-(UIImage *)_accessoryImage; // iOS 7 - 11
@end

%hook UIStatusBarBatteryItemView
-(CGRect)frame {
	CGRect result = %orig;
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