//
//  ReviewMakerViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/08.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

struct DetailReviewMakerViewModel {
  public weak var coordinator: DetailCoordinator?
  public let reviewMakerUseCase: ReviewMakerUseCase
  private let campsite: Campsite
  
  private var disposeBag = DisposeBag()
  
  init(coordinator: DetailCoordinator?, reviewMakerUseCase: ReviewMakerUseCase, campsite: Campsite) {
    self.coordinator = coordinator
    self.reviewMakerUseCase = reviewMakerUseCase
    self.campsite = campsite
  }
  
  public let selectedDate = BehaviorRelay<CalendarSelection?>(value: nil)
  public let selectedRate = BehaviorRelay<Double?>(value: nil)
  public let selectedContent = BehaviorRelay<String?>(value: nil)
  public let selectedPhotos = BehaviorRelay<[UIImage]?>(value: nil)
  
  func saveReview() {
    guard let date = selectedDate.value,
          let rate = selectedRate.value,
          let content = selectedContent.value,
          let photos = selectedPhotos.value else { return }
    
    var review: Review
    switch date {
    case .singleDay(let day):
      guard let selectedDate = NSCalendar.current.date(from: day.components) else { return }
      review = Review(
        _id: ObjectId.generate(),
        rate: rate,
        content: content,
        regDate: Date(),
        startDate: selectedDate,
        endDate: selectedDate,
        campsite: campsite
      )
    case .dayRange(let dayRange):
      guard let startDate = NSCalendar.current.date(from: dayRange.lowerBound.components),
            let endDate = NSCalendar.current.date(from: dayRange.upperBound.components) else { return }
      review = Review(
        _id: ObjectId.generate(),
        rate: rate,
        content: content,
        regDate: Date(),
        startDate: startDate,
        endDate: endDate,
        campsite: campsite
      )
    }
    
    reviewMakerUseCase.requestSaveReview(review: review)
    saveImageToDocuments(imageName: review._id.stringValue, image: photos.first!)
    coordinator?.navigationController.view.makeToast("캠핑로그 저장완료!")
  }
  
  func saveImageToDocuments(imageName: String, image: UIImage) {
      guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
      let imagesDirectoryURL = documentDirectory.appendingPathComponent("images")
      if !(FileManager.default.fileExists(atPath: imagesDirectoryURL.path)) {
          do {
              try FileManager.default.createDirectory(atPath: imagesDirectoryURL.path, withIntermediateDirectories: false, attributes: nil)
          } catch let error {
              print(error.localizedDescription)
          }
      }
      let imageURL = imagesDirectoryURL.appendingPathComponent(imageName)
      let image = image.resize(newWidth: UIScreen.main.bounds.width * 2)
      guard let data = image.jpegData(compressionQuality: 0.3) else { return }
      if FileManager.default.fileExists(atPath: imageURL.path) {
          do {
              try FileManager.default.removeItem(at: imageURL)
              print("이미지 삭제 완료")
          } catch {
              print("이미지 삭제 실패")
          }
      }
      do {
          try data.write(to: imageURL)
      } catch {
          print("이미지 저장 실패")
      }
  }
}
