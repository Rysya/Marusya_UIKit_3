import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    static let id = "PhotosTableViewCell"
    
    private var photoArh = PhotosArh()
    
    private lazy var feedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createImageView(with: photoArh.photos[0]),
            createImageView(with: photoArh.photos[1]),
            createImageView(with: photoArh.photos[2]),
            createImageView(with: photoArh.photos[3])
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private func createImageView(with imageName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let aspectRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        aspectRatio.priority = .defaultHigh
        aspectRatio.isActive = true
        return imageView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubviews([feedStackView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            feedStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            feedStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            feedStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            feedStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
