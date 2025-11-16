import UIKit

class FeedViewController: UIViewController {
    
    let samplePost = Post(
            title: "Пост от leon",
            text: "Это содержимое первого поста от leon в этом приложении. Здесь может быть длинный текст с интересной информацией, о том как leon счастливо живет или что-то в этом роде.",
            img: UIImage(named: "leon")
        )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Лента пользователя"
        self.view.backgroundColor = .systemBlue
        
        SetupUI()
    }
    
    private func SetupUI() {
        let showPostButton = UIButton(type: .system)
        showPostButton.setTitle("Показать пост", for: .normal)
        showPostButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        showPostButton.tintColor = .yellow
        showPostButton.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        showPostButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(showPostButton)
        
        NSLayoutConstraint.activate([
            showPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showPostButtonTapped() {
        let postViewController = PostViewController(post: samplePost)
            
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
