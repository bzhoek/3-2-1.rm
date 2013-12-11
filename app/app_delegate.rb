class AppDelegate

  BACKGROUND = NSColor.colorWithDeviceRed(39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
  TIMER_ACTIVE = NSColor.colorWithDeviceRed(42/255.0, green: 168/255.0, blue: 18/255.0, alpha: 1)
  TIMER_DIMMED = NSColor.colorWithDeviceRed(21/255.0, green: 84/255.0, blue: 59/255.0, alpha: 1)
  TIMER_RUNNING = NSColor.colorWithDeviceRed(206/255.0, green: 77/255.0, blue: 69/255.0, alpha: 1)
  RESET_ACTIVE = NSColor.colorWithDeviceRed(255/255.0, green: 210/255.0, blue: 101/255.0, alpha: 1)
  RESET_DIMMED = NSColor.colorWithDeviceRed(127/255.0, green: 105/255.0, blue: 50/255.0, alpha: 1)
  CLOCK_ACTIVE = NSColor.colorWithDeviceRed(10/255.0, green: 123/255.0, blue: 131/255.0, alpha: 1)
  CLOCK_RUNNING = NSColor.colorWithDeviceRed(19/255.0, green: 239/255.0, blue: 255/255.0, alpha: 1)
  CLOCK_DIMMED = NSColor.colorWithDeviceRed(5/255.0, green: 60/255.0, blue: 64/255.0, alpha: 1)

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    parseLimit
    drawTimer

    filePath = NSBundle.mainBundle.pathForResource("simple_bell", ofType: "aif")
    @sound = NSSound.alloc.initWithContentsOfFile(filePath, byReference: true)
  end

  def buildWindow
    @mainWindow = TimerWindow.alloc.initWithContentRect([[240, 180], [312, 116]],
      styleMask: NSTexturedBackgroundWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
    @mainWindow.level = NSScreenSaverWindowLevel
    @mainWindow.delegate = self
    @mainWindow.backgroundColor = BACKGROUND

    @mainWindow.contentView.addSubview(createClock())
    @mainWindow.contentView.addSubview(createLimit())
    @mainWindow.contentView.addSubview(createClockButton())
    @mainWindow.contentView.addSubview(createTimerButton())
    @mainWindow.contentView.addSubview(createResetButton())
    @mainWindow.contentView.addSubview(createTitle())
  end

  def createTitle
    size = @mainWindow.frame.size
    @title = DragThroughTextField.alloc.initWithFrame([[0, size.height - 24], [size.width, 20]])
    @title.bordered = false
    @title.editable = false
    @title.backgroundColor = BACKGROUND
    @title.alignment = NSCenterTextAlignment
    @title.stringValue = "三二一"
    @title
  end

  def createClock
    size = @mainWindow.frame.size
    @display = DragThroughTextField.alloc.initWithFrame([[10, 8 + 15], [size.width - 10 - 10, 80]])
    @display.bordered = false
    @display.editable = false
    @display.backgroundColor = BACKGROUND
    @display.stringValue = "00:00:00"
    @display.font = NSFontManager.sharedFontManager.fontWithFamily("Lucida Grande", traits: NSBoldFontMask, weight: 0, size: 64)
    @display
  end

  def createLimit
    size = @mainWindow.frame.size
    font = NSFontManager.sharedFontManager.fontWithFamily("Lucida Grande", traits: NSBoldFontMask, weight: 0, size: 12)
    @limit = NSTextField.alloc.initWithFrame([[10, 8], [60, 15]])
    @limit.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @limit.bordered = false
    @limit.editable = true
    @limit.backgroundColor = BACKGROUND
    @limit.stringValue = "00:00:10"
    @limit.font = font
    @limit.delegate = self
    @limit.alignment = NSRightTextAlignment
    @limit
  end

  def controlTextDidChange(n)
    parseLimit
    drawTimer
  end

  def createClockButton
    size = @mainWindow.frame.size
    @clock = NSButton.alloc.initWithFrame([[size.width - 8 - 15 - 4 - 15 - 4 - 15, 8], [15, 15]])
    @clock.title = ""
    @clock.action = "startStopClock:"
    @clock.target = self
    @clock.bezelStyle = 0
    @clock.bordered = false
    @clock.cell.backgroundColor = CLOCK_ACTIVE
    @clock.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @clock
  end

  def createTimerButton
    size = @mainWindow.frame.size
    @timer = NSButton.alloc.initWithFrame([[size.width - 8 - 15 - 4 - 15, 8], [15, 15]])
    @timer.title = ""
    @timer.action = "startStopTimer:"
    @timer.target = self
    @timer.bezelStyle = 0
    @timer.bordered = false
    @timer.cell.backgroundColor = TIMER_ACTIVE
    @timer.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @timer
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
    return if @countdown_timer.nil?
    @limit.window.makeFirstResponder(nil)
    @timer.cell.backgroundColor = TIMER_ACTIVE
    @reset.cell.backgroundColor = RESET_DIMMED
    parseLimit
    drawTimer
  end

  def startStopClock(sender)
    if @clock_timer.nil?
      drawClock
      @clock_timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
        :target => self,
        :selector => 'drawClock',
        :userInfo => nil,
        :repeats => true)
      stopTimer
      @clock.cell.backgroundColor = CLOCK_RUNNING
    else
      stopClock
    end
  end

  def startStopTimer(sender)
    @limit.window.makeFirstResponder(nil)
    if @countdown_timer.nil?
      @countdown_timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
        :target => self,
        :selector => 'timerFired',
        :userInfo => nil,
        :repeats => true)
      stopClock
      @timer.cell.backgroundColor = TIMER_RUNNING
      @reset.cell.backgroundColor = RESET_ACTIVE
    else
      stopTimer
    end
  end

  def stopTimer
    return if @countdown_timer.nil?
    @countdown_timer.invalidate
    @countdown_timer = nil
    @timer.cell.backgroundColor = TIMER_ACTIVE
    @reset.cell.backgroundColor = RESET_DIMMED
  end

  def stopClock
    return if @clock_timer.nil?
    @clock_timer.invalidate
    @clock_timer = nil
    @clock.cell.backgroundColor = CLOCK_ACTIVE
    drawTimer
  end

  def parseLimit
    @countDown = 0
    @limit.stringValue.split(':').reverse.each_with_index do |e, i|
      @countDown += (60 ** i) * e.to_i
    end
  end

  def timerFired
    @countDown -= 1
    if @countDown == 0
      @countDown = 0
      @countdown_timer.invalidate
      @countdown_timer = nil
      @timer.cell.backgroundColor = TIMER_DIMMED
      @sound.play
    end
    drawTimer
  end

  def drawTimer
    @display.stringValue = "00:%02d:%02d" % [@countDown / 60, @countDown % 60]
  end

  def drawClock
    @display.stringValue = Time.now.strftime("%H:%M:%S")
  end

end
