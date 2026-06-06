import UIKit

struct OnboardingPage {
    let imageName: String
    let title: String
    let subtitle: String
}

class OnboardingViewController: UIViewController {

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding_welcome",
            title: "Welcome to FanFun",
            subtitle: "Your ultimate sports companion for following the games you love."
        ),
        OnboardingPage(
            imageName: "onboarding_scores",
            title: "Live Scores & Updates",
            subtitle: "Stay on top of every match with real-time scores across all sports."
        ),
        OnboardingPage(
            imageName: "onboarding_favorites",
            title: "Follow Your Favorites",
            subtitle: "Save your favorite teams and leagues for quick access anytime."
        )
    ]

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let nextButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)

    var onFinish: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPages()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "ff_background")

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ff_primary")
        pageControl.pageIndicatorTintColor = UIColor(named: "ff_surfuce")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.setTitleColor(UIColor(named: "ff_on_primary"), for: .normal)
        nextButton.backgroundColor = UIColor(named: "ff_primary")
        nextButton.layer.cornerRadius = 25
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        skipButton.setTitleColor(UIColor(named: "ff_primary_text")?.withAlphaComponent(0.6), for: .normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.addSubview(skipButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    private func setupPages() {
        for (index, page) in pages.enumerated() {
            let pageView = createPageView(page: page, index: index)
            scrollView.addSubview(pageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height

        scrollView.contentSize = CGSize(width: width * CGFloat(pages.count), height: height)

        for (index, subview) in scrollView.subviews.enumerated() {
            subview.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
        }
    }

    private func createPageView(page: OnboardingPage, index: Int) -> UIView {
        let pageView = UIView()

        let imageView = UIImageView(image: UIImage(named: page.imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.addSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.text = page.title
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = UIColor(named: "ff_primary_text")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pageView.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = page.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = UIColor(named: "ff_primary_text")?.withAlphaComponent(0.7)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        pageView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: pageView.centerYAnchor, constant: -80),
            imageView.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.7),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -32),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -40)
        ])

        return pageView
    }

    @objc private func nextTapped() {
        let currentPage = pageControl.currentPage
        if currentPage < pages.count - 1 {
            let nextPage = currentPage + 1
            let offset = CGFloat(nextPage) * scrollView.bounds.width
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            pageControl.currentPage = nextPage
            updateButtonTitle(for: nextPage)
        } else {
            finishOnboarding()
        }
    }

    @objc private func skipTapped() {
        finishOnboarding()
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        onFinish?()
    }

    private func updateButtonTitle(for page: Int) {
        if page == pages.count - 1 {
            nextButton.setTitle("Get Started", for: .normal)
            skipButton.isHidden = true
        } else {
            nextButton.setTitle("Next", for: .normal)
            skipButton.isHidden = false
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        if page != pageControl.currentPage {
            pageControl.currentPage = page
            updateButtonTitle(for: page)
        }
    }
}
