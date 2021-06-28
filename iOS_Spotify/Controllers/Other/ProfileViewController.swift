//
//  ProfileViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    // 현재 유저의 이름, 아이디 들 정보 저장
    private var models = [String]()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchProfile()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // 리턴받은 현재 유저의 데이터 models 리스트에 저장
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with : model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failToGetProfile()
                }
            }
            
        }
    }
    
    private func updateUI(with model : UserProfile){
        tableView.isHidden = false
        createTableHeader(with: model.images.first?.url)
        models.append("이름 : \(model.display_name)")
        models.append("이메일 : \(model.email)")
        models.append("아이디 : \(model.id)")
        models.append("이용상품 : \(model.product)")
        tableView.reloadData()
    }
    
    // 프로필 이미지 테이블 헤더로 지정
    private func createTableHeader(with string: String? ){
        guard let urlString = string,
              let url = URL(string: urlString)
        else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
            
            let imageSize : CGFloat = headerView.height/2
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            headerView.addSubview(imageView)
            imageView.center = headerView.center
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(systemName: "person.fill")
            
            tableView.tableHeaderView = headerView
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize : CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.cornerRadius = imageSize/2
        
        tableView.tableHeaderView = headerView
    }
    
    // 프로필 정보를 리턴 받지 못했을 경우
    private func failToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "프로필 정보를 얻어오지 못했습니다."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }

}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
