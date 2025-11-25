import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private func createFeedUserController() -> UINavigationController {
        let nvc = UINavigationController(rootViewController: FeedViewController())
        nvc.tabBarItem = UITabBarItem(title: "Лента пользователя", image: UIImage(systemName: "house.fill"), tag: 0)
        return nvc
    }
    
    private func createProfileUserController() -> UINavigationController {
        let nvc = UINavigationController(rootViewController: ProfileViewController())
        nvc.tabBarItem = UITabBarItem(title: "Профиль пользователя", image: UIImage(systemName: "person.fill"), tag: 1)
        return nvc
    }
    
    private func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createFeedUserController(), createProfileUserController()]
        tabBar.tabBar.backgroundColor = .white
        tabBar.selectedIndex = 0
        return tabBar
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = createTabBar()
        window.makeKeyAndVisible()
        self.window = window
    }
}
