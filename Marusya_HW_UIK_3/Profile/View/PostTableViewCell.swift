import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didTapPostImage(in cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    static let id = "PostTableViewCell"
    
    private var likeHandler: (() -> Int)?
    weak var delegate: PostTableViewCellDelegate?
    
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
        postImageView.isUserInteractionEnabled = true
        postImageView.clipsToBounds = true
        postImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped)
        ))
        return postImageView
    }()
    
    private var descriptionLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        text.textColor = .systemGray
        text.numberOfLines = 3
        return text
    }()
    
    private lazy var feedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countLikes,
                                                       countViews])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var countViews: UILabel = {
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
        likesGestureRecognizers(labelView: labelCount)
        return labelCount
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubviews([author, postImageView, descriptionLabel, feedStackView])
        setupConstraints()
    }
    
    func setup(post: Post, likeHandler: @escaping () -> Int) {
        author.text = post.author
        if let imageName = post.imageName, let image = UIImage(named: imageName) {
            postImageView.image = image
        } else {
            postImageView.tintColor = .gray
            postImageView.image = UIImage(systemName: "photo")
        }
        descriptionLabel.text = post.description
        self.likeHandler = likeHandler
        countViews.text = "Views: \(post.views)"
        countLikes.text = "Likes: \(post.likes)"
    }
    
    private func likesGestureRecognizers(labelView: UILabel) {
        labelView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(incrementLikeGesture))
        labelView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func incrementLikeGesture() {
        countLikes.text = "Likes: \(likeHandler?() ?? 0)"
    }
        
    @objc private func imageTapped() {
        delegate?.didTapPostImage(in: self)
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
