//
//  SearchResultViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResultModel]
}

// 테이블에 각 셀이 선택되었을 때 액션처리를 SearchViewController로 delegate
protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResultModel)
}

// 검색결과로 보여질 뷰
class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    // 셀뷰 등록
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // search bar에 입력된 단어로 리턴 받은 데이터
    func update(with results: [SearchResultModel]){
        // 리턴 받은 데이터에서 .artist의 value 저장
        let artists = results.filter({
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        })
        
        // 리턴 받은 데이터에서 .albums의 value 저장
        let albums = results.filter({
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        })
        
        // 리턴 받은 데이터에서 .playlists의 value 저장
        let playlists = results.filter({
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        })
        
        // 리턴 받은 데이터에서 .tracks의 value 저장
        let tracks = results.filter({
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        })
        
        // 저장된 각 데이터들을 sections에 리스트로 저장
        self.sections = [
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Tracks", results: tracks)
        ]
        
        // 테이블 뷰 업데이트
        tableView.reloadData()
        // 리턴 받은 값이 비어있지 않으면 테이블뷰 보이기
        tableView.isHidden = results.isEmpty
    }

}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource{
    // 리턴받은 데이터 주제개수로 테이블 뷰 섹션 갯수로 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 각 주제의 객체 수로 셀 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    // 각 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        // 아티스트 섹션이라면
        case .artist(let artist):
            // SearchResultDefaultTableViewCell으로 셀 지정
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier,
                                                           for: indexPath) as? SearchResultDefaultTableViewCell
            else {
                return UITableViewCell()
            }
            // 각 셀에 인덱스대로 아티스트 데이터 설정
            cell.configure(with: SearchResultDefaultTableViewCellViewModel(title: artist.name,
                                                                           imageURL: URL(string: artist.images?.first?.url ?? "")))
            return cell
            
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                           for: indexPath) as? SearchResultSubtitleTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name,
                                                                            subtitle: album.artists.first?.name ?? "",
                                                                            imageURL: URL(string: album.images.first?.url ?? "")))
            return cell
            
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                           for: indexPath) as? SearchResultSubtitleTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: track.name,
                                                                            subtitle: track.artists.first?.name ?? "-",
                                                                            imageURL: URL(string: track.album?.images.first?.url ?? "")))
            return cell
            
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                           for: indexPath) as? SearchResultSubtitleTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name,
                                                                            subtitle: playlist.owner.display_name,
                                                                            imageURL: URL(string: playlist.images.first?.url ?? "")))
            return cell
        }
    
    }
    
    // 각 셀이 클리되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        // 해당하는 셀의 데이터로 액션처리를 searchViewContoller로 delegate
        delegate?.didTapResult(result)
    }
    
    // 각 섹션의 헤더 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
