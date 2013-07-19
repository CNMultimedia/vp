#Quick Start

= Introduction =

The official wiki page is too long to read :) so here is what you need to know about vp-rc.

{{{
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

_teaserMode_ is an optional parameter, let's say you need to create an expanding banner with a looping video in the collapsed state then you would need it to have no sound and no controller. TADA!

_autoMute_ will load the video on mute.

_autoPlay_ will play the video on load

_autoHideBar_ will hide the control bar on load

= Events =
VIDEO_10S

VP_READY (Deprecated)

VIDEO_START

VIDEO_PAUSE

_VIDEO_COMPLETE_ fires 5 sec before the end of the video.

_VIDEO_END_

VIDEO_MIDPOINT

VIDEO_REPLAY

VIDEO_MUTE

VIDEO_UNMUTE

VIDEO_FULLSCREEN

VIDEO_EXIT_FULLSCREEN

= Methods =

playVideo()

pauseVideo()

makeSoundOff()

makeSoundOn()

loadNewVideo()

closeStream()

disableController()

restartVideo()

help()
