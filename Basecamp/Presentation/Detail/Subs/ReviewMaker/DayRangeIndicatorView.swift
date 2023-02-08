//
//  DayRangeIndicatorView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/06.
//

import HorizonCalendar
import UIKit

// MARK: - DayRangeIndicatorView
final class DayRangeIndicatorView: UIView {
  // MARK: Fileprivate
  fileprivate var framesOfDaysToHighlight = [CGRect]() {
    didSet {
      guard framesOfDaysToHighlight != oldValue else { return }
      setNeedsDisplay()
    }
  }
  
  // MARK: Private
  private let indicatorColor: UIColor
  
  // MARK: Lifecycle
  fileprivate init(indicatorColor: UIColor) {
    self.indicatorColor = indicatorColor
    
    super.init(frame: .zero)
    
    backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(indicatorColor.cgColor)
    
    if traitCollection.layoutDirection == .rightToLeft {
      context?.translateBy(x: bounds.midX, y: bounds.midY)
      context?.scaleBy(x: -1, y: 1)
      context?.translateBy(x: -bounds.midX, y: -bounds.midY)
    }
    
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in framesOfDaysToHighlight {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }
    
    for dayRowFrame in dayRowFrames {
      let cornerRadius = dayRowFrame.height / 2
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: cornerRadius)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setNeedsDisplay()
  }
}

// MARK: CalendarItemViewRepresentable
extension DayRangeIndicatorView: CalendarItemViewRepresentable {
  static func setViewModel(_ viewModel: Content, on view: DayRangeIndicatorView) {
    view.framesOfDaysToHighlight = viewModel.framesOfDaysToHighlight
  }
  typealias ViewType = DayRangeIndicatorView
  typealias ViewModel = Content
  
  struct InvariantViewProperties: Hashable {
    var indicatorColor = UIColor.main.withAlphaComponent(0.15)
  }
  
  struct Content: Equatable {
    let framesOfDaysToHighlight: [CGRect]
  }
  
  static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
  -> DayRangeIndicatorView {
    DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
  }
}
