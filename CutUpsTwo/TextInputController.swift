//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class TextInputController: UIViewController, UITextViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        setupLyricTextView()
        
//        view.addSubview(lyricTextView)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
        return .portrait
    }
    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        
        
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return view
    }()
    
    
    func setupLyricTextView() {
        
        view.addSubview(lyricTextView)
        
        lyricTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        lyricTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        lyricTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        lyricTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        //Create a container for buttons
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.backgroundColor = .systemRed
        
        view.addSubview(buttonContainer)
        
        buttonContainer.topAnchor.constraint(equalTo: lyricTextView.bottomAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonContainer.leftAnchor.constraint(equalTo: lyricTextView.leftAnchor).isActive = true
        buttonContainer.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
//        buttonContainer.bottomAnchor.constraint(equalTo: lyricTextView.bottomAnchor, constant: 100).isActive = true
//        buttonContainer.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
//        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Cut", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.backgroundColor = .green
        
        
        buttonContainer.addSubview(sendButton)
        
        
        
        sendButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor).isActive = true
        
        
        
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//
//        lyricTextView.addSubview(sendButton)
//
//        sendButton.rightAnchor.constraint(equalTo: lyricTextView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: lyricTextView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: lyricTextView.heightAnchor).isActive = true
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
    }
    
    @objc func handleSend() {
        let textVC = LyricsController()

        print("Hello")
        
//        present(textVC, animated: true, completion: nil)
        
        navigationController?.pushViewController(textVC, animated: true)
 
        
    }
    
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct MainPreview: PreviewProvider {
    
    static var previews: some View {
//        Text("preview view")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return TextInputController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
    
}

//@available(iOS 13.0, *)
//struct SwiftLeeViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        SwiftLeeViewRepresentable()
//    }
//}
#endif
