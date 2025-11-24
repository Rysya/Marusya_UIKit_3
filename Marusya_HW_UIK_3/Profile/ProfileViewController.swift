import UIKit

class ProfileViewController: UIViewController {
    
    private var profileView = ProfileHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль пользователя"
        self.view.backgroundColor = .backgroundProfileGray
        view.addSubview(profileView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileView.frame = view.bounds
    }
}
