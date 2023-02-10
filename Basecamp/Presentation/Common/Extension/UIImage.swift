//
//  UIImage.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/07.
//

import UIKit

extension UIImage {
  func resize(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    
    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
    return renderImage
  }
  
  func downSample(size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
    let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
    let data = self.pngData()! as CFData
    let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!
    
    let maxPixel = max(size.width, size.height) * scale
    let downSampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixel
    ] as CFDictionary
    
    let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
    
    let newImage = UIImage(cgImage: downSampledImage)
    return newImage
  }
}