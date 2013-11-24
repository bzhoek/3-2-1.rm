class AppDelegate

  BACKGROUND = NSColor.colorWithDeviceRed(39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
  START_COLOR = NSColor.colorWithDeviceRed(26/255.0, green: 198/255.0, blue: 7/255.0, alpha: 1)
  RUNNING_COLOR = NSColor.colorWithDeviceRed(253/255.0, green: 0/255.0, blue: 6/255.0, alpha: 1)
  RESET_ACTIVE = NSColor.colorWithDeviceRed(255/255.0, green: 255/255.0, blue: 11/255.0, alpha: 1)
  RESET_DIMMED = NSColor.colorWithDeviceRed(74/255.0, green: 74/255.0, blue: 31/255.0, alpha: 1)

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    resetTimer
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [312, 116]],
      styleMask: NSTexturedBackgroundWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
    @mainWindow.delegate = self
    @mainWindow.backgroundColor = BACKGROUND
    @mainWindow.setLevel(NSScreenSaverWindowLevel)

    @mainWindow.contentView.addSubview(createClock())
    @mainWindow.contentView.addSubview(createLimit())
    @mainWindow.contentView.addSubview(createStartButton())
    @mainWindow.contentView.addSubview(createResetButton())
  end

  def createClock
    size = @mainWindow.frame.size
    font = NSFontManager.sharedFontManager.fontWithFamily("Lucida Grande", traits: NSBoldFontMask, weight: 0, size: 64)
    @clock = NSTextField.alloc.initWithFrame([[10, 8 + 15], [size.width - 10 - 10, 80]])
    @clock.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @clock.bordered = false
    @clock.editable = false
    @clock.backgroundColor = BACKGROUND
    @clock.stringValue = "00:00:00"
    @clock.font = font
    @clock
  end

  def createLimit
    size = @mainWindow.frame.size
    font = NSFontManager.sharedFontManager.fontWithFamily("Lucida Grande", traits: NSBoldFontMask, weight: 0, size: 12)
    @limit = NSTextField.alloc.initWithFrame([[10, 8], [60, 15]])
    @limit.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @limit.bordered = false
    @limit.selectable = true
    @limit.editable = true
    @limit.backgroundColor = BACKGROUND
    @limit.stringValue = "00:00:00"
    @limit.font = font
    @limit
  end

  def createStartButton
    size = @mainWindow.frame.size
    @start = NSButton.alloc.initWithFrame([[size.width - 8 - 15 - 4 - 15, 8], [15, 15]])
    @start.title = ""
    @start.action = "startStopTimer:"
    @start.target = self
    @start.bezelStyle = 0
    @start.bordered = false
    @start.cell.backgroundColor = START_COLOR
    @start.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @start
  end


  def createResetButton
    size = @mainWindow.frame.size
    @reset = NSButton.alloc.initWithFrame([[size.width - 8 - 15, 8], [15, 15]])
    @reset.title = ""
    @reset.action = "resetTimer:"
    @reset.target = self
    @reset.bezelStyle = 0
    @reset.bordered = false
    @reset.cell.backgroundColor = RESET_DIMMED
    @reset.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @reset
  end

  def windowDidResignMain(n)
    @mainWindow.setLevel(NSScreenSaverWindowLevel)
  end

  def resetTimer(sender = nil)
    @countDown = 1.0 * 15 * 60
    drawTimer
  end

  def startStopTimer(sender)
    if @timer.nil?
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
        :target => self,
        :selector => 'timerFired',
        :userInfo => nil,
        :repeats => true)
      @start.cell.backgroundColor = RUNNING_COLOR
      @reset.cell.backgroundColor = RESET_ACTIVE
    else
      @timer.invalidate
      @timer = nil
      @start.cell.backgroundColor = START_COLOR
      @reset.cell.backgroundColor = RESET_DIMMED
    end
  end

  def timerFired
    @countDown -= 0.1
    drawTimer
  end

  def drawTimer
    @clock.stringValue = "00:%02d:%02d" % [@countDown / 60, @countDown % 60]
  end

end
