//
//  FullscreenImageViewController.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class FullscreenImageViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .black
        static let closeButtonTintColor: UIColor = .white
        static let closeButtonSize: CGFloat = 32
        static let closeButtonTop: CGFloat = 16
        static let closeButtonRight: CGFloat = 16
    }
    
    // MARK: - Properties
    private let image: UIImage?
    private let imageView = UIImageView()
    private let closeButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    
    // MARK: - Lifecycle
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        scrollView.pin(to: view)
        
        scrollView.addSubview(imageView)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.pin(to: scrollView)
        imageView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
        imageView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)
        
        view.addSubview(closeButton)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = Constants.closeButtonTintColor
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.closeButtonTop)
        closeButton.pinRight(to: view.trailingAnchor, Constants.closeButtonRight)
        closeButton.setWidth(Constants.closeButtonSize)
        closeButton.setHeight(Constants.closeButtonSize)
    }
    
    // MARK: - Actions
    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }
}

extension FullscreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
