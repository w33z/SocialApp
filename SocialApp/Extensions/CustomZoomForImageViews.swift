//
//  CustomZoomForImageViews.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 22.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

private var startingFrame: CGRect?
private var blackBGView: UIView?

extension UIViewController {
    func handleZoomInImageView(_ imageView: UIImageView) {
        
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = imageView.image
        zoomingImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomOutImageView(_:)))
        zoomingImageView.addGestureRecognizer(tap)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBGView = UIView(frame: keyWindow.frame)
            blackBGView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
            blackBGView?.alpha = 0
            
            keyWindow.addSubview(blackBGView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                
                blackBGView?.alpha = 1
                
                let height = startingFrame!.height / startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }

    @objc func handleZoomOutImageView(_ tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 15
            zoomOutImageView.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                blackBGView?.alpha = 0
                zoomOutImageView.frame = startingFrame!
                
            }, completion: { success in
                zoomOutImageView.removeFromSuperview()
            })
        }
    }
}
