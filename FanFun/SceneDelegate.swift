import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

        if !hasCompletedOnboarding {
            let onboardingVC = OnboardingViewController()
            onboardingVC.onFinish = { [weak self] in
                self?.switchToMainApp(windowScene: windowScene)
            }
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = onboardingVC
            window?.makeKeyAndVisible()
        }
    }

    private func switchToMainApp(windowScene: UIWindowScene) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController()

        window?.rootViewController = mainVC
        UIView.transition(with: window!, duration: 0.4, options: .transitionCrossDissolve, animations: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
