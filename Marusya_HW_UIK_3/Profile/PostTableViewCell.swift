import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let id = "PostTableViewCell"
    
    private var author: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.contentMode = .scaleAspectFit
        postImageView.backgroundColor = .black
        return postImageView
    }()
    
    private var descriptionLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        text.textColor = .systemGray
        text.numberOfLines = 0
        return text
    }()
    
    private let feedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var countViews: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        text.textColor = .black
        text.numberOfLines = 0
        text.textAlignment = .right
        return text
    }()
    
    private var countLikes: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        text.textColor = .black
        text.numberOfLines = 0
        text.textAlignment = .left
        return text
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        feedStackView.addArrangedSubview(countLikes)
        feedStackView.addArrangedSubview(countViews)
        addSubviews([author, postImageView, descriptionLabel, feedStackView])
        setupConstraints()
    }
    
    func setup(post: Post) {
        author.text = post.author
        if let imageName = post.imageName, let image = UIImage(named: imageName) {
            postImageView.image = image
            postImageView.heightAnchor.constraint(equalToConstant: bounds.width).isActive = true
        } else {
            postImageView.tintColor = .gray
            postImageView.image = UIImage(systemName: "photo")
            postImageView.heightAnchor.constraint(equalToConstant: bounds.width).isActive = true
        }
        descriptionLabel.text = post.description
        countViews.text = "Views: \(post.views)"
        countLikes.text = "Likes: \(post.likes)"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            author.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            author.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            postImageView.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 12),
            postImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            postImageView.widthAnchor.constraint(equalTo: widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: feedStackView.topAnchor, constant: -16),
            
            feedStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            feedStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            feedStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            feedStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
