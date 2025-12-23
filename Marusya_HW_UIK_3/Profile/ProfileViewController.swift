import UIKit

class ProfileViewController: UIViewController {
    
    private var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        view.backgroundColor = .F_2_F_2_F_7
        view.layer.shadowColor = UIColor.systemGray4.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0.2
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.tableHeaderView = profileHeaderView
        return tableView
    }()
    
    private lazy var newButton: UIButton = {
        let newButton = UIButton()
        newButton.setTitle("Новая нижняя кнопка", for: .normal)
        newButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        newButton.titleLabel?.textColor = .white
        newButton.backgroundColor = .systemBlue
        newButton.setTitleColor(.white, for: .normal)
        newButton.setTitleColor(.yellow, for: .highlighted)
        return newButton
    }()
    
    private var profileView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()
        profileView.backgroundColor = .darkGray
        return profileView
    }()
    
    let dataStore = DataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .backgroundProfileGray
        view.addSubviews([tableView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
//    private enum TableSection: Int, CaseIterable {
//        case photos
//        case posts
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return dataStore.models.count
            default:
                return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return TableSection.allCases.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.id, for: indexPath) as! PhotosTableViewCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as! PostTableViewCell
                cell.setup(post: dataStore.models[indexPath.row])
                return cell
            default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0: let profilePhotosSectionHederView = ProfilePhotosSectionHederView()
                profilePhotosSectionHederView.setup { [weak self] in
                    let photoVC = PhotosViewController()
                        
                    self?.navigationController?.pushViewController(photoVC, animated: true)
                }
                return profilePhotosSectionHederView
            default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 36
            default: return 0
        }
    }

}
