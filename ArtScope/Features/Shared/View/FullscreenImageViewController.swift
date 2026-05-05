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
        static let minimumZoomScale: CGFloat = 1
        static let maximumZoomScale: CGFloat = 4
        static let doubleTapZoomScale: CGFloat = 2.4
    }
    
    // MARK: - Properties
    private let image: UIImage?
    private let imageView = UIImageView()
    private let closeButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private lazy var doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
    
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageInsets()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pin(to: view)
        
        scrollView.addSubview(imageView)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        imageView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        imageView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        imageView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        imageView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
        imageView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)

        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
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

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > Constants.minimumZoomScale {
            scrollView.setZoomScale(Constants.minimumZoomScale, animated: true)
            return
        }

        let zoomPoint = gesture.location(in: imageView)
        let targetZoomScale = min(Constants.doubleTapZoomScale, Constants.maximumZoomScale)
        let scrollViewSize = scrollView.bounds.size
        let width = scrollViewSize.width / targetZoomScale
        let height = scrollViewSize.height / targetZoomScale
        let originX = zoomPoint.x - (width / 2)
        let originY = zoomPoint.y - (height / 2)
        let zoomRect = CGRect(x: originX, y: originY, width: width, height: height)

        scrollView.zoom(to: zoomRect, animated: true)
    }

    private func updateImageInsets() {
        let scrollBounds = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let verticalInset = max(0, (scrollBounds.height - contentSize.height) / 2)
        let horizontalInset = max(0, (scrollBounds.width - contentSize.width) / 2)

        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
}

extension FullscreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageInsets()
    }
}
