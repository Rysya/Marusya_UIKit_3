import UIKit

class FeedViewController: UIViewController {
    
    private let samplePost = Post(
            title: "Пост от leon",
            text: "Это содержимое первого поста от leon в этом приложении. Здесь может быть длинный текст с интересной информацией, о том как leon счастливо живет или что-то в этом роде.",
            imageName: "leon"
        )
    
    private let feedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var showPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать пост", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemTeal
        button.tintColor = .darkGray
        button.layer.cornerRadius = 24
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()
    
    private lazy var showPostSecondButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать пост", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Лента пользователя"
        self.view.backgroundColor = .systemBlue
        
        setupSubviews()
        setupConstraint()
    }
    
    private func setupSubviews() {
        view.addSubviews([feedStackView])
        feedStackView.addArrangedSubview(showPostButton)
        feedStackView.addArrangedSubview(showPostSecondButton)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            feedStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            feedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showPostButtonTapped() {
        let postViewController = PostViewController(post: samplePost)
            
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
