//
//  LibraryAlbumsViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/08.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    public var selectionHandler: ((playlist) -> Void)?
    
    private let noAlbumView = ActionLabelView()
    
    private var albums = [Album]()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(noAlbumView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpNoAlbumlistView()
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification,
                                                          object: nil,
                                                          queue: nil,
                                                          using: {[weak self] _ in
                                                            self?.fetchData()
                                                          })
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
//        noAlbumView.center = view.center
//        tableView.frame = view.bounds
    }
    
    private func fetchData(){
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums{[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func updateUI() {
        if albums.isEmpty {
            noAlbumView.isHidden = false
            tableView.isHidden = true
        }
        else{
            tableView.reloadData()
            noAlbumView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setUpNoAlbumlistView() {
        noAlbumView.delegate = self
        noAlbumView.configure(with: ActionLabelViewModel(text: "저장된 앨범이 없습니다.", actionTitle: "만들기"))
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }


}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func ActionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }

}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                       for: indexPath) as? SearchResultSubtitleTableViewCell
        else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(title: album.name,
                                                             subtitle: album.artists.first?.name ?? "",
                                                            imageURL: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
