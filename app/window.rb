class TimerWindow < NSWindow

  def canBecomeKeyWindow
    true
  end

end

class DragThroughTextField < NSTextField

  def mouseDownCanMoveWindow
    true
  end

end