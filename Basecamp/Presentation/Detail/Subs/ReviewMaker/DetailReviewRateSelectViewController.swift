//
//  DetailReviewRateSelectView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/07.
//

import HorizonCalendar
import UIKit
import Cosmos
import SnapKit

final class DetailReviewRateSelectViewController: UIViewController {
  private let viewModel: DetailReviewMakerViewModel
  private var rateSelection: Double?
  
  private lazy var rateLabel = DefaultLabel(title: "캠핑의 만족도를 선택해주세요", font: .systemFont(ofSize: 20, weight: .semibold), textAlignment: .left)
  private lazy var cosmosView = CosmosView(settings: .default)
  private lazy var contentLabel = DefaultLabel(title: "캠핑에 대한 평가를 작성해주세요", font: .systemFont(ofSize: 20, weight: .semibold), textAlignment: .left)
  private lazy var contentTextView = StackingTextView(title: "최소 10자 이상 작성해주세요", font: .body2R16, textColor: .darkGray, textAlignment: .left, backgroundColor: .gray1, padding: .init(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
  private lazy var remainCountLabel: UILabel = {
    let label = UILabel()
    label.text = "0/200"
    label.font = .systemFont(ofSize: 12)
    label.textColor = .lightGray
    label.textAlignment = .right
    return label
  }()
  private lazy var rightBarNextButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.title = "다음"
    barButton.action = #selector(navigateToFlowPhoto)
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
    setupAttribute()
  }
  
  func setupAttribute() {
    cosmosView.settings.fillMode = .half
    cosmosView.rating = 0
    cosmosView.settings.starSize = 28
    cosmosView.settings.starMargin = 4
    cosmosView.settings.filledColor = .main
    cosmosView.settings.emptyBorderColor = .main
    cosmosView.settings.filledBorderColor = .main
    cosmosView.didFinishTouchingCosmos = { rating in self.rateSelection = rating }
    cosmosView.settings.disablePanGestures = true
    cosmosView.settings.filledImage = UIImage(named: "star")
    cosmosView.settings.emptyImage = UIImage(named: "starEmpty")
    contentTextView.delegate = self
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
    view.addGestureRecognizer(tapGesture)
    cosmosView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    contentTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    contentTextView.layer.cornerRadius = 16.0
    contentTextView.clipsToBounds = true
  }
  
  @objc func navigateToFlowPhoto() {
    guard let rateSelection = rateSelection,
          contentTextView.text != "최소 10자 이상 작성해주세요",
          contentTextView.text.count >= 10,
          let coordinator = viewModel.coordinator
    else {
      let alert = AlertView(title: "알림", message: "평가를 소중히 작성해주세요", buttonStyle: .confirm, okCompletion: nil)
      alert.showAlert()
      return
    }
    view.endEditing(true)
    viewModel.selectedRate.accept(rateSelection)
    viewModel.selectedContent.accept(contentTextView.text)
    coordinator.navigateToFlowPhoto(viewModel: viewModel)
  }
  
  @objc private func didTapTextView(_ sender: Any) {
    view.endEditing(true)
  }
  
  private func updateCountLabel(characterCount: Int) {
    remainCountLabel.text = "\(characterCount)/200"
    remainCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .paleBlue)
  }
}

extension DetailReviewRateSelectViewController: ViewRepresentable {
  func setupView() {
    [rateLabel, cosmosView, contentLabel, contentTextView, remainCountLabel].forEach {
      view.addSubview($0)
    }
    navigationItem.rightBarButtonItem = rightBarNextButton
  }
  
  func setupConstraints() {
    rateLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
    }
    
    cosmosView.snp.makeConstraints {
      $0.top.equalTo(rateLabel.snp.bottom).offset(16.0)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(44.0)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(cosmosView.snp.bottom).offset(16.0)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
    }
    
    contentTextView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(16.0)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
      $0.height.equalTo(160.0)
    }
    
    remainCountLabel.snp.makeConstraints {
      $0.trailing.equalTo(contentTextView.snp.trailing)
      $0.top.equalTo(contentTextView.snp.bottom).offset(8.0)
      $0.width.equalTo(80.0)
      $0.height.equalTo(16.0)
    }
  }
}

extension DetailReviewRateSelectViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "최소 10자 이상 작성해주세요" {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = "최소 10자 이상 작성해주세요"
      textView.textColor = .lightGray
      updateCountLabel(characterCount: 0)
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
    let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
    
    let characterCount = newString.count
    guard characterCount <= 200 else { return false }
    updateCountLabel(characterCount: characterCount)
    
    return true
  }
}
