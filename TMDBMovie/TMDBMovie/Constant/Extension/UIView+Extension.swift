//
//  UIView+Extension.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 20/11/23.
//

import UIKit
import QuartzCore

public extension UIView {
    func startShimmer() {
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "shimmer"
        gradientLayer.colors = [ShimmerViewManager.shared.startColor(), ShimmerViewManager.shared.endColor()]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = bounds
        
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.6
        animation.fromValue = -2.0 * frame.size.width
        animation.toValue = 2.0 * frame.size.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        gradientLayer.add(animation, forKey: "")
        ShimmerViewManager.shared.addToManagedLayers(shimmerLayer: gradientLayer)
    }
    
    func endShimmer() {
        if let layers = layer.sublayers {
            for layer in layers {
                if layer.name == "shimmer" {
                    if let gradientLayer = layer as? CAGradientLayer {
                        ShimmerViewManager.shared.removeFromManagedLayers(shimmerLayer: gradientLayer)
                    }
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}


public class ShimmerViewManager {
    public static let shared = ShimmerViewManager()

    private var activeShimmerLayers: [CAGradientLayer] = []
    
    private init() {}
    
    @available(iOS 12.0, *)
    public func updateGradientColor(style: UIUserInterfaceStyle) {
        for layer in activeShimmerLayers {
            DispatchQueue.main.async {
                layer.colors = [self.startColor(), self.endColor()]
            }
        }
    }

    func addToManagedLayers(shimmerLayer: CAGradientLayer) {
        activeShimmerLayers.append(shimmerLayer)
    }

    func removeFromManagedLayers(shimmerLayer: CAGradientLayer) {
        if let indexToRemove = activeShimmerLayers.firstIndex(of: shimmerLayer) {
            activeShimmerLayers.remove(at: indexToRemove)
        }
    }

    func startColor() -> CGColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.9).cgColor
    }

    func endColor() -> CGColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0).cgColor
    }
}
