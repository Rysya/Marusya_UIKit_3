import UIKit

class LogInViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var isKeyboardVisible = false
    
    private lazy var logoVk: UIImageView = {
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
    
    private lazy var emailTextField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textField = UITextField()
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.placeholder = "Email or phone"
        textField.borderStyle = .none
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private let passwordTextField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let textField = UITextField()
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let loginButton: UIButton = {
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.accessibilityContainerType = .list
        stackView.spacing = 0
        return stackView
    }()
    
    @objc private func toProfilView() {
        print("идем в профиль")
        let profileVC = ProfileViewController()
        // Если есть navigationController - используем push
        if let navigationController = navigationController {
            navigationController.pushViewController(profileVC, animated: true)
        } else {
            // Иначе present
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupConstraints()
        setupHideKeyboardOnTap()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        setupSubviews()
        scrollView.keyboardDismissMode = .interactive
        view.addSubviews([scrollView])
    }
    
    private func setupSubviews() {
        scrollView.addSubviews([logoVk, stackView, line, loginButton])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribeKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard isKeyboardVisible == false,
              let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        isKeyboardVisible = true
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: ks.height - self.view.safeAreaInsets.bottom + 20, right: 0)
        let contentHeightMaxY = loginButton.frame.maxY
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeightMaxY)
        
        let maxOffset = max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.setContentOffset(CGPoint(x: 0, y: maxOffset), animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.scrollView.contentInset = .zero
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
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoVk.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            logoVk.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            logoVk.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            logoVk.widthAnchor.constraint(equalToConstant: 100),
            logoVk.heightAnchor.constraint(equalToConstant: 100),
            
            line.heightAnchor.constraint(equalToConstant: 0.5),
            line.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50),
            line.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            line.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
            
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -20)
        ])
    }
}
