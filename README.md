#Quick Start

Here is what you need to know about vp

	vp = new VP(
		size:String, 
		videoPath:String, 
		disableFullScreen:Boolean, 
		teaserMode:Boolean = false, 
		autoMute:Boolean = false, 
		autoPlay:Boolean = true, 
		autoHideBar:Boolean = false, 
		disableController:Boolean = false);
	}}}

`teaserMode` is a shortcut to play the video without sound and controller.

`autoMute` will load the video on mute.

`autoPlay` will play the video on load.

`autoHideBar` will hide the control bar on load.

## Events

`VIDEO_10S`

`VIDEO_START`

`VIDEO_PAUSE`

`VIDEO_COMPLETE` fires 5 sec before the end of the video.

`VIDEO_END`

`VIDEO_MIDPOINT`

`VIDEO_REPLAY`

`VIDEO_MUTE`

`VIDEO_UNMUTE`

`VIDEO_FULLSCREEN`

`VIDEO_EXIT_FULLSCREEN`

## Methods

`playVideo()`

`pauseVideo()`

`makeSoundOff()`

`makeSoundOn()`

`loadNewVideo()`

`closeStream()`

`disableController()`

`restartVideo()`

`help()`
