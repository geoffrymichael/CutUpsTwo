//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class ScrapsToShareData: Codable {
    var array: [String] = []
    
    
}

class ScrapsDocument: UIDocument {
    var lyricsData: ScrapsToShareData?
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        let myJson = try? encoder.encode(lyricsData)
        
        return myJson ?? Data("whatever".utf8)
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? Data else {
            return
        }
        
        lyricsData = try JSONDecoder().decode(ScrapsToShareData.self, from: contents)
        
    }
}

class Document: UIDocument {
    var text = "Test UIDocument text"
    
    override func contents(forType typeName: String) throws -> Any {
        return Data(text.utf8)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? Data else {
            return
        }
        
        text = String(decoding: contents, as: UTF8.self)
    }
    
}


class TextInputController: UIViewController, UITextViewDelegate, SendScrapsArrayDelegate {
    
    
    func onSend(scraps: [String]) {
        print(scraps)
        scrapsToShareData.array = scraps
    }
    
     
    var scrapsToShareData = ScrapsToShareData()
    
    var scrapsToShare = [String]()
    
//    var scrap: String? {
//        didSet {
//            previewLabel.text = scrap
//            previewLabel.textColor = .black
//        }
//    }
    
    let activityIN = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.view.backgroundColor = .white
        
        
        
//        activityIndicator.center = view.center
//
//        view.addSubview(activityIndicator)
        
        
        
        
        //Remove the "back" text from the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Account for viewcontroller color depending on load interface style
        if traitCollection.userInterfaceStyle == .light {
                   self.view.backgroundColor = UIColor.white
               } else {
                   self.view.backgroundColor = UIColor.black
               }
        
        
    
        self.lyricTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: Selector(("handleSend")))
        self.navigationItem.leftBarButtonItem = edit
        

//        let automaticButton = UIBarButtonItem(title: "Automatic", style: .plain, target: self, action: #selector(automaticCut))
        
        let randomButton = UIBarButtonItem(title: "Random", style: .plain, target: self, action: #selector(onRandom))
        
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(onHelp))
        
        let automaticButton = UIBarButtonItem(image: UIImage(systemName: "scissors"), style: .plain, target: self, action: #selector(automaticCut))
        
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(onCamera))
        
       
        
        
        self.navigationItem.setRightBarButtonItems([helpButton, randomButton, cameraButton, automaticButton], animated: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        name: UIPasteboard.changedNotification, object: nil)        
        
        //Keyboard hide and view observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let vc = LyricsController()
        vc.scrapsSendDelegate = self
        

        setupLyricTextView()
        setupVision()
        
    
    }
    

    //MARK: Vision Implimentation
    
    //MARK: Vision License
    /*
        The Vision implimentation for Cut-ups uses code modified from apple provided source code. Please see license information below
        
       Copyright © 2019 Apple Inc.

       Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

       The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

     */
    
    //The camera button sends to the documentscanner controller
    @objc func onCamera() {
         let documentCameraViewController = VNDocumentCameraViewController()
               documentCameraViewController.delegate = self
               present(documentCameraViewController, animated: true)
    }
    
    
    // Vision requests to be performed on each page of the scanned document.
    private var requests = [VNRequest]()
    // Dispatch queue to perform Vision requests.
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                         qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var resultingText = ""
    
    // Setup Vision request as the request can be reused
    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            // Concatenate the recognised text from all the observations.
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        // specify the recognition level
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Adjust scroll view height on keyboard will show
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        print("keyboard shows")
        
        let keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        textViewBottomanchor?.constant = -keyBoardHeight.height
        
    }
    
    //Back to full screen when keyboard hides
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let margins = view.layoutMargins
        
        textViewBottomanchor?.constant = margins.bottom
        lyricTextView.layoutIfNeeded()
        
    }
    
    //Change view controller color depending on interface style
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor.white
        } else {
            self.view.backgroundColor = UIColor.black
        }
    }
    
    //UILabel needs to be subclassed in order to create edge insets for its text
//    class PreviewLabel: UILabel {
//        override func drawText(in rect: CGRect) {
//            let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            super.drawText(in: rect.inset(by: insets))
//        }
//
//    }
    
//    lazy var previewLabel: PreviewLabel = {
//        let label = PreviewLabel()
//        label.textColor = .placeholderText
//        label.text = "Most Recently Manually Cut/Copied Line"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .white
//
//        return label
//    }()
    
    
    
    
    
    var placeholderLabel = UILabel()
    
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !textView.text.isEmpty
       }
    
   
    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
//        view.backgroundColor = UIColor.
        view.font = UIFont.systemFont(ofSize: 16)
        
//         var activityIN: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100, y: 200, width: 50, height: 50)) as UIActivityIndicatorView
        
        activityIN.center = CGPoint(x: 180, y: 180)
        activityIN.hidesWhenStopped = true
        
        activityIN.style = UIActivityIndicatorView.Style.large
        activityIN.stopAnimating()
        view.addSubview(activityIN)

        
        let placeholderText =
                                """
                                Type or copy/paste in some text.

                                Click on the scissors to cut the text into chuncks.

                                Click on edit to rearrange the chunks into new and intersting ideas.

                                Click on the camera to scan in some physical text if you like.

                                Click on random to get a random snippet of a passage from an old book. (This feature requires that you be connected to the internet)

                                Blend it all together and cut-it-up to make something new. How fun.
                                
                                Click on Help for more detailed instructions.

                                

                                """

        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: 13)
        placeholderLabel.sizeToFit()
        
        placeholderLabel.numberOfLines = 0
        view.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (view.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !view.text.isEmpty
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    
    //ToDo, perhaps impliment landscape orientation contextual changes
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            
            print(UIDevice.current.orientation.isLandscape)
            
        })
    }
    
    var textViewBottomanchor: NSLayoutConstraint?
    
    func setupLyricTextView() {
        

//        view.addSubview(previewLabel)
//
//
        let margins = view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//           previewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//           previewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//           previewLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
//            previewLabel.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        view.addSubview(lyricTextView)
        
        NSLayoutConstraint.activate([
            lyricTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            lyricTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            lyricTextView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            lyricTextView.topAnchor.constraint(equalTo: margins.topAnchor),
//            lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        
        ])
        
        textViewBottomanchor = lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        textViewBottomanchor?.isActive = true
        
        placeholderLabel.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
        
        
    }
    
   
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func clipboardChanged(){
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
//            scrap = theString
//            scrapsToShare.append(theString)
            
            scrapsToShareData.array.append(theString)
            
            print(scrapsToShare)
            
        }
    }
    
    @objc func handleSend() {
        let textVC = LyricsController()
        
        textVC.scrapsSendDelegate = self
        
        guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                         return
                     }
                     
                     let scrapsDocument = ScrapsDocument(fileURL: url)
                     
                     let saveArray = scrapsToShareData
                     
                     //If some lyrics have been cut, the array can be saved to document
                     saveArray.array = scrapsToShareData.array
                     scrapsDocument.lyricsData = saveArray
                     
                     scrapsDocument.save(to: url, for: .forCreating) { (success) in
                         if success {
                             print("file was saved successfully")
                             print(scrapsDocument.lyricsData?.array)
                             
                         }
                     }


        
        textVC.scraps = scrapsToShareData.array
        
        print(lyricTextView.text!)
        
        


        navigationController?.pushViewController(textVC, animated: true)
        
        
    }
    
    @objc func onRandom() {
            print("Random was pressed")
            
           
            
            let rando = Int.random(in: 0...1600)
            
            let url = "http://www.gutenberg.org/cache/epub/\(rando)/pg\(rando).txt"
            let session = URLSession.shared
            
        activityIN.startAnimating()
            session.dataTask(with: URL(string: url)!) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.lyricTextView.text = "Cut-ups error. Something went wrong, please make sure you are conected to the internet to use the random feature."
                        self.activityIN.stopAnimating()
                    }
                } else {
                    let str = String(decoding: data!, as: UTF8.self)
                    let myString = str.components(separatedBy: .newlines)
                    
                    var randomOne: Int?
                    var randomTwo: Int?
                    var randomThree: Int?
                    
                    if myString.count > 400 {
                        randomOne = Int.random(in: 350...myString.count - 3)
                        randomTwo = (randomOne ?? 0) + 1
                        randomThree = (randomTwo ?? 0) + 2
                    }
                    
                    

                    print(myString[0])

    //                print(myString[7000], myString[7001], myString[7002])
                    DispatchQueue.main.async {
                        self.activityIN.stopAnimating()
                        self.placeholderLabel.text = ""
                       
                        self.lyricTextView.text = "\(myString[randomOne ?? 0]), \(myString[randomTwo ?? 0]), \(myString[randomThree ?? 0])"
                    }
                    
                    
                }
            }.resume()
    }
    
    
    //A function to parse text by carriage returns (by line)
    @objc func automaticCut() {
        lyricTextView.text.enumerateLines { line, _ in
            
            self.scrapsToShareData.array.append(line)

        }
        
       
        
        
        lyricTextView.text = ""
        
        
    }
    
    @objc func onHelp() {
        print("Help Pressed")
        
        let vc = HelpViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

// MARK: VNDocumentCameraViewControllerDelegate

extension TextInputController: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Clear any existing text.
        lyricTextView.text = ""
        // dismiss the document camera
        controller.dismiss(animated: true)
        
        activityIN.isHidden = false
        activityIN.startAnimating()
        
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            }
            DispatchQueue.main.async(execute: {
                self.lyricTextView.text = self.resultingText
                self.placeholderLabel.text = ""
                self.activityIN.isHidden = true
            })
        }

    }
}
