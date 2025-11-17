import UIKit

class PostViewController: UIViewController {
    
    private let post: Post
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        } else {
            postImageView.tintColor = .gray
            postImageView.image = UIImage(systemName: "photo")
        }
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true   // важно, иначе часть картинки может «вылезать»
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            postImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 0),
            postImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
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
