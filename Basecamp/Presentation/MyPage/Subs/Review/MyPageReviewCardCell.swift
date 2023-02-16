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
  @IBOutlet weak var dimmedLayer: UIView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  func setupData() {
    
  }
  
  func setupAttribute() {
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.cornerRadius = 16.0
    contentView.layer.masksToBounds = true
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.6
    contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    contentView.layer.shadowRadius = 3
  }
}
