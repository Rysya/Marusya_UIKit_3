import UIKit

class ProfilePhotosSectionHederView: UIView {
    
    private var isKeyboardVisible = false
    
    private var openCollectionPhotoHandler: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Photos"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private var buttonPhotos: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(goToPhotosButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func goToPhotosButtonTapped() {
       openCollectionPhotoHandler?()
    }
    
    func setup(handler: @escaping () -> Void) {
        openCollectionPhotoHandler = handler
    }
    
    private func setupView() {
        addSubviews([titleLabel, buttonPhotos])
        setupConstraints()
    }
    
    private func setupConstraints() {
       
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            buttonPhotos.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonPhotos.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonPhotos.widthAnchor.constraint(equalToConstant: 30),
            buttonPhotos.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
