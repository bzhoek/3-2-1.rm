class TimerWindow < NSWindow

  def canBecomeKeyWindow
    true
  end

end

class TimerTextField < NSTextField

  def mouseDownCanMoveWindow
    true
  end

end