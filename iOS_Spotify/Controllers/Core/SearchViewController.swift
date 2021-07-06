//
//  SearchViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    // search bar
    let searchController : UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "검색할 노래, 아티스트, 앨범을 입력해주세요"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    // 검색 뷰에 카테고리별로 정리된 콜렉션 뷰
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                        widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(150)),
                                                           subitem: item,
                                                           count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return NSCollectionLayoutSection(group: group)
        }))
    
    private var categories = [category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        // 네비게이션 아이템에 검색컨트롤러
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier:CategoryCollectionViewCell.identifier )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        // 장르 카테고리 request
        APICaller.shared.getCategories{[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let categories):
                    self?.categories = categories 
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 카테고리 갯수만큼 셀 생성
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    // 각 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.identifier,
                for: indexPath) as? CategoryCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        
        // 각 셀을 구성할 데이터 셀뷰에 넘김
        cell.configure(with: CategoryCollectionViewCellViewModel(
                        title: category.name,
                        artWorkURL: URL(string: category.icons.first?.url ?? "")
            )
        )
        return cell
    }
    
    // 카테고리의 각 셀이 선택 되었을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        // 해당하는 카테고리로 초기화시킨 뷰로 전환
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// 검색 결과 보여지는 뷰
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // 매 글자가 입력될 때마다 호출되는 함수
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // 검색 버튼이 클릭 되었을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 결과 보여줄 searchResultViewControlloer, 검색바에 입력된 문자
        guard let resultController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        // 검색 결과창에서 각 셀이 선택되었을 때 액션처리 delegate받음
        resultController.delegate = self
        
        // 입려된 글자로 request
        APICaller.shared.search(with: query){ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    // 리턴 받은 데이터 
                    resultController.update(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
           
        }
    }
    
    
}


extension SearchViewController: SearchResultViewControllerDelegate{
    // 검색 결과로 나온 셀을 클릭했을 때
    func didTapResult(_ result: SearchResultModel) {
        switch result {
        // 아티스트 섹션에서
        case .artist(let model):
            // spotify에 아티스트 URL을 인터넷 webview로 띄운다
            guard let url = URL(string:model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
            
        // 앨범 섹션에서
        case .album(let model):
            // 앨법 뷰로 전환
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        // 트랙 섹션
        case .track(let model):
            // 바로 노래 재생
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        
        // 플레이리스트 섹션
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
