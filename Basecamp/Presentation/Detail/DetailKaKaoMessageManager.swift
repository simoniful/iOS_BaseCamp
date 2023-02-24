//
//  DetailKaKaoMessageManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

struct DetailKaKaoMessageManager {
  static var share = DetailKaKaoMessageManager()
  
  func commitKaKaoMessage(campsite: Campsite) {
    if ShareApi.isKakaoTalkSharingAvailable(){
      let appLink = Link(iosExecutionParams: ["second": "vvv"])
      
      let button = Button(title: "앱에서 보기", link: appLink)
      let imageUrl = campsite.firstImageURL.isEmpty ? "https://images2.imgbox.com/3d/34/7xkF2x0U_o.png" : campsite.firstImageURL
      var description: String = ""
      description += campsite.addr1.isEmpty ? "" : "주소: " + campsite.addr1 + "\n"
      description += campsite.tel.isEmpty ? "" : "문의처: " + campsite.tel
      let content = Content(title: campsite.facltNm,
                            imageUrl: URL(string: imageUrl)!,
                            description: description,
                            link: appLink)
      let template = FeedTemplate(content: content, buttons: [button])
      
      if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
        
        if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
          ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
            if let error = error {
              print("error : \(error)")
            }
            else {
              print("defaultLink(templateObject:templateJsonObject) success.")
              guard let linkResult = linkResult else { return }
              UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
            }
          }
        }
      }
    }
    else {
      print("카카오톡 미설치")
    }
  }
  
  func commitKaKaoMessage(touristInfo: TouristInfo, common: TouristInfoCommon) {
    if ShareApi.isKakaoTalkSharingAvailable() {
      let appLink = Link(iosExecutionParams: ["second": "vvv"])
      let button = Button(title: "앱에서 보기", link: appLink)
      let imageUrl = touristInfo.mainImage!.isEmpty ? "https://images2.imgbox.com/3d/34/7xkF2x0U_o.png" : touristInfo.mainImage
      var description: String = ""
      description += common.homepage!.isEmpty ? "" : "홈페이지: " +
      common.homepage!.htmlToString
      let content = Content(title: touristInfo.title!,
                            imageUrl: URL(string: imageUrl!)!,
                            description: description,
                            link: appLink)
      let template = FeedTemplate(content: content, buttons: [button])
      
      if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
        
        if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
          ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
            if let error = error {
              print("error : \(error)")
            }
            else {
              print("defaultLink(templateObject:templateJsonObject) success.")
              guard let linkResult = linkResult else { return }
              UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
            }
          }
        }
      }
    }
    else {
      print("카카오톡 미설치")
    }
  }
}
