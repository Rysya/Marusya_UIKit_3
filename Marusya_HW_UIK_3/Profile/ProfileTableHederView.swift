import UIKit

class ProfileHeaderView: UIView {
    
    private var isKeyboardVisible = false
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Hipster Cat"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Waiting for something..."
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        statusLabel.numberOfLines = 0
        return statusLabel
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        let imageName = "hipsterCat"
        if let image = UIImage(named: imageName) {
            avatarImageView.image = image
        } else {
            avatarImageView.tintColor = .gray
            avatarImageView.image = UIImage(systemName: "photo")
        }
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private var isStatusVisibleOfTextFieldStatus = false
    
    private lazy var textFieldStatus: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textFieldStatus = UITextField()
        textFieldStatus.isUserInteractionEnabled = false
        textFieldStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textFieldStatus.leftView = leftPaddingView
        textFieldStatus.leftViewMode = .always
        textFieldStatus.textColor = .black
        textFieldStatus.backgroundColor = .white
        textFieldStatus.layer.cornerRadius = 12
        textFieldStatus.layer.borderWidth = 1
        textFieldStatus.layer.borderColor = UIColor.black.cgColor
        textFieldStatus.placeholder = "Напишите статус"
        textFieldStatus.isHidden = true
        textFieldStatus.isUserInteractionEnabled = true
        return textFieldStatus
    }()
    
    private var showStatusButtonTopConstraint: NSLayoutConstraint!
    
    private lazy var showStatusButton: UIButton = {
        let showStatusButton = UIButton()
        showStatusButton.setTitle("Ввести новый статус", for: .normal)
        showStatusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        showStatusButton.titleLabel?.textColor = .white
        showStatusButton.backgroundColor = .systemBlue
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.setTitleColor(.yellow, for: .highlighted)
        showStatusButton.layer.cornerRadius = 24
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        showStatusButton.layer.shadowRadius = 4
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.addTarget(self, action: #selector(setNewStatus), for: .touchUpInside)
        showStatusButton.addTarget(self, action: #selector(showStatusButtonTouchDown), for: .touchDown)
        showStatusButton.addTarget(self, action: #selector(showStatusButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return showStatusButton
    }()
    
    @objc private func setNewStatus() {
        var isFirstClick: Bool = true
        if isStatusVisibleOfTextFieldStatus {
            isStatusVisibleOfTextFieldStatus = false
            statusLabel.text = textFieldStatus.text
            showStatusButton.setTitle("Ввести новый статус", for: .normal)
        } else {
            if textFieldStatus.text?.isEmpty == true, isFirstClick {
                textFieldStatus.text = statusLabel.text
                isFirstClick = false
            }
            isStatusVisibleOfTextFieldStatus = true
            showStatusButton.setTitle("Установить новый статус", for: .normal)
        }
        UIView.animate(withDuration: 0.2) {
            if self.isStatusVisibleOfTextFieldStatus {
                self.showStatusButtonTopConstraint.isActive = false
                self.showStatusButtonTopConstraint.constant = 36
                self.showStatusButtonTopConstraint.isActive = true
                self.setNeedsLayout()
                self.layoutIfNeeded()
            } else {
                self.textFieldStatus.isHidden = true
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                if self.isStatusVisibleOfTextFieldStatus {
                    self.textFieldStatus.isHidden = false
                } else {
                    self.showStatusButtonTopConstraint.isActive = false
                    self.showStatusButtonTopConstraint.constant = 16
                    self.showStatusButtonTopConstraint.isActive = true
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func showStatusButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.showStatusButton.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
            self.showStatusButton.layer.shadowOpacity = 0.3
            self.showStatusButton.backgroundColor = self.showStatusButton.backgroundColor?.withAlphaComponent(0.8)
        }
    }
    
    @objc private func showStatusButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.showStatusButton.transform = CGAffineTransform.identity
            self.showStatusButton.layer.shadowOpacity = 0.7
            self.showStatusButton.backgroundColor = .systemBlue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        if let status = statusLabel.text {
            NSLog("Статус: \(status)")
            print(safeAreaLayoutGuide.layoutFrame.width - 32)
        } else {
            NSLog("Статуса нет, использую текст по умолчанию")
        }
    }
    
    private func setupView() {
        addSubviews([titleLabel, statusLabel, avatarImageView, textFieldStatus, showStatusButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        showStatusButtonTopConstraint = showStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 46),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            textFieldStatus.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            textFieldStatus.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            textFieldStatus.heightAnchor.constraint(equalToConstant: 30),
            textFieldStatus.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            showStatusButtonTopConstraint,
            showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            showStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            showStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
