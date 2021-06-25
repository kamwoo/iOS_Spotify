//
//  AuthViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    // Spotify 로그인 화면을 web뷰로 띄운다.
    private let webView : WKWebView = {
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let web = WKWebView(frame: .zero, configuration: config)
        
        return web
    }()
    
    // 토큰 발급 성공 여부를 noti
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    // 로그인 후 정보 동의가 된 후
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // accessToken 발급받을 코드
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        webView.isHidden = true
        
        print("Code:\(code)")
        // 받은 코드로 accesstoken 발급
        AuthManager.shared.exchangeCodeForToken(code: code){ [weak self] result in
            // AuthView 닫기
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(result)
            }
        }
    }
    

}
