import UIKit

class ProfileViewController: UIViewController {
    
    private let dataStore = DataStore()
    
    private var avatarImageTopConstraint: NSLayoutConstraint!
    private var avatarImageLeadingConstraint: NSLayoutConstraint!
    private var avatarImageTrailingConstraint: NSLayoutConstraint!
    private var avatarImageCenterXConstraint: NSLayoutConstraint!
    private var avatarImageCenterYConstraint: NSLayoutConstraint!
    private var avatarImageHeightConstraint: NSLayoutConstraint!
    private var avatarImageWidthConstraint: NSLayoutConstraint!
    
    private lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        view.backgroundColor = .F_2_F_2_F_7
        view.layer.shadowColor = UIColor.systemGray4.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        view.addSubviews([avatarImageView])
        avatarImageTopConstraint = avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        avatarImageLeadingConstraint = avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        avatarImageWidthConstraint = avatarImageView.widthAnchor.constraint(equalToConstant: 120)
        avatarImageHeightConstraint = avatarImageView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([avatarImageTopConstraint,
                                     avatarImageLeadingConstraint,
                                     avatarImageWidthConstraint,
                                     avatarImageHeightConstraint])
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        let imageName = "hipsterCat"
        if let image = UIImage(named: imageName) {
            avatarImageView.image = image
        } else {
            avatarImageView.tintColor = .gray
            avatarImageView.image = UIImage(systemName: "photo")
        }
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        setupGestureRecognizers(imageView: avatarImageView)
        return avatarImageView
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
    
    private var backgroundImageView: UIView = {
        let backgroundImageView = UIView()
        backgroundImageView.backgroundColor = .black
        backgroundImageView.layer.opacity = 0
        return backgroundImageView
    }()
    
    private lazy var bigAvatarImageCloseButton: UIButton = {
        let bigAvatarImageCloseButton = UIButton(type: .system)
        bigAvatarImageCloseButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        bigAvatarImageCloseButton.tintColor = .systemGray2
        bigAvatarImageCloseButton.layer.opacity = 0
        bigAvatarImageCloseButton.addTarget(self, action: #selector(handleCloseBigAvatarImage), for: .touchUpInside)
        bigAvatarImageCloseButton.isHidden = true
        return bigAvatarImageCloseButton
    }()
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .backgroundProfileGray
        view.addSubviews([tableView, backgroundImageView])
        backgroundImageView.addSubviews([bigAvatarImageCloseButton])
        setupConstraints()
    }
    
    // MARK: - Настройка жестов
    private func setupGestureRecognizers(imageView: UIImageView) {
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Обработка жеста Tap (нажатие)
    @objc func handleGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if let tappedView = gestureRecognizer.view {
            avatarImageView.removeFromSuperview()
            view.addSubviews([tappedView])
            self.view.bringSubviewToFront(tappedView)
            avatarImageTopConstraint.isActive = true
            avatarImageLeadingConstraint.isActive = true
            self.view.layoutIfNeeded()
            avatarImageTopConstraint.isActive = false
            avatarImageLeadingConstraint.isActive = false
            avatarImageWidthConstraint.isActive = false
            avatarImageHeightConstraint.isActive = false
            avatarImageCenterXConstraint = tappedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            avatarImageCenterYConstraint = tappedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            avatarImageWidthConstraint = tappedView.widthAnchor.constraint(equalTo: view.widthAnchor)
            avatarImageHeightConstraint = tappedView.heightAnchor.constraint(equalTo: view.widthAnchor)
            avatarImageCenterXConstraint.isActive = true
            avatarImageCenterYConstraint.isActive = true
            avatarImageWidthConstraint.isActive = true
            avatarImageHeightConstraint.isActive = true
            self.backgroundImageView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                tappedView.layer.cornerRadius = 0
                self.backgroundImageView.layer.opacity = 0.8
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.bigAvatarImageCloseButton.layer.opacity = 1
                    self.bigAvatarImageCloseButton.isHidden = false
                }
            }
        }
    }
    
    @objc func handleCloseBigAvatarImage() {
        UIView.animate(withDuration: 0.3) {
            self.bigAvatarImageCloseButton.layer.opacity = 0
        } completion: { _ in
            self.bigAvatarImageCloseButton.isHidden = true

            self.avatarImageCenterXConstraint.isActive = true
            self.avatarImageCenterYConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            self.avatarImageCenterXConstraint.isActive = false
            self.avatarImageCenterYConstraint.isActive = false
            self.avatarImageWidthConstraint.isActive = false
            self.avatarImageHeightConstraint.isActive = false
            
            self.avatarImageWidthConstraint = self.avatarImageView.widthAnchor.constraint(equalToConstant: 120)
            self.avatarImageHeightConstraint = self.avatarImageView.heightAnchor.constraint(equalToConstant: 120)
            
            self.avatarImageTopConstraint.isActive = true
            self.avatarImageLeadingConstraint.isActive = true
            self.avatarImageWidthConstraint.isActive = true
            self.avatarImageHeightConstraint.isActive = true
            UIView.animate(withDuration: 0.5) {
                self.view.bringSubviewToFront(self.avatarImageView)
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.avatarImageView.layer.cornerRadius = 60
                self.backgroundImageView.layer.opacity = 0
            } completion: {_ in
                self.backgroundImageView.isHidden = true
                self.avatarImageView.removeFromSuperview()
                self.profileHeaderView.addSubviews([self.avatarImageView])
                self.avatarImageTopConstraint.isActive = true
                self.avatarImageLeadingConstraint.isActive = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bigAvatarImageCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            bigAvatarImageCloseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
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
