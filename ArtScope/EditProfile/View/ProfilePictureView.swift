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
        // Strings
        
        // Images
        
        // UI Constraint properties
        static let imageSize: CGFloat = 141
        static let cornerRadius: CGFloat = imageSize / 2
        
        // Colors
    }
    
    // MARK: - Fields
    private let imageView: UIImageView = .init()
    
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
        configureImageView()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.setHeight(Constants.imageSize)
        imageView.setWidth(Constants.imageSize)
        imageView.pin(to: self)
    }
    
    private func configureAddButton() {
        // TODO: Add button
        // addSubview(button)
    }
    
    // MARK: - Button press functions
    private func addButtonPressed() {
        onButtonPressed?()
    }
    
    // MARK: - Update functions
    func updatePicture(with image: UIImage?) {
        if let image = image {
            imageView.image = image
        }
    }
}
