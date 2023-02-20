//
//  MyPageInfoWebViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/20.
//

import UIKit
import WebKit
import SnapKit

final class MyPageInfoWebViewController: UIViewController,  WKScriptMessageHandler {
  public var data: MyPageInfoCase?
  private var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    openWebPage()
    setupView()
    setupConstraints()
  }
  
  func openWebPage() {
    guard let data = data else { return }
    title = data.rawValue
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)

    let baseURL = data.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    guard let url = URL(string: baseURL!) else { return }
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(LeakAvoider(delegate: self), name: "callback")
    
    webView = WKWebView(frame: .zero, configuration: configuration)
    webView.load(URLRequest(url: url))
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print(message)
  }
}

extension MyPageInfoWebViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(webView)
  }
  
  func setupConstraints() {
    webView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
