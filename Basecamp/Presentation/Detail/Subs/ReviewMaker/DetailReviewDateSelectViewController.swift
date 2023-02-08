//
//  DetailReviewMakerViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/06.
//

import HorizonCalendar
import UIKit
import SnapKit
import RealmSwift

enum CalendarSelection {
  case singleDay(Day)
  case dayRange(DayRange)
}

final class DetailReviewDateSelectViewController: UIViewController {
  private let viewModel: DetailReviewMakerViewModel
  private var calendarSelection: CalendarSelection?
  
  private lazy var calendarView = CalendarView(initialContent: makeContent())
  private lazy var rightBarNextButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.title = "다음"
    barButton.action = #selector(navigateToFlowRate)
    barButton.target = self
    barButton.style = .plain
    return barButton
  }()
  
  init(viewModel: DetailReviewMakerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    
    calendarView.daySelectionHandler = { [weak self] day in
      guard let self = self else { return }

      switch self.calendarSelection {
      case .singleDay(let selectedDay):
        if day > selectedDay {
          self.calendarSelection = .dayRange(selectedDay...day)
        } else {
          self.calendarSelection = .singleDay(day)
        }
      case .none, .dayRange:
        self.calendarSelection = .singleDay(day)
      }
      self.calendarView.setContent(self.makeContent())
    }
  }
  
  private func makeContent() -> CalendarViewContent {
    let calendar = Calendar.current
    
    let startDate = calendar.date(from: DateComponents(year: 2022, month: 01, day: 01))!
    let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!
    
    let calendarSelection = self.calendarSelection
    let dateRanges: Set<ClosedRange<Date>>
    
    lazy var dayDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = calendar
      dateFormatter.locale = calendar.locale
      dateFormatter.dateFormat = DateFormatter.dateFormat(
        fromTemplate: "EEEE, MMM d, yyyy",
        options: 0,
        locale: calendar.locale ?? Locale.current)
      return dateFormatter
    }()
    
    if
      case .dayRange(let dayRange) = calendarSelection,
      let lowerBound = calendar.date(from: dayRange.lowerBound.components),
      let upperBound = calendar.date(from: dayRange.upperBound.components)
    {
      dateRanges = [lowerBound...upperBound]
    } else {
      dateRanges = []
    }
    
    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions())
    )
    .interMonthSpacing(24)
    .verticalDayMargin(8)
    .horizontalDayMargin(8)
    
    .dayItemProvider { [calendar, dayDateFormatter] day in
      var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
      
      let isSelectedStyle: Bool
      switch calendarSelection {
      case .singleDay(let selectedDay):
        isSelectedStyle = day == selectedDay
      case .dayRange(let selectedDayRange):
        isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
      case .none:
        isSelectedStyle = false
      }
      
      if isSelectedStyle {
        invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .main
      }
      
      let date = calendar.date(from: day.components)
      
      return DayView.calendarItemModel(
        invariantViewProperties: invariantViewProperties,
        viewModel: .init(
          dayText: "\(day.day)",
          accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
          accessibilityHint: nil))
    }
    
    .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
      DayRangeIndicatorView.calendarItemModel(
        invariantViewProperties: .init(),
        viewModel: .init(
          framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
    }
  }
  
  @objc func navigateToFlowRate() {
    guard let coordinator = viewModel.coordinator,
          let calendarSelection = calendarSelection else {
      let alert = AlertView(title: "알림", message: "날짜를 선택해주세요", buttonStyle: .confirm, okCompletion: nil) 
      alert.showAlert()
      return
    }
    viewModel.selectedDate.accept(calendarSelection)
    coordinator.navigateToFlowRate(viewModel: viewModel)
  }
}

extension DetailReviewDateSelectViewController: ViewRepresentable {
  func setupView() {
    [calendarView].forEach {
      view.addSubview($0)
    }
    navigationItem.rightBarButtonItem = rightBarNextButton
  }
  
  func setupConstraints() {
    calendarView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
    }
  }
}

