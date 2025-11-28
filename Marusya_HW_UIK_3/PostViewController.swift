import UIKit

class PostViewController: UIViewController {
    
    private let post: Post
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = post.title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = post.text != "" ? post.text : "Здесь будет содержимое поста"
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        if let imageName = post.imageName, let image = UIImage(named: imageName) {
            postImageView.image = image
            postImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        } else {
            postImageView.tintColor = .gray
            postImageView.image = UIImage(systemName: "photo")
            postImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        return postImageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView(arrangedSubviews: [postImageView, contentTextView])
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        return contentStackView
    }()
   
    private lazy var contentTextView: UIStackView = {
        let contentTextView = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
        contentTextView.axis = .vertical
        contentTextView.spacing = 16
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        return contentTextView
    }()
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(postImageView)
        view.addSubview(contentTextView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            postImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        let infoButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func infoButtonTapped() {
        let infoViewController = InfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
}
