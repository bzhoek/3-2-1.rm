class AppDelegate

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [312, 116]],
      styleMask: NSTexturedBackgroundWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
    @mainWindow.delegate = self
    @mainWindow.backgroundColor = NSColor.grayColor
  end

  def windowDidResignMain(n)
    @mainWindow.setLevel(NSScreenSaverWindowLevel)
  end

end
