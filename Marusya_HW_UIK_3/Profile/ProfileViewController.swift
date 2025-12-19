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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataStore.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as! PostTableViewCell
        cell.setup(post: dataStore.models[indexPath.row])
           
        return cell
    }
}
