//
//  ViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommendedTracks
}

class HomeViewController: UIViewController {
    
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        view.addSubview(spinner)
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
    }
    
    // 콜렉션 뷰 설정
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 2:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        default:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
            let Group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: Group)
            return section
        }
    }
    
    // api호출
    private func fetchData(){
//        APICaller.shared.getNewRelease{ result in
//            switch result{
//            case .success(let model):
////                print(model)
//                break
//            case .failure(let error):
////                print(error)
//                break
//            }
//        }
//
//        APICaller.shared.getFeaturePlaylist{ result in
//            switch result{
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
//        APICaller.shared.getRecommendedGenres{ result in
//            switch result{
//            case .success(let model):
//                let genrs = model.genres
//                var seeds = Set<String>()
//                while seeds.count < 5 {
//                    if let random = genrs.randomElement(){
//                        seeds.insert(random)
//                    }
//                }
//                APICaller.shared.getRecommendations(genres: seeds){ result in
//                    switch result {
//                    case .success(let model):
//                        print(model)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    // 세팅 뷰로 전환
    @objc func didTapSettings(){
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

// 홈 뷰 테이블
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemBlue
        }
        else if indexPath.section == 1{
            cell.backgroundColor = .systemRed
        }
        else if indexPath.section == 2{
            cell.backgroundColor = .systemPink
        }
        return cell
    }
    
    
}
