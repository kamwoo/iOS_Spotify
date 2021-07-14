//
//  AlbumViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    
    private var tracks = [AudioTrack]()
    
    // 앨범뷰 layout 설정
    private let collectionView = UICollectionView(
        frame: .zero,
        // 각 섹션 layout 설정
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_, _ -> NSCollectionLayoutSection? in
            // 플레이 리스트의 각 아이템
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
            
            // 앨범 상단 이미지, 곡 정보, 전체 재생이 들어가는 아이템 layout 설정
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
    
    private var album: Album
    
    // 홈 뷰에서 선택된 album model로 초기화
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        // 상단의 앨범 이미지, 곡 이름, 곡 설명, 아티스트, 전체 곡 재생 버튼이 있는 헤더 뷰
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        // 하단 플레이 될 곡 리스트
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapActions))
        
    }
    
    @objc func didTapActions() {
        let actionSheet = UIAlertController(title: album.name,
                                            message: "앨벙을 저장하시겠습니까?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "앨범 저장", style: .default, handler: { [weak self] _ in
            guard let self = self else {return}
            APICaller.shared.saveAlbum(album: self.album){ success in
                if success{
                    NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
                }
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func fetchData(){
        // 홈 뷰에서 선택된 해당하는 곡 모델로 세부정보 request
        APICaller.shared.getAlbumDetails(for: album){ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    // 리턴 받은 앨범의 곡들을 셀 뷰 모델로 저장
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(name: $0.name,
                                                      artistName: $0.artists.first?.name ?? "-")
                    })
                    // 앨범 뷰 업데이트
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

// 하단의 플레이 리스트
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 앨범의 곡 수만큼 섹션의 셀 갯수로 지정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    // 각 셀 뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath) as? AlbumTrackCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    
    // 상단 이미지, 곡정보, 전체재생 들어가는 뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath) as? PlaylistHeaderCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        // 헤더에 들어갈 데이터 뷰 데이터 모델
        let headerViewModel = PlaylistHeaderViewModel(name: album.name,
                                                      ownerName: album.artists.first?.name,
                                                      description: "업로드 날짜 : \(String.formatterDate(string: album.release_date))",
                                                      artworkURL: URL(string: album.images.first?.url ?? ""))
        // 헤더 뷰에 데이터 넣어줌
        header.configure(viewModel: headerViewModel)
        // 헤더 뷰의 전체 재생 버튼이 눌러졌을 때 delegate
        header.delegate = self
        return header
    }
    
    // 플레이 리스트 셀이 클릭되었을 때 재생 화면 띄움
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // playsong
        var track = tracks[indexPath.row]
    
        // 리턴 받고 설정한 tracks = tracks.items에는 album이 nil이기 때문에 초기화할때 저장된 album을 따로 넣어 주었다. spotify와 디자인 방식이 다르기 때문인것 같다.
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
}

// 헤더 뷰에서 전체 재생 버튼이 클리 되었을 때
extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        // 플레이리스트 재생
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }

}
