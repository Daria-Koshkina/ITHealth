//
//  WebViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import UIKit
import WebKit
import SVProgressHUD

// MARK: - Protocols

protocol WebViewControllerOutput: AnyObject {
  func didRedirect(from: WebViewController, token: String)
}

// MARK: - Enums

enum WebViewSource {
  case urlRequest(URLRequest)
  case html(string: String, baseURL: URL?)
}

class WebViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {

  // MARK: - Public variables
  weak var output: WebViewControllerOutput!

  // MARK: - Private variables
  private var webView: WKWebView!
  private let source: WebViewSource
  private let navBarTitle: String?

  private lazy var configuration = WKWebViewConfiguration() {
    didSet {
      let contentController = WKUserContentController()
      configuration.userContentController = contentController
    }
  }

  // MARK: - Life cycle
  init(source: WebViewSource,
       navBarTitle: String? = nil) {
    self.source = source
    self.navBarTitle = navBarTitle
    super.init()
  }

  override func loadView() {
    webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureWebView()
    localize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.interactivePopGestureRecognizer?.delegate = navigationController as? UIGestureRecognizerDelegate
  }

  deinit {
    webView.stopLoading()
    webView.navigationDelegate = nil
  }

  // MARK: - Interface
  func loadRequest(_ request: URLRequest) {
    webView.load(request)
  }

  func loadHTMLString(_ htmlString: String, baseURL: URL?) {
    webView.loadHTMLString(htmlString, baseURL: baseURL)
  }

  // MARK: - Private methods
  private func configureNavigationBar() {
    navigationItem.title = navBarTitle
    navigationItem.hidesBackButton = true
  }

  private func configureWebView() {
    webView.backgroundColor = .white
    webView.isOpaque = false
    webView.scrollView.backgroundColor = .white

    switch source {
    case .urlRequest(let request):
      webView.load(request)
    case .html(let string, let baseURL):
      webView.loadHTMLString(string, baseURL: baseURL)
    }
  }

  // MARK: - Localization
  override func localize() { }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url,
       url.absoluteString.contains("#token="),
       let startIndex = url.absoluteString.firstIndex(of: "=") {
      let token = String(url.absoluteString.suffix(from: url.absoluteString.index(after: startIndex)))
      output.didRedirect(from: self, token: token)
    }
    decisionHandler(.allow)
  }

  func webView(_ webView: WKWebView,
               didFail navigation: WKNavigation!,
               withError error: Error) {
    if (error as NSError).code == ServerError.webViewNoInternet.type.rawValue {
      handleError(ServerError.webViewNoInternet)
    }
    debugPrint(error)
  }

  func webView(_ webView: WKWebView,
               didFailProvisionalNavigation navigation: WKNavigation!,
               withError error: Error) {
    if (error as NSError).code == ServerError.webViewNoInternet.type.rawValue {
      handleError(ServerError.webViewNoInternet)
    }
    debugPrint(error)
  }

}

// MARK: - UIGestureRecognizerDelegate
extension WebViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}

