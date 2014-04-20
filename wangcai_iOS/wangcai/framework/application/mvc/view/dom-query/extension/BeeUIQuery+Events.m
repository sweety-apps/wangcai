//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "BeeUIQuery+Events.h"

#pragma mark -

@implementation BeeUIQuery(Events)

@dynamic selected;
@dynamic focusing;

@dynamic FOCUS;
@dynamic BLUR;

@dynamic SELECT;
@dynamic UNSELECT;

@dynamic ENABLE;
@dynamic DISABLE;

- (BOOL)selected
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	
	for ( UIView * view in self.views )
	{
		if ( view )
		{
			if ( [view respondsToSelector:@selector(selected)] )
			{
				BOOL flag = (BOOL)objc_msgSend( view, @selector(selected) );
				if ( flag )
					return YES;
			}

			if ( [view respondsToSelector:@selector(state)] )
			{
				UIControlState state = (BOOL)objc_msgSend( view, @selector(state) );
				if ( state & UIControlStateSelected )
					return YES;
			}
		}
	}
	
#pragma clang diagnostic pop
	
	return NO;
}

- (BOOL)focusing
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	
	for ( UIView * view in self.views )
	{
		if ( view && [view respondsToSelector:@selector(isFirstResponder)] )
		{
			BOOL flag = (BOOL)objc_msgSend( view, @selector(isFirstResponder) );
			if ( flag )
				return YES;
		}
	}
	
#pragma clang diagnostic pop
	
	return NO;
}

- (BeeUIQueryObjectBlock)ENABLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.userInteractionEnabled = YES;
			
			if ( [v respondsToSelector:@selector(setEnabled:)] )
			{
				objc_msgSend( v, @selector(setEnabled:), YES );
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)DISABLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.userInteractionEnabled = NO;
			
			if ( [v respondsToSelector:@selector(setEnabled:)] )
			{
				objc_msgSend( v, @selector(setEnabled:), NO );
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FOCUS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			BOOL focus = [v becomeFirstResponder];
			if ( focus )
			{
				break;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)BLUR
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			BOOL focus = [v resignFirstResponder];
			if ( focus )
			{
				break;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SELECT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			if ( [v respondsToSelector:@selector(setSelected:)] )
			{
				objc_msgSend( v, @selector(setSelected:), YES );
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)UNSELECT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			if ( [v respondsToSelector:@selector(setSelected:)] )
			{
				objc_msgSend( v, @selector(setSelected:), NO );
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
