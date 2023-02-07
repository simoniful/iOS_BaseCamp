//
//  DetailReviewPhotoSelectViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/07.
//

import UIKit

final class DetailReviewPhotoSelectViewController: UIViewController {
  public weak var coordinator: DetailCoordinator?
  
  public var campsite: Campsite?
  public var calendarSelection: CalendarSelection?
  public var rateSelection: Double?
  private var photoSelection: UIImage?
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
}
