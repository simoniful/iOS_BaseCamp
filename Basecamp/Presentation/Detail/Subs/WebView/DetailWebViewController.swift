//
//  DetailWebViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import WebKit
import SnapKit

protocol ScriptMessageHandlerDelegate: AnyObject {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
  
  deinit { print("____ DEINITED: \(self)") }
  private var configuration: WKWebViewConfiguration!
  private weak var delegate: ScriptMessageHandlerDelegate?
  private var scriptNamesSet = Set<String>()
  
  init(configuration: WKWebViewConfiguration, delegate: ScriptMessageHandlerDelegate) {
    self.configuration = configuration
    self.delegate = delegate
    super.init()
  }
  
  func deinitHandler() {
    scriptNamesSet.forEach { configuration.userContentController.removeScriptMessageHandler(forName: $0) }
    configuration = nil
  }
  
  func registerScriptHandling(scriptNames: [String]) {
    for scriptName in scriptNames {
      if scriptNamesSet.contains(scriptName) { continue }
      configuration.userContentController.add(self, name: scriptName)
      scriptNamesSet.insert(scriptName)
    }
  }
  
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    delegate?.userContentController(userContentController, didReceive: message)
  }
}

final class DetailWebViewController: UIViewController {
  public var data: SocialMediaInfo?
  private var webView: WKWebView!
  private var scriptMessageHandler: ScriptMessageHandler!
  
  deinit {
    scriptMessageHandler.deinitHandler()
    print("____ DEINITED: \(self)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    openWebPage()
  }
  
  func openWebPage() {
    guard let data = data else { return }
    title = data.title?.htmlToString
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)

    let baseURL = data.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    guard let url = URL(string: baseURL!) else { return }
    
    let configuration = WKWebViewConfiguration()
    scriptMessageHandler = ScriptMessageHandler(configuration: configuration, delegate: self)
    let scriptName = "GetUrlAtDocumentStart"
    scriptMessageHandler.registerScriptHandling(scriptNames: [scriptName])
    
    let jsScript = "webkit.messageHandlers.\(scriptName).postMessage(document.URL)"
    let script = WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    configuration.userContentController.addUserScript(script)
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    self.webView = webView
    webView.load(URLRequest(url: url))
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

extension DetailWebViewController: ScriptMessageHandlerDelegate {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print("received \"\(message.body)\" from \"\(message.name)\" script")
  }
}
