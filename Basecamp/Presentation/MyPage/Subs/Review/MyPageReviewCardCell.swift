//
//  MyPageReviewCardCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/16.
//

import UIKit
import FSPagerView
import Cosmos

class MyPageReviewCardCell: FSPagerViewCell {
  @IBOutlet weak var indexLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var cosmosRateView: CosmosView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dimmedLayer: UIView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  func setupData(data: Review, index: Int, image: UIImage) {
    indexLabel.text = "#\(index + 1)"
    titleLabel.text = data.campsite.facltNm
    addressLabel.text = data.campsite.addr1
    dateLabel.text = "\(data.startDate.toString(format: "yyyy년 MM월 dd일")) ~ \(data.endDate.toString(format: "yyyy년 MM월 dd일"))"
    cosmosRateView.rating = data.rate
    backgroundImageView.image = image
    contentLabel.text = data.content
  }
  
  func setupAttribute() {
    [titleLabel, addressLabel, dateLabel].forEach {
      $0.minimumScaleFactor = 0.2
      $0.adjustsFontSizeToFitWidth = true
    }
    
    dimmedLayer.clipsToBounds = true
    dimmedLayer.layer.borderWidth = 1.0
    dimmedLayer.layer.borderColor = UIColor.clear.cgColor
    dimmedLayer.layer.cornerRadius = 16.0
    
    cosmosRateView.settings.updateOnTouch = false
    cosmosRateView.settings.fillMode = .half
    
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.clipsToBounds = true
    backgroundImageView.layer.borderWidth = 1.0
    backgroundImageView.layer.borderColor = UIColor.clear.cgColor
    backgroundImageView.layer.cornerRadius = 16.0
  }
}
