//
//  GradientTextLabel.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import UIKit

final class GradientTextLabel: UIView {
    
    private let textLayer = CATextLayer()
    private let gradientLayer = CAGradientLayer()
    
    var text: String = "" {
        didSet {
            textLayer.string = text
        }
    }
    
    var font: UIFont = .systemFont(ofSize: 20, weight: .bold) {
        didSet {
            textLayer.font = font
            textLayer.fontSize = font.pointSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.artScopeBlue.cgColor,
            UIColor.artScopeGreen.cgColor,

            UIColor.white.cgColor,
            UIColor.artScopeBlue.cgColor,
            UIColor.artScopeGreen.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.addSublayer(gradientLayer)
        
        textLayer.alignmentMode = .left
        textLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.mask = textLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        textLayer.frame = bounds
    }
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")

        animation.fromValue = [
            -0.5, -0.3, -0.1,
            0.1, 0.3, 0.5
        ]

        animation.toValue = [
            0.0, 0.2, 0.4,
            0.6, 0.8, 1.0
        ]

        animation.duration = 3
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        gradientLayer.locations = [
            0.0, 0.2, 0.4,
            0.6, 0.8, 1.0
        ] as [NSNumber]
        
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
}
