import UIKit

class LogInViewController: UIViewController {
    
    private var isKeyboardVisible = false
    private var isStatusVisibleOfErrorLabel = false
    private let authorizationService = AuthorizationService()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let logoVk: UIImageView = {
        let imageName = "logo_vk"
        let logoImageView = UIImageView()
        if let image = UIImage(named: imageName) {
            logoImageView.image = image
        } else {
            logoImageView.tintColor = .gray
            logoImageView.image = UIImage(systemName: "photo")
        }
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        return logoImageView
    }()
    
    //MARK: Форма ввода
    
    private lazy var emailTextField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textField = UITextField()
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.placeholder = "Email or phone"
        textField.text = "123@ya.ru"
        textField.borderStyle = .none
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textDidChange(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textField = UITextField()
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.placeholder = "Password"
        textField.text = "123qwe"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textDidChangePassword(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .error
        label.text = "Некорректный пароль"
        label.isHidden = true
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        let imageName = "logIn"
        if let imageBg = UIImage(named: imageName) {
            button.setBackgroundImage(imageBg, for: .normal)
            button.setBackgroundImage(imageBg.image(alpha: 0.8), for: .selected)
            button.setBackgroundImage(imageBg.image(alpha: 0.8), for: .highlighted)
            button.setBackgroundImage(imageBg.image(alpha: 0.8), for: .disabled)
        } else {
            button.backgroundColor = .vk
        }
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(toProfilView), for: .touchUpInside)
        return button
    }()
    
    private var showStatusLoginButtonTopConstraint: NSLayoutConstraint!
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       line,
                                                       passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.accessibilityContainerType = .list
        stackView.spacing = 0
        return stackView
    }()
    
    //MARK: Жизненный цикл
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupHideKeyboardOnTap()
    }
    
    private func setupSubviews() {
        view.addSubviews([scrollView])
        scrollView.addSubviews([logoVk, stackView, errorLabel, loginButton])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    //MARK: Клавиатура
    
    func subscribeKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard isKeyboardVisible == false,
              let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        isKeyboardVisible = true
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: ks.height - view.safeAreaInsets.bottom + 20, right: 0)
        let contentHeightMaxY = loginButton.frame.maxY
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeightMaxY)
        
        let maxOffset = max(0, scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.setContentOffset(CGPoint(x: 0, y: maxOffset), animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        isKeyboardVisible = false
    }
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let emailFieldFrame = emailTextField.convert(emailTextField.bounds, to: view)
        let passwordFieldFrame = passwordTextField.convert(passwordTextField.bounds, to: view)
        let loginBottomFrame = loginButton.convert(loginButton.bounds, to: view)
        
        if !emailFieldFrame.contains(location) && !passwordFieldFrame.contains(location) && !loginBottomFrame.contains(location) {
            view.endEditing(true)
        }
    }
    
    //MARK: При нажатии на кнопку
    
    @objc private func toProfilView() {
        
        do {
            try authorizationService.isValidUser(login: emailTextField.text ?? "",
                                                 password: passwordTextField.text ?? "")
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
            
        } catch (let error) {
            guard let authorizationError = error as? AuthorizationError else {
                print(error.localizedDescription)
                return
            }
            switch authorizationError {
                case .emptyLogin:
                    showError(for: emailTextField, message: "Введите email или телефон")
                    isStatusVisibleOfErrorLabel = true
                    showErrorLabel(message: "Введите email или телефон")
                case .emptyPassword:
                    showError(for: passwordTextField, message: "Введите пароль")
                    isStatusVisibleOfErrorLabel = true
                    showErrorLabel(message: "Пустой пароль")
                case .notValidPassword:
                    showError(for: passwordTextField, message: "Пароль должен иметь длину не меньше 6")
                    isStatusVisibleOfErrorLabel = true
                    showErrorLabel(message: "Пароль должен иметь длину не меньше 6")
                case .unknownUser:
                    showError(for: emailTextField, message: "Неизвестный пользователь")
                    isStatusVisibleOfErrorLabel = true
                    showErrorLabel(message: "Неизвестный пользователь")
                case .wrongPassword:
                    showError(for: passwordTextField, message: "Неверный пароль")
                    isStatusVisibleOfErrorLabel = true
                    showErrorLabel(message: "Неверный пароль")
                case .wrongEmail:
                    showError(for: emailTextField, message: "Неверный email")
                    isStatusVisibleOfErrorLabel = true
                    showAlert()
            }
        }
    }
    
    //MARK: Ошибки полей
    
    private func showError(
        for textField: UITextField,
        message: String
    ) {
        textField.shake()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.error.cgColor
        textField.layer.cornerRadius = 8
        textField.placeholder = message
    }
    
    @objc private func textDidChangePassword(_ textField: UITextField) {
        textDidChange(textField)
        showErrorLabel(message: "")
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.placeholder = nil
        textField.text = ""
        isStatusVisibleOfErrorLabel = false
    }
    
    @objc private func showErrorLabel(message: String) {
        if isStatusVisibleOfErrorLabel {
            errorLabel.text = message
            errorLabel.isHidden = false
            self.showStatusLoginButtonTopConstraint.isActive = false
        } else {
            errorLabel.text = ""
            errorLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.2) {
            if self.isStatusVisibleOfErrorLabel {
                self.showStatusLoginButtonTopConstraint.isActive = false
                self.showStatusLoginButtonTopConstraint.constant = 32
                self.showStatusLoginButtonTopConstraint.isActive = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } else {
                self.errorLabel.text = ""
                self.errorLabel.isHidden = true
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                if self.isStatusVisibleOfErrorLabel {
                    self.errorLabel.text = message
                    self.errorLabel.isHidden = false
                } else {
                    self.showStatusLoginButtonTopConstraint.constant = 16
                    self.showStatusLoginButtonTopConstraint.isActive = true
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Неверный email",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //MARK: Констреинты
    
    private func setupConstraints() {
        showStatusLoginButtonTopConstraint = loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoVk.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            logoVk.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoVk.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoVk.widthAnchor.constraint(equalToConstant: 100),
            logoVk.heightAnchor.constraint(equalToConstant: 100),
            
            line.heightAnchor.constraint(equalToConstant: 0.5),
            
            showStatusLoginButtonTopConstraint,
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -4, 4, 0]
        layer.add(animation, forKey: "shake")
    }
}
