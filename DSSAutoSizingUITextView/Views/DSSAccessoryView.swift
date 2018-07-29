//
//  DSSAccessoryView.swift
//  DSSAutoSizingUITextView
//
//  Created by David on 28/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

protocol DSSDSSAccessoryViewDelegate {
    func didPressedSendButton(textView: UITextView)
}

protocol DSSAccessoryProtocol {
    var size: CGFloat { get }
}

class DSSAccessoryView: UIView, UITextViewDelegate, DSSAccessoryProtocol {
    
    var size: CGFloat = 36
    var delegate: DSSDSSAccessoryViewDelegate?
    private var stackView: UIStackView?
    private var stackViewWidthAnchor: NSLayoutConstraint?
    private var stackViewHeightAnchor: NSLayoutConstraint?
    private var showAccessoriesButton: UIButton?
    private var showAccessoryButtonWidthAnchor: NSLayoutConstraint?
    private var showAccessoryButtonHeightAnchor: NSLayoutConstraint?
    private var blurEffectView: UIVisualEffectView?
    private var leftAccessoryViewWidthAnchor: NSLayoutConstraint?
    private var leftAccessoryViewPaddingAnchor: NSLayoutConstraint?
    
    var borderColor: UIColor = UIColor.customGray {
        didSet {
            setuBorderColor()
        }
    }
    
    var blurryBackground: Bool = false {
        didSet {
            if blurryBackground {
                setupBlurryBackground()
            } else {
                removeBlurEfect()
            }
        }
    }
    
    var tintStyleColor: UIColor = UIColor.customTintColor {
        didSet {
            setupTintStyleColor()
        }
    }
    
    private var leftAccessoryView = UIView() {
        didSet {
            leftAccessoryViewPaddingAnchor?.constant = 4
            leftAccessoryViewWidthAnchor?.constant = size
            leftAccessoryView.backgroundColor = .white
            leftAccessoryView.layer.cornerRadius = size / 2
            leftAccessoryView.layer.masksToBounds = true
        }
    }
    
    var accessories: [UIView] = [] {
        didSet {
            setupAccessoryViews()
        }
    }
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = size / 2
        textView.layer.masksToBounds = true
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: size / 2 - 2)
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    private func setuBorderColor() {
        sendButton.layer.borderColor = borderColor.cgColor
        inputTextView.layer.borderColor = borderColor.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        setupLeftAccessoryView()
        setupSendButton()
        setupInputTextField()
    }
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        
        self.size = size
        
        autoresizingMask = .flexibleHeight
        setupLeftAccessoryView()
        setupSendButton()
        setupInputTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DSSAccessoryView {
    
    private func removeBlurEfect() {
        sendButton.layer.borderWidth = 1
        sendButton.backgroundColor = .clear
        sendButton.setTitleColor(tintStyleColor, for: .normal)
        showAccessoriesButton?.backgroundColor = tintStyleColor
        showAccessoriesButton?.layer.borderWidth = 1
        blurEffectView?.removeFromSuperview()
        backgroundColor = UIColor(white: 1, alpha: 1)
    }
    
    private func setupLeftAccessoryView() {
        addSubview(leftAccessoryView)
        leftAccessoryViewWidthAnchor = leftAccessoryView.widthAnchor.constraint(equalToConstant: 0)
        leftAccessoryViewPaddingAnchor = leftAccessoryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0)
        leftAccessoryView.setConstraints([
            leftAccessoryViewPaddingAnchor,
            leftAccessoryViewWidthAnchor!,
            leftAccessoryView.heightAnchor.constraint(equalToConstant: size),
            leftAccessoryView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4)
            ])
    }
    
    private func setupInputTextField() {
        inputTextView.layer.borderColor = borderColor.cgColor
        inputTextView.layer.borderWidth = 1
        addSubview(inputTextView)
        inputTextView.setConstraints([
            inputTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            inputTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4),
            inputTextView.leadingAnchor.constraint(equalTo: leftAccessoryView.trailingAnchor, constant: 4),
            inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4)
            ])
    }
    
    private func setupSendButton() {
        sendButton.layer.cornerRadius = size / 2
        addSubview(sendButton)
        sendButton.layer.borderColor = borderColor.cgColor
        sendButton.layer.borderWidth = 1
        sendButton.setTitleColor(tintStyleColor, for: .normal)
        sendButton.setConstraints([
            sendButton.heightAnchor.constraint(equalToConstant: size),
            sendButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4),
            sendButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -4),
            sendButton.widthAnchor.constraint(equalToConstant: 2 * size)
            ])
    }
    
    private func setupBlurryBackground() {
        let blur = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView?.frame = self.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor(white: 0.8, alpha: 0.65)
        sendButton.layer.borderWidth = 0
        sendButton.backgroundColor = tintStyleColor
        sendButton.setTitleColor(.white, for: .normal)
        showAccessoriesButton?.backgroundColor = tintStyleColor
        showAccessoriesButton?.layer.borderColor = borderColor.cgColor
        showAccessoriesButton?.layer.borderWidth = 0
        addSubview(blurEffectView!)
        sendSubview(toBack: blurEffectView!)
    }
    
    func setupTintStyleColor() {
        if blurryBackground {
            self.sendButton.backgroundColor = tintStyleColor
            self.sendButton.setTitleColor(.white, for: .normal)
            self.showAccessoriesButton?.backgroundColor = tintStyleColor
            self.showAccessoriesButton?.setTitleColor(.white, for: .normal)
        } else {
            self.sendButton.backgroundColor = .clear
            self.sendButton.setTitleColor(tintStyleColor, for: .normal)
            self.showAccessoriesButton?.backgroundColor = .clear
            self.showAccessoriesButton?.setTitleColor(tintStyleColor, for: .normal)
        }
    }
    
    private func setupAccessoryViews() {
        let numberOfViews = accessories.count
        let totalAccessoryWidth = (size + 4) * CGFloat(numberOfViews) - 4
        if numberOfViews == 0 { return }
        
        leftAccessoryViewPaddingAnchor?.constant = 4
        leftAccessoryViewWidthAnchor?.constant = totalAccessoryWidth
        let stackView = UIStackView(arrangedSubviews: accessories)
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        if numberOfViews >= 3 {
            let showAccessoriesButton = UIButton(type: .system)
            showAccessoriesButton.setTitle(">", for: .normal)
            showAccessoriesButton.setTitle("<", for: .highlighted)
            showAccessoriesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: size / 2)
            showAccessoriesButton.layer.cornerRadius = 0.7 * size / 2
            showAccessoriesButton.layer.borderColor = borderColor.cgColor
            showAccessoriesButton.layer.masksToBounds = true
            
            if blurryBackground {
                showAccessoriesButton.backgroundColor = tintStyleColor
                showAccessoriesButton.layer.borderWidth = 0
                showAccessoriesButton.tintColor = .white
            } else {
                showAccessoriesButton.backgroundColor = .clear
                showAccessoriesButton.layer.borderWidth = 1
                showAccessoriesButton.tintColor = tintStyleColor
            }
            
            leftAccessoryView.addSubview(showAccessoriesButton)
            showAccessoryButtonWidthAnchor = showAccessoriesButton.widthAnchor.constraint(equalToConstant: 0)
            showAccessoryButtonHeightAnchor = showAccessoriesButton.heightAnchor.constraint(equalToConstant: 0)
            showAccessoriesButton.setConstraints([
                showAccessoryButtonWidthAnchor,
                showAccessoryButtonHeightAnchor,
                showAccessoriesButton.centerXAnchor.constraint(equalTo: leftAccessoryView.centerXAnchor),
                showAccessoriesButton.centerYAnchor.constraint(equalTo: leftAccessoryView.centerYAnchor)
                ])
            showAccessoriesButton.addTarget(self, action: #selector(handleShowAccesories), for: .touchUpInside)
            self.showAccessoriesButton = showAccessoriesButton
            
            leftAccessoryView.addSubview(stackView)
            stackViewWidthAnchor = stackView.widthAnchor.constraint(equalToConstant: totalAccessoryWidth)
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalToConstant: size)
            stackView.setConstraints([
                stackViewHeightAnchor,
                stackViewWidthAnchor,
                stackView.centerXAnchor.constraint(equalTo: leftAccessoryView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: leftAccessoryView.centerYAnchor)
                ])
            self.stackView = stackView
        } else {
            leftAccessoryView.addSubview(stackView)
            stackViewWidthAnchor = stackView.widthAnchor.constraint(equalToConstant: totalAccessoryWidth)
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalToConstant: size)
            stackView.setConstraints([
                stackViewHeightAnchor,
                stackViewWidthAnchor,
                stackView.centerXAnchor.constraint(equalTo: leftAccessoryView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: leftAccessoryView.centerYAnchor)
                ])
            self.stackView = stackView
        }
    }
    
    func hideAccessories() {
        if accessories.count < 3 { return }
        showAccessoryButtonWidthAnchor?.constant = 0.7 * size
        showAccessoryButtonHeightAnchor?.constant = 0.7 * size
        stackViewHeightAnchor?.constant = size
        stackViewWidthAnchor?.constant = 0
        leftAccessoryViewWidthAnchor?.constant = size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hideAccessories()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        handleShowAccesories()
    }
    
    @objc func handleShowAccesories() {
        let numberOfViews = accessories.count
        let totalAccessoryWidth = (size + 4) * CGFloat(numberOfViews) - 4
        
        if numberOfViews < 3 { return }
        showAccessoryButtonHeightAnchor?.constant = 0
        showAccessoryButtonWidthAnchor?.constant = 0
        stackViewWidthAnchor?.constant = totalAccessoryWidth
        leftAccessoryViewWidthAnchor?.constant = totalAccessoryWidth
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handleSend(button: UIButton) {
        if inputTextView.text.isEmpty { return }
        delegate?.didPressedSendButton(textView: inputTextView)
        inputTextView.text = ""
        inputTextView.resignFirstResponder()
        handleShowAccesories()
    }
}

