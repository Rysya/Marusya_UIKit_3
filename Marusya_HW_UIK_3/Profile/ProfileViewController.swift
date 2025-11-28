import UIKit

class ProfileViewController: UIViewController {
    
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
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.backgroundColor = .darkGray
        return profileView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .backgroundProfileGray
        view.addSubviews([profileView, newButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 240),
            
            newButton.heightAnchor.constraint(equalToConstant: 50),
            newButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            newButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            newButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
    }
}
