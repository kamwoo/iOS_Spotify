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
    
    // manager로 전달받은 access token으로 request 작성, GET 방식
    private func createRequest(with url: URL?, type:HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken{ token in
            guard let apiUrl = url else {return}
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
// MARK: -Profile
    
    // 현재 유저 정보 api
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        // 생선된 request문으로 쿼리
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET){ baseRequest in
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
    
// MARK: -Browse
    
    // 최신곡 api
    public func getNewRelease(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=40"), type: .GET){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                
                // 리턴받은 데이터 유저 프로필 모델로 디코드
                do{
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // 추전 재생목록 api
    public func getFeaturePlaylist(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=40"), type: .GET){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                
                // 리턴받은 데이터 유저 프로필 모델로 디코드
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // 쿼리가능한 노래 장르 api
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    // 추천 노래 api
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>)) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                
                // 리턴받은 데이터 유저 프로필 모델로 디코드
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }

//MARK: -Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetails, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _ ,error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetails.self, from: data)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(APIError.filedToGetData))
                }
            }
            task.resume()
        }
    }
//MARK: -Playlists

    public func getPlaylistDetails(for playlist: playlist, completion: @escaping (Result<PlaylistDetails, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _ ,error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.filedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistDetails.self, from: data)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(APIError.filedToGetData))
                }
            }
            task.resume()
        }
    }
    
// MARK: -All Category
    public func getCategories(completion: @escaping (Result<[category], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?country=KR&limit=50"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.filedToGetData))
                }
                
                do{
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                }catch{
                    completion(.failure(APIError.filedToGetData))
                }
            }
            task.resume()
        }
    }
    
// MARK: -Category
    public func getCategoryPlaylists(for category: category, completion: @escaping (Result<[playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.filedToGetData))
                }
                do{
                    let json = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(json.playlists.items))
                }catch{
                    completion(.failure(APIError.filedToGetData))
                }
            }
            task.resume()
        }
    }
    
// MARK: -Search
    public func search(with query: String, completion: @escaping (Result<[SearchResultModel], Error>) -> Void ){
        createRequest(
            with: URL(string:
                        Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.filedToGetData))
                }
                do{
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    var searchResults: [SearchResultModel] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResultModel.track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResultModel.album(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ SearchResultModel.playlist(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ SearchResultModel.artist(model: $0)}))
                    completion(.success(searchResults))
                    
                }catch{
                    print("error")
                    completion(.failure(APIError.filedToGetData))
                }
            }
            task.resume()
        }
    }
    
}
