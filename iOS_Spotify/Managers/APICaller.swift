//
//  APICaller.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum APIError : Error {
    case filedToGetData
}

struct Constants {
    static let baseAPIURL = "https://api.spotify.com/v1"
}

final class APICaller{
    static let shared = APICaller()
    
    private init() {}
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        // 생선된 request문으로 쿼리
        creatRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                
                // 리턴받은 데이터 유저 프로필 모델로 디코드
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    print(result)
                }catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // manager로 전달받은 access token으로 request 작성, GET 방식
    private func creatRequest(with url: URL?, type:HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken{ token in
            guard let apiUrl = url else {return}
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
}
