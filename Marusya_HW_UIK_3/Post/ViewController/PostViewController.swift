import UIKit

class PostViewController: UIViewController {
    
    private let post: Post
    private var likeHandler: (() -> Int)?

    private lazy var authorLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = post.author
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.numberOfLines = 0
        return titleLabel
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
        contentLabel.text = post.description != "" ? post.description : "Здесь будет содержимое поста"
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        if let imageName = post.imageName, let image = UIImage(named: imageName) {
            postImageView.image = image
            postImageView.heightAnchor.constraint(
                equalTo: postImageView.widthAnchor,
                multiplier: image.size.height / image.size.width
            ).isActive = true
        } else {
            postImageView.tintColor = .gray
            postImageView.image = UIImage(systemName: "photo")
            postImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
        postImageView.contentMode = .scaleAspectFit
        postImageView.clipsToBounds = true
        return postImageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView(arrangedSubviews: [postImageView,
                                                              contentHorizontalView])
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        return contentStackView
    }()
    
    private lazy var contentVerticalView: UIStackView = {
       let viewStack = UIStackView(arrangedSubviews: [contentTextView,
                                                 feedStackView])
        viewStack.axis = .vertical
        viewStack.spacing = 16
        return viewStack
    }()
    
    private lazy var contentHorizontalView: UIStackView = {
        let viewStack = UIStackView(arrangedSubviews: [contentVerticalView])
        viewStack.alignment = .fill
        viewStack.distribution = .fill
        viewStack.isLayoutMarginsRelativeArrangement = true
        viewStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        viewStack.axis = .horizontal
        return viewStack
    }()
    
    private lazy var contentTextView: UIStackView = {
        let contentTextView = UIStackView(arrangedSubviews: [authorLabel,
                                                             titleLabel,
                                                             contentLabel])
        contentTextView.axis = .vertical
        contentTextView.spacing = 16
        return contentTextView
    }()
    
    private lazy var feedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countLikes,
                                                       countViews])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()
    
    private let countViews: UILabel = {
        let labelCount = UILabel()
        labelCount.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelCount.textColor = .black
        labelCount.numberOfLines = 0
        labelCount.textAlignment = .right
        return labelCount
    }()
    
    private lazy var countLikes: UILabel = {
        let labelCount = UILabel()
        labelCount.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelCount.textColor = .black
        labelCount.numberOfLines = 0
        labelCount.textAlignment = .left
        labelCount.text = "Likes: \(post.likes)"
        labelCount.isUserInteractionEnabled = true
        labelCount.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(incrementLikeGesture)))
        return labelCount
    }()
    
    private let scrollView = UIScrollView()
    
    init(post: Post, likeHandler: @escaping () -> Int) {
        self.post = post
        self.likeHandler = likeHandler
        super.init(nibName: nil, bundle: nil)
        countViews.text = "Views: \(post.views + 1)"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupSubviews() {
        view.addSubviews([scrollView])
        scrollView.addSubviews([contentStackView])
    }
    
    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        let infoButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func incrementLikeGesture() {
        countLikes.text = "Likes: \(likeHandler?() ?? 0)"
    }
    
    @objc private func infoButtonTapped() {
        let infoViewController = InfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
