//
//  WelcomeViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // Spotify 로그인 api
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In Spotify ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
    }
    
    // 로그인 버튼 클릭시 Spotify 로그인 webView로 push
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        // 토큰 발급 여부
        vc.completionHandler = { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSignIn(success: result)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 토큰 발급 여부에 따른 로직
    private func handleSignIn(success: Bool){
        guard success else {
            // 토큰 발급에 실패했을 때 알림
            let alert = UIAlertController(title: "알림",
                                          message: "로그인 중 문제가 발생했습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        // 토큰 발급에 성공했다면 홈뷰로 이동
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true, completion: nil)
    }

}
