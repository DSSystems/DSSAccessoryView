//
//  DSSAccessoryViewHandlers.swift
//  DSSAutoSizingUITextView
//
//  Created by David on 29/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

extension DSSAccessoryView {
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension UIView {
    func setConstraints(_ constraints: [NSLayoutConstraint?]) {
        translatesAutoresizingMaskIntoConstraints = false
        constraints.forEach{
            if let constraint = $0 {
                constraint.isActive = true
            }
        }
    }
    
    func fillToSuperview() {
        guard let top = superview?.topAnchor, let leading = superview?.leadingAnchor, let trailing = superview?.trailingAnchor, let bottom = superview?.bottomAnchor else { return }
        translatesAutoresizingMaskIntoConstraints = false
        [
            topAnchor.constraint(equalTo: top),
            bottomAnchor.constraint(equalTo: bottom),
            leadingAnchor.constraint(equalTo: leading),
            trailingAnchor.constraint(equalTo: trailing)
            ].forEach {$0.isActive = true}
    }
}

extension UIColor {
    static let customGray = UIColor(red: 225/250, green: 225/250, blue: 225/250, alpha: 1)
    static let customTintColor = UIColor(red: 100/250, green: 100/250, blue: 220/250, alpha: 1)
}

func estimaneSizeOf(textView: UITextView, from width: CGFloat) -> CGSize{
    let estimatedHeightSize = textView.sizeThatFits(CGSize(width: width, height: .infinity))
    let estimatesWidthSize = textView.sizeThatFits(CGSize(width: .infinity, height: estimatedHeightSize.height))
    
    return CGSize(width: min(estimatesWidthSize.width, estimatedHeightSize.width), height: estimatedHeightSize.height)
}
