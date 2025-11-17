import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        title = "Информация"
        
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
            let closeButton = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: self,
                action: #selector(closeButtonTapped)
            )
            
            navigationItem.rightBarButtonItem = closeButton
            closeButton.tintColor = .label
        }
    
    private func setupUI() {
            let infoLabel = UILabel()
            infoLabel.text = "Это информационный экран"
            infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            infoLabel.textAlignment = .center
            infoLabel.numberOfLines = 0
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let showAlertButton = UIButton(type: .system)
            showAlertButton.setTitle("Показать Alert", for: .normal)
            showAlertButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            showAlertButton.backgroundColor = .systemBlue
            showAlertButton.setTitleColor(.white, for: .normal)
            showAlertButton.layer.cornerRadius = 10
            showAlertButton.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
            showAlertButton.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(infoLabel)
            view.addSubview(showAlertButton)
            
            NSLayoutConstraint.activate([
                infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
                infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                showAlertButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
                showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                showAlertButton.widthAnchor.constraint(equalToConstant: 200),
                showAlertButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        @objc private func showAlertButtonTapped() {
            showCustomAlert()
        }
        
        @objc private func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
        
        private func showCustomAlert() {
            let alertController = UIAlertController(
                title: "Согласие",
                message: "Вы соглашаетесь, потому что вы не можете не согласиться",
                preferredStyle: .alert
            )
            
            let firstAction = UIAlertAction(
                title: "Согласен",
                style: .default
            ) { _ in
                print("Пользователь нажал 'Согласен'")
            }
            
            let secondAction = UIAlertAction(
                title: "Подтверждаю",
                style: .destructive
            ) { _ in
                print("Пользователь нажал 'Подтвердить'")
            }
            
            alertController.addAction(firstAction)
            alertController.addAction(secondAction)
            
            present(alertController, animated: true, completion: nil)
        }
}
