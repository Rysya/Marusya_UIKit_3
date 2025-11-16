import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .cyan
        setupUI()
    }
    
    private func setupUI() {
        let infoLabel = UILabel()
        infoLabel.text = "Профиль пользователя"
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
