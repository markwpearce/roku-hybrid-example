sub main()
  m.switchCount = 0
  m.port = CreateObject("roMessagePort")
  launchSceneGraph()

  while true
    msg = wait(0, m.port)
    msgType = type(msg)
    if "roSGNodeEvent" = msgType
      msgField = msg.getField()
      msgData = msg.getData()
      if "switchMode" = msgField and msgData
        ' On switching modes, first create an roScreen, so the app doesn't close
        initializeDraw2d()
        ' Now it is safe to close the Scenegraph scene
        m.screen.close()
        m.screen = invalid
        launchSimpleDraw2d()
        m.switchCount++
        ' Create the
        launchSceneGraph()
      end if
    end if
  end while
end sub

' Initiaize a Draw2d (roScreen) object
sub initializeDraw2d()
  m.draw2dScreen = CreateObject("roScreen", true, 1280, 720)
  m.draw2dScreen.SwapBuffers()
end sub

' Close the active Draw2d (roScreen) object, if it exists
sub closeDraw2d()
  if m.draw2dScreen <> invalid
    m.draw2dScreen.SwapBuffers()
    m.draw2dScreen = invalid
  end if
  RunGarbageCollector()
end sub

' Create the Screen object and main message port
sub launchSceneGraph()
  m.screen = CreateObject("roSGScreen")
  m.screen.setMessagePort(m.port)
  m.scene = m.screen.CreateScene("MainScene")
  m.screen.show()

  ' Since SceneGraph is active, it is safe to close the roScreen (Draw2d)
  closeDraw2d()

  m.scene.observeField("switchMode", m.port)
  m.scene.switchMode = false
  m.scene.switchCount =  m.switchCount
  m.scene.setFocus(true)
end sub


' Run a display update loop for Draw2d, and accept input
sub launchSimpleDraw2d(waitForInput = true)
  if m.draw2dScreen = invalid
    initializeDraw2d()
  end if
  draw2dPort = CreateObject("roMessagePort")
  m.draw2dScreen.SetMessagePort(draw2dPort)
  if m.fontRegistry = invalid
    m.fontRegistry = CreateObject("roFontRegistry")
  end if
  keepGoing = true
  drawX = 0
  drawY = 300
  rectSpeed = 20
  while keepGoing
    screen_msg = draw2dPort.GetMessage()
    buttonPress = -1
    while screen_msg <> invalid
      if type(screen_msg) = "roUniversalControlEvent" and screen_msg.GetInt() <> 11
        buttonPress = screen_msg.GetInt()
      end if
      screen_msg = draw2dPort.GetMessage()
    end while
    if waitForInput
      drawSimpleScene(drawX, drawY, 200, 100, &hFF0000FF)
    end if
    drawX += rectSpeed
    if drawX > 1280
      drawX = 0
    end if
    if buttonPress = 0
      keepGoing = false
    end if
  end while
end sub

' Do some Draw2d operations
sub drawSimpleScene(rectX, rectY, rectW, rectH, color)
  m.draw2dScreen.drawText("This is Draw2d. Press Back to change modes", 200, 200, -1, m.fontRegistry.GetDefaultFont())
  m.draw2dScreen.drawText("Switch count: "+m.switchCount.toStr(), 200, 250, -1, m.fontRegistry.GetDefaultFont())
  m.draw2dScreen.drawRect(rectX, rectY, rectW, rectH, color)
  m.draw2dScreen.SwapBuffers()
end sub