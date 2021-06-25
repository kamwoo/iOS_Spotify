//
//  AuthManager.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import Foundation

final class AuthManager {
    // 싱글톤
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "9bd6ba57a5d54178b1c90ad315d60555"
        static let clientSecret = "3751cfbfc17f4cf2a3ba848081c047b8"
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let redirectUrl = "https://github.com"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {
        
    }
    
    // authorization, 로그인 url
    public var signInURL : URL? {
        let endPoint = "https://accounts.spotify.com/authorize"
        var components = URLComponents(string: endPoint)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: "\(Constants.clientId)"),
            URLQueryItem(name: "scope", value: "\(Constants.scopes)"),
            URLQueryItem(name: "redirect_uri", value: "\(Constants.redirectUrl)"),
            URLQueryItem(name: "show_dialog", value: "TRUE")
        ]

        let string = components?.url
        return string
    }
    
    // 엑세스 토큰이 존재하는 지 체크
    var isSingedIn:Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    // 유효시간이 5분 남았다면 갱신하기 위해 true값 리턴
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinute : TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinute) >= expirationDate
    }
    
    // 받은 code로 access token 발급
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        // 토큰 발급하는 url
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        
        // request url의 prameters
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUrl)
        ]
        
        // post방식으로 request url 보낼때 header랑 body 작성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        
        // request후 access, refresh, date 유저 디폴트로 저장
        let task = URLSession.shared.dataTask(with: request){[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
        
    }
    
    // 토큰 유효시간 지났을 때 갱신
    public func refreshForToken(completion: @escaping (Bool) -> Void){
        // 토큰을 갱신할 때가 되었으면
        guard shouldRefreshToken else {
            completion(false)
            return
        }
        // refresh token
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // token url
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        
        // 갱신이라는 의미의 파라미터로 작성
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        // request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("successfully refresh token")
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
        
        
    }
    
    // 받은 토큰들과 유효시간를 캐싱한다.
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
}
