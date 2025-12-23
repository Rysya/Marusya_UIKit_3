import UIKit

class LogInViewController: UIViewController {
    
    private var isKeyboardVisible = false
    
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
    
    private let emailTextField: UITextField = {
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
    
    @objc private func toProfilView() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupHideKeyboardOnTap()
    }
    
    private func setupSubviews() {
        view.addSubviews([scrollView])
        scrollView.addSubviews([logoVk, stackView, loginButton])
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
    
    private func setupConstraints() {
        
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
            
            logoVk.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoVk.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoVk.widthAnchor.constraint(equalToConstant: 100),
            logoVk.heightAnchor.constraint(equalToConstant: 100),
            
            line.heightAnchor.constraint(equalToConstant: 0.5),
            
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}
