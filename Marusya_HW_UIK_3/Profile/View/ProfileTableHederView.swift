import UIKit

class ProfileHeaderView: UIView {
    
    private var isKeyboardVisible = false
    private var isFirstClick = true
    private var isFirstLayout = true
    private let statusService = StatusService()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Hipster Cat"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Waiting for something..."
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        statusLabel.numberOfLines = 0
        return statusLabel
    }()
    
    private var isStatusVisibleOfTextFieldStatus = false
    
    private var textFieldStatus: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textFieldStatus = UITextField()
        textFieldStatus.isUserInteractionEnabled = true
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
        return textFieldStatus
    }()
    
    private var showStatusButtonTopConstraint: NSLayoutConstraint!
    
    private lazy var showStatusButton: UIButton = {
        let showStatusButton = UIButton()
        showStatusButton.setTitle("Ввести новый статус", for: .normal)
        showStatusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        showStatusButton.titleLabel?.textColor = .white
        showStatusButton.backgroundColor = .vk
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.setTitleColor(.yellow, for: .highlighted)
        showStatusButton.layer.cornerRadius = 24
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        showStatusButton.layer.shadowRadius = 4
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.addTarget(self,
                                   action: #selector(setNewStatus),
                                   for: .touchUpInside)
        showStatusButton.addTarget(self,
                                   action: #selector(showStatusButtonTouchDown),
                                   for: .touchDown)
        showStatusButton.addTarget(self,
                                   action: #selector(showStatusButtonTouchUp),
                                   for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return showStatusButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
            setupView()
            isFirstLayout = false
        }
    }
    
    @objc private func setNewStatus() {
        let statusHandler: () -> Void = { [self] in
            showStatusButton.setTitle(isStatusVisibleOfTextFieldStatus
                                      ? "Ввести новый статус"
                                      : "Установить новый статус",
                                      for: .normal)
            isStatusVisibleOfTextFieldStatus.toggle()
            if !isStatusVisibleOfTextFieldStatus {
                textFieldStatus.placeholder = "Напишите статус"
            }
        }
        if !isStatusVisibleOfTextFieldStatus,
           textFieldStatus.text?.isEmpty == true,
           isFirstClick {
            textFieldStatus.text = ""
            isFirstClick = false
            textFieldStatus.isHidden = false
            statusHandler()
            return
        }
        do {
            try statusService.isValidStatus(status: textFieldStatus.text ?? "")
            if isStatusVisibleOfTextFieldStatus {
                statusLabel.text = textFieldStatus.text
            } else {
                showStatusButtonTopConstraint.isActive = false
                textFieldStatus.layer.borderColor = UIColor.black.cgColor
            }
            statusHandler()
            animateButton()
        } catch StatusError.emptyStatus {
            textFieldStatus.isHidden = false
            isStatusVisibleOfTextFieldStatus = true
            showError(for: textFieldStatus, message: "Введите статус")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func animateButton() {
        UIView.animate(withDuration: 0.2) {
            if self.isStatusVisibleOfTextFieldStatus {
                self.showStatusButtonTopConstraint.isActive = false
                self.showStatusButtonTopConstraint.constant = 64
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
                    self.showStatusButtonTopConstraint.constant = 44
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
            self.showStatusButton.backgroundColor = .vk
        }
    }
    
    @objc private func buttonPressed() {
        if let status = statusLabel.text {
            NSLog("Статус: \(status)")
            print(safeAreaLayoutGuide.layoutFrame.width - 32)
        } else {
            NSLog("Статуса нет, использую текст по умолчанию")
        }
    }
    
    private func showError(for textField: UITextField, message: String) {
        textField.shake()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.error.cgColor
        textField.layer.cornerRadius = 8
        textField.placeholder = message
    }
    
    private func setupView() {
        addSubviews([titleLabel, statusLabel, textFieldStatus, showStatusButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        showStatusButtonTopConstraint = showStatusButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 64)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                            constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                constant: 16 + 120 + 16),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                             constant: 46),
            statusLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16 + 120 + 16),
            
            textFieldStatus.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                 constant: 80),
            textFieldStatus.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                     constant: 6 + 120 + 16),
            textFieldStatus.heightAnchor.constraint(equalToConstant: 30),
            textFieldStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -16),
            
            showStatusButtonTopConstraint,
            showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            showStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -16),
            showStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: 16)
        ])
    }
}
