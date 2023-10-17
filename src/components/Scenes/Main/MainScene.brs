
function init()
  m.switchCountLabel = m.top.findNode("switchCountLabel")
  m.backgroundPoster = m.top.findNode("background")
  m.videoPlayer = m.top.findNode("videoPlayer")
  onSwitchCountSet()
end function

function onKeyEvent(key as string, press as boolean) as boolean
  handled = false
  if press
    if "back" = key
      if m.videoPlayer <> invalid
        m.videoPlayer.control = "stop"
      end if
      m.top.switchMode = true
      handled = true
    end if
  end if
  return handled
end function

sub onSwitchCountSet()
  updateLabel()
  updateBackground()
  initializeVideoPlayer()
end sub

sub updateLabel()
  m.switchCountLabel.text = "Screen Switches: "+m.top.switchCount.toStr()
end sub

sub updateBackground()
  imageUri = "pkg:/images/grey_1280x720.jpg"
  if  m.top.switchCount mod 2 = 1
    imageUri = "pkg:/images/blue_1280x720.jpg"
  end if
  m.top.backgroundUri = imageUri
end sub

sub initializeVideoPlayer()
  ' Set up video content object
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.title = "Example Video"
  videoContent.streamformat = "mp4"
  videoContent.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

  ' Set Up player
  m.videoPlayer.EnableCookies()
  m.videoPlayer.setCertificatesFile("common:/certs/ca-bundle.crt")
  m.videoPlayer.InitClientCertificates()
  ' Set the content to the video node
  m.videoPlayer.content = videoContent
  m.videoPlayer.enableUI = true
  m.videoPlayer.control = "play"
end sub