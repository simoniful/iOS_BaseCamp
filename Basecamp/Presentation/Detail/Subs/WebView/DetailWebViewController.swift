//
//  DetailWebViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import WebKit
import SnapKit

final class DetailWebViewController: UIViewController,  WKScriptMessageHandler {
  public var data: SocialMediaInfo?
  private var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    openWebPage()
    setupView()
    setupConstraints()
  }
  
  func openWebPage() {
    guard let data = data else { return }
    title = data.title?.htmlToString
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)

    let baseURL = data.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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

class LeakAvoider: NSObject, WKScriptMessageHandler {
  weak var delegate: WKScriptMessageHandler?
  init(delegate: WKScriptMessageHandler) {
    self.delegate = delegate
    super.init()
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    self.delegate?.userContentController(userContentController, didReceive: message)
  }
}
