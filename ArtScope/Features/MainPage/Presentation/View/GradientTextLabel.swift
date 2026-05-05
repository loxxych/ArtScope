//
//  GradientTextLabel.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import UIKit

final class GradientTextLabel: UIView {
    private enum Constants {
        static let animationDuration: CFTimeInterval = 3
        static let gradientColors: [CGColor] = [
            UIColor.white.cgColor,
            UIColor.artScopeBlue.cgColor,
            UIColor.artScopeGreen.cgColor,
            UIColor.white.cgColor,
            UIColor.artScopeBlue.cgColor,
            UIColor.artScopeGreen.cgColor,
            UIColor.white.cgColor,
            UIColor.artScopeBlue.cgColor,
            UIColor.artScopeGreen.cgColor
        ]
        static let startLocations: [NSNumber] = [
            -0.75, -0.50, -0.25,
             0.00,  0.25,  0.50,
             0.75,  1.00,  1.25
        ]
        static let endLocations: [NSNumber] = [
             0.00,  0.25,  0.50,
             0.75,  1.00,  1.25,
             1.50,  1.75,  2.00
        ]
    }
    
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
        gradientLayer.colors = Constants.gradientColors
        gradientLayer.locations = Constants.startLocations
        
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
        guard gradientLayer.animation(forKey: "gradientAnimation") == nil else { return }

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = Constants.startLocations
        animation.toValue = Constants.endLocations
        animation.duration = Constants.animationDuration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = false

        gradientLayer.locations = Constants.startLocations
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
}
