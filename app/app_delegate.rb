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
    @mainWindow.backgroundColor = NSColor.colorWithDeviceRed(39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
    @mainWindow.setLevel(NSScreenSaverWindowLevel)

    @mainWindow.contentView.addSubview(createStartButton())
    @mainWindow.contentView.addSubview(createResetButton())
    @mainWindow.contentView.addSubview(createTimer())
  end

  def createTimer
    size = @mainWindow.frame.size
    font = NSFontManager.sharedFontManager.fontWithFamily("Lucida Grande", traits: NSBoldFontMask, weight: 0, size: 64)
    @label = NSTextField.alloc.initWithFrame([[10, 8 + 15], [size.width - 10 - 10, 80]])
    @label.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @label.bordered = false
    @label.backgroundColor = NSColor.colorWithDeviceRed(39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
    @label.stringValue = "00:00:00"
    @label.font = font
    @label
  end

  def createStartButton
    size = @mainWindow.frame.size
    button = NSButton.alloc.initWithFrame([[size.width - 8 - 15 - 4 - 15, 8], [15, 15]])
    button.title = ""
    button.action = "calc:"
    button.target = self
    button.bezelStyle = 0
    button.bordered = false
    button.cell.backgroundColor = NSColor.colorWithDeviceRed(26/255.0, green: 198/255.0, blue: 7/255.0, alpha: 1)
    button.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    button
  end

  def createResetButton
    size = @mainWindow.frame.size
    button = NSButton.alloc.initWithFrame([[size.width - 8 - 15, 8], [15, 15]])
    button.title = ""
    button.action = "calc:"
    button.target = self
    button.bezelStyle = 0
    button.bordered = false
    button.cell.backgroundColor = NSColor.colorWithDeviceRed(74/255.0, green: 74/255.0, blue: 31/255.0, alpha: 1)
    button.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    button
  end

  def windowDidResignMain(n)
    @mainWindow.setLevel(NSScreenSaverWindowLevel)
  end

  def calc(sender)
    puts "bla"
  end

end
