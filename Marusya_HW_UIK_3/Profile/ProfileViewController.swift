import UIKit

class ProfileViewController: UIViewController {
    
    override func loadView() {
        view = ProfileHeaderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .backgroundProfileGray
    }
}
