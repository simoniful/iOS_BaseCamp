//
//  FSPagerViewCustomTransformer.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/18.
//

import Foundation
import FSPagerView

class FSPagerViewCustomTransformer: FSPagerViewTransformer {
  override func applyTransform(to attributes: FSPagerViewLayoutAttributes) {
    guard let pagerView = self.pagerView else {
      return
    }
    let position = attributes.position
    let scrollDirection = pagerView.scrollDirection
    let itemSpacing = (scrollDirection == .horizontal ? attributes.bounds.width : attributes.bounds.height) + self.proposedInteritemSpacing()
    if self.type == .linear {
      guard scrollDirection == .horizontal else {
        return
      }
      let scale = max(1 - (1 - 0.8) * abs(position), 0.8)
      let transform = CGAffineTransform(scaleX: scale, y: scale)
      attributes.transform = transform
      let alpha = (self.minimumAlpha + (1-abs(position))*(1-self.minimumAlpha))
      attributes.alpha = alpha
      let zIndex = (1-abs(position)) * 10
      attributes.zIndex = Int(zIndex)
    } else {
      super.applyTransform(to: attributes)
    }
  }
  
  override func proposedInteritemSpacing() -> CGFloat {
    guard let pagerView = self.pagerView else {
        return 0
    }
    let scrollDirection = pagerView.scrollDirection
    if self.type == .linear {
      guard scrollDirection == .horizontal else {
          return 0
      }
      return pagerView.itemSize.width * -0.8 * 0.05
    }
    return pagerView.interitemSpacing
  }
}
