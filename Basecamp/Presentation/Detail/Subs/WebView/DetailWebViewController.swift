//
//  DetailWebViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import WebKit
import SnapKit

final class DetailWebViewController: UIViewController {
  weak var coordinator: DetailCoordinator?
  public var data: SocialMediaInfo?
  
  private let webView = WKWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    openWebPage()
  }
  
  func openWebPage() {
    guard let data = data else { return }
    title = data.title?.htmlToString
    let baseURL = data.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    guard let url = URL(string: baseURL!) else { return }
    let requset = URLRequest(url: url)
    webView.load(requset)
  }
}

extension DetailWebViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(webView)
  }
  
  func setupConstraints() {
    webView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
