//
//  ArtistQuizActionButton.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizActionButton: UIButton {
    private enum Constants {
        static let height: CGFloat = 40
        static let horizontalInset: CGFloat = 20
        static let spacing: CGFloat = 10
        static let cornerRadius: CGFloat = 20
        static let font: UIFont = .InstrumentSansSemiBold15
        static let backgroundColor: UIColor = .artScopeBlue
        static let disabledBackgroundColor: UIColor = UIColor.artScopeBlue.withAlphaComponent(0.45)
        static let titleColor: UIColor = .white
        static let iconName: String = "arrow.right"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseInOut]) {
                self.backgroundColor = self.isEnabled ? Constants.backgroundColor : Constants.disabledBackgroundColor
                self.transform = self.isEnabled ? .identity : CGAffineTransform(scaleX: 0.98, y: 0.98)
            }
        }
    }
    
    func setTitleText(_ text: String) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = text
        configuration.image = UIImage(systemName: Constants.iconName)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Constants.spacing
        configuration.baseForegroundColor = Constants.titleColor
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constants.horizontalInset,
            bottom: 0,
            trailing: Constants.horizontalInset
        )
        self.configuration = configuration
    }
    
    private func configureUI() {
        titleLabel?.font = Constants.font
        tintColor = Constants.titleColor
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        setHeight(Constants.height)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.12) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            }
        }
    }
}
