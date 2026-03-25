//
//  ProfilePictureView.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//


import UIKit

final class ProfilePictureView : UIView {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let imageSize: CGFloat = 141
        static let imageCornerRadius: CGFloat = imageSize / 2
        
        // Images
        static let cameraImage: UIImage? = UIImage(named: "camera")
    }
    
    // MARK: - Fields
    private let imageView: UIImageView = .init()
    private let button: UIButton = .init(type: .system)
    
    private var onButtonPressed: (() -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setWidth(Constants.imageSize)
        setHeight(Constants.imageSize)
        
        configureImageView()
        configureAddButton()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.pin(to: self)
    }
    
    private func configureAddButton() {
        addSubview(button)
        
        button.setImage(Constants.cameraImage, for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 37 / 2
        
        button.setWidth(37)
        button.setHeight(37)
        button.pinLeft(to: imageView.trailingAnchor)
        button.pinBottom(to: imageView.bottomAnchor)
        
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Button press functions
    @objc private func addButtonPressed() {
        onButtonPressed?()
    }
    
    // MARK: - Update functions
    func updatePicture(with image: UIImage?) {
        if let image = image {
            imageView.image = image
        }
    }
    
    func getPicture() -> UIImage? {
        return imageView.image
    }
}
