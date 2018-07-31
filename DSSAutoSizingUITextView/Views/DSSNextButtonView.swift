//
//  DSSNextButtonView.swift
//  DSSCoreGraphics
//
//  Created by David on 30/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

protocol DSSNextButtonDelegate {
    func handleNextButton()
}

class DSSNextButtonView: UIView {
    var delegate: DSSNextButtonDelegate?
    
    var lightMode: Bool = false {
        didSet {
            self.nextViewButton.lightMode = lightMode
            self.nextViewButton.setNeedsDisplay()
        }
    }
    
    var primaryColor: UIColor = .green {
        didSet {
            self.nextViewButton.primaryColor = primaryColor
            self.nextViewButton.setNeedsDisplay()
        }
    }
    
    var secondaryColor: UIColor = .white {
        didSet {
            self.nextViewButton.secondaryColor = secondaryColor
            self.nextViewButton.setNeedsDisplay()
        }
    }
    
    private let nextViewButton: DSSNextView = {
        let view = DSSNextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupNextViewButton()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        let scale: CGFloat = 1.25
        let duration: TimeInterval = 0.25
        let originalTransform = nextViewButton.transform
        let transformZoomIn = originalTransform.scaledBy(x: scale, y: scale)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.nextViewButton.transform = transformZoomIn
        }) { (_) in
            if self.delegate == nil {
                print("Error delegate not set properly")
            } else {
                self.delegate?.handleNextButton()
            }
        }
        
        UIView.animate(withDuration: duration, delay: duration, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.nextViewButton.transform = originalTransform
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNextViewButton() {
        addSubview(nextViewButton)
        [nextViewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
         nextViewButton.centerYAnchor.constraint(equalTo: centerYAnchor),
         nextViewButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
         nextViewButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75)
            ].forEach {
                $0.isActive = true
        }
    }
}

class DSSNextView: UIView {
    var primaryColor: UIColor = .green
    var secondaryColor: UIColor = .white
    var lightMode: Bool = false
    
    private struct Params {
        static var lineWidth: CGFloat = 1.0
        static let lineLength: CGFloat = 0.25
        static let angle: CGFloat = CGFloat.pi / 4
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    override func draw(_ rect: CGRect) {
        let size = min(rect.size.width, rect.size.height)
        Params.lineWidth = 0.1 * size
        
        if lightMode {
            let newOrigin = CGPoint(x: (rect.width - 0.95 * size) / 2, y: (rect.height - 0.95 * size) / 2)
            let newRect = CGRect(origin: newOrigin, size: CGSize(width: 0.95 * size, height: 0.95 * size))
            let path = UIBezierPath(ovalIn: newRect)
            secondaryColor.setStroke()
            path.lineWidth = 0.05 * size
            path.stroke()
        } else {
            let newOrigin = CGPoint(x: (rect.width - size) / 2, y: (rect.height - size) / 2)
            let newRect = CGRect(origin: newOrigin, size: CGSize(width: size, height: size))
            let path = UIBezierPath(ovalIn: newRect)
            primaryColor.setFill()
            path.fill()
        }
        
        drawUpperLine(size: size, color: lightMode ? primaryColor : .white)
        drawBottomLine(size: size, color: lightMode ? primaryColor : .white)
    }
    
    private func drawLine(from initialPoint: CGPoint, to finalPoint: CGPoint, color: UIColor = .black) {
        let linePath = UIBezierPath()
        linePath.lineWidth = Params.lineWidth
        linePath.move(to: initialPoint)
        linePath.addLine(to: finalPoint)
        linePath.lineCapStyle = .round
        color.setStroke()
        linePath.stroke()
    }
    
    private  func drawUpperLine(size: CGFloat, color: UIColor = .black) {
        let canOrigin = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let initalPoint = CGPoint(x: canOrigin.x + (Params.lineLength * size * cos(Params.angle)) / 2,
                                  y: canOrigin.y)
        let finalPoint = CGPoint(x: canOrigin.x - (Params.lineLength * size * cos(Params.angle)) / 2,
                                 y: canOrigin.y - Params.lineLength * size * sin(Params.angle))
        
        drawLine(from: initalPoint, to: finalPoint, color: color)
    }
    
    private  func drawBottomLine(size: CGFloat, color: UIColor = .black) {
        let canOrigin = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let initalPoint = CGPoint(x: canOrigin.x + (Params.lineLength * size * cos(Params.angle)) / 2,
                                  y: canOrigin.y)
        let finalPoint = CGPoint(x: canOrigin.x - (Params.lineLength * size * cos(Params.angle)) / 2,
                                 y: canOrigin.y + Params.lineLength * size * sin(Params.angle))
        
        drawLine(from: initalPoint, to: finalPoint, color: color)
    }
}
