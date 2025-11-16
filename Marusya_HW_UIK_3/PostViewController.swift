import UIKit

class PostViewController: UIViewController {
    
    private let post: Post
    
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
        SetupUI()
        
    }
    
    private func SetupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = post.title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        
        let contentLabel = UILabel()
        contentLabel.text = post.text != "" ? post.text : "Здесь будет содержимое поста"
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.numberOfLines = 0
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .leading
        
        let image: UIImageView
        
        if let postImage = post.img {
            let imageView = UIImageView(image: postImage)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 200)
            image = imageView
        } else {
            let imageView = UIImageView(image: UIImage(systemName: "photo"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray
            imageView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 200)
            image = imageView
        }
        contentStackView.insertArrangedSubview(image, at: 0)
        contentStackView.insertArrangedSubview(titleLabel, at: 1)
        contentStackView.insertArrangedSubview(contentLabel, at: 2)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStackView)
        view.addSubview(scrollView)
                
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            image.heightAnchor.constraint(equalTo: image.widthAnchor,
                                          multiplier: image.intrinsicContentSize.height / image.intrinsicContentSize.width)
        ])
    }
    
    private func setupNavigationBar() {
            let infoButton = UIBarButtonItem(
                image: UIImage(systemName: "info.circle"),
                style: .plain,
                target: self,
                action: #selector(infoButtonTapped)
            )
            navigationItem.rightBarButtonItem = infoButton
        }
    
    @objc private func infoButtonTapped() {
           let infoViewController = InfoViewController()
           let navigationController = UINavigationController(rootViewController: infoViewController)
           
           present(navigationController, animated: true, completion: nil)
       }
}
