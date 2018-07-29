//
//  ViewController.swift
//  DSSAutoSizingUITextView
//
//  Created by David on 28/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

class DSSMainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DSSDSSAccessoryViewDelegate {
    
    let cellId = "cellId"
    
    var messages: [DSSMessage] = [DSSMessage]()
    
    lazy var composeView: DSSAccessoryView = {
        let view = DSSAccessoryView()
        view.tintStyleColor = .red
        view.borderColor = .orange
        view.blurryBackground = true
        view.delegate = self
        return view
    }()
    
    fileprivate func setupAccessories() {
        let greenView = UIView()
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 18
        greenView.layer.masksToBounds = true
        let blueView = UIView()
        blueView.backgroundColor = .blue
        blueView.layer.cornerRadius = 18
        blueView.layer.masksToBounds = true
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.layer.cornerRadius = 18
        yellowView.layer.masksToBounds = true
        composeView.accessories = [greenView, blueView, yellowView]
        greenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hadleCustomRed)))
        greenView.isUserInteractionEnabled = true
        blueView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hadleCustomBlue)))
        blueView.isUserInteractionEnabled = true
        yellowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hadleCustomYellow)))
        yellowView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(DSSCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        setupAccessories()
        
    }
    
    override var inputAccessoryView: UIView? {
        return composeView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DSSCell
        cell.message = message
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messages[indexPath.row]
        guard let window = UIApplication.shared.keyWindow else { return CGSize(width: 100, height: 100) }
        
        if let bubbleSize = message.bubbleSize {
            return CGSize(width: window.safeAreaLayoutGuide.layoutFrame.width, height: bubbleSize.height)
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func didPressedSendButton(textView: UITextView) {
        let message = DSSMessage()
        message.text = textView.text
        guard let width = collectionView?.frame.width else { return }
        let bubbleSize = estimaneSizeOf(textView: textView, from: width * 0.6)
        message.bubbleSize = bubbleSize
        messages.append(message)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @objc func hadleCustomRed() {
        print("Green pressed")
    }
    
    @objc func hadleCustomBlue() {
        print("Blue pressed")
    }
    
    @objc func hadleCustomYellow() {
        print("Yellow pressed")
    }
}
