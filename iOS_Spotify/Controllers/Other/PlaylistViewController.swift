//
//  PlaylistViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: playlist
    
    // 플레이 리스트 뷰 layout 설정, 앨범 뷰와 동일
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_, _ -> NSCollectionLayoutSection? in
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
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1)),
                                                            
                    elementKind: UICollectionView.elementKindSectionHeader,
                                                            
                    alignment: .top)
            ]
            return section
        })
    )
    
    // 각 곡의 뷰 데이터 모델 리스트
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    private var tracks = [AudioTrack]()
    
    // 홈 뷰에서 선택된 플레이 리스트로 초기화
    init(playlist: playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        // 상단의 플레이리스트 이미지, 곡 정보, 전체 재생 버튼들어 있는 뷰 등록
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        // 하단의 플레이 리스트 뷰 등록
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 선택된 플레이리스트의 세부정보 request
        APICaller.shared.getPlaylistDetails(for: playlist){[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    // 플레이 리스트 곡들
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    // 플레이 리스트 셀의 뷰 모델로 저장, 앨버의 리스트 셀에서 이미지만 추가
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name,
                                                      artistName: $0.track.artists.first?.name ?? "-",
                                                      artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    // 플레이 리스트 뷰 업데이트
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        // 우측 상단에 공유 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    // 공유 버튼 액션
    @objc func didTapShare(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        // 공유 뷰 띄움
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }


}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    // 해당하는 플레이 리스트 곡 수에 맞게 셀 생성
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    // 플레이 리스트 각 셀 뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTrackCollectionViewCell else { return UICollectionViewCell()}
        
        // 각 곡의 데이터 뷰모델로 설정
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    // 상단의 뷰 설정, PlaylistHeaderCollectionReusableView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath) as? PlaylistHeaderCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        // 상단 헤더뷰 각 곡의 데이터 모델 저장
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name,
                                                      ownerName: playlist.owner.display_name,
                                                      description: playlist.description,
                                                      artworkURL: URL(string: playlist.images.first?.url ?? ""))
        // 각 곡의 데이터 모델로 뷰 설정
        header.configure(viewModel: headerViewModel)
        header.delegate = self
        return header
    }
    
    // 각 곡이 선택되었을 때 재생 화면 띄움
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // playsong
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
}

// 상단 헤더 뷰에서 전체 재생 버튼이 클릭되었을 때 delegate
extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        // 플레이리스트 재생
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }

}
