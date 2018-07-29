//
//  DSSCell.swift
//  DSSAutoSizingUITextView
//
//  Created by David on 29/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

class DSSCell: UICollectionViewCell {
    
    var message: DSSMessage? {
        didSet {
            messageTextView.text = message?.text
            guard let width = message?.bubbleSize?.width else { return }
            messageWidthAnchor?.constant = width
        }
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = true
        textView.backgroundColor = .orange
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        return textView
    }()
    
    var messageWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(messageTextView)
        messageWidthAnchor = messageTextView.widthAnchor.constraint(equalToConstant: 200)
        messageTextView.setConstraints([
            messageTextView.heightAnchor.constraint(equalTo: heightAnchor),
            messageWidthAnchor,
            messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            messageTextView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
