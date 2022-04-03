/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 View controller from which to invoke the document scanner.
 */

import UIKit
import VeriffLib
import VisionKit
import Vision

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scanDocumentImage: UIImageView!
    @IBOutlet weak var scanDocumentButton: UIButton!
    @IBOutlet weak var scanFaceImage: UIImageView!
    @IBOutlet weak var scanFaceButton: UIButton!
    @IBOutlet weak var startValidation: UIButton!
    @IBOutlet weak var noCameraView: NoCameraView!
    
    lazy var libStoryboard: UIStoryboard = {
        let storyboard = UIStoryboard(name: "SDK", bundle: VeriffLib.libBundle)
        return storyboard
    }()
    
    private var faceImage: Data?
    private var documentImage: Data?
    private var landmarks: VNFaceObservation?
    private var texts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            scanDocumentButton.isEnabled = false
            scanFaceButton.isEnabled = false
            startValidation.isEnabled = false
            noCameraView.title = "Your device doesn't have a camera."
            noCameraView.message = "You need a camera to scan your documents and face."
            noCameraView.isHidden = false
            noCameraView.layoutSubviews()
        }
    }
    
    @IBAction func documentTapped(_ sender: UIButton) {
        guard let scanDocumentViewController = libStoryboard.instantiateViewController(withIdentifier: "scanDocumentViewController") as? ScanDocumentViewController else { return }
        scanDocumentViewController.modalPresentationStyle = .fullScreen
        scanDocumentViewController.modalTransitionStyle = .coverVertical
        scanDocumentViewController.delegate = self
        show(scanDocumentViewController, sender: self)
        //self.present(scanDocumentViewController, animated: false, completion: nil)
    }
    
    @IBAction func faceTapped(_ sender: UIButton) {
        guard let scanFaceViewController = libStoryboard.instantiateViewController(withIdentifier: "scanFaceViewController") as? ScanFaceViewController else { return }
        scanFaceViewController.modalPresentationStyle = .fullScreen
        scanFaceViewController.modalTransitionStyle = .coverVertical
        scanFaceViewController.delegate = self
        self.present(scanFaceViewController, animated: true, completion: nil)
    }
    
    @IBAction func validateTapped(_ sender: UIButton) {
        var documentValidated = false
        var faceValidated = false
        
        guard let data = faceImage, let landmarks = landmarks else {
            return
        }
        VerifyRemote.verifyIdentity(imageData: data, landMarks: landmarks, completion: { (state, error) in
            if state == .verified {
                print("Face recognized Ok")
                faceValidated = true
                if faceValidated && documentValidated {
                    self.startValidation.setTitle("Validated ✔️", for: .normal)
                }
            }
        })
        
        guard let data = documentImage else {
            return
        }
        VerifyRemote.verifyDocument(imageData: data, texts: texts, completion: { (state, error) in
            if state == .verified {
                print("Document recognized Ok")
                documentValidated = true
                if faceValidated && documentValidated {
                    self.startValidation.setTitle("Validated ✔️", for: .normal)
                }
            }
        })
    }
    
    private func shouldEnableValidation() {
        guard let _ = faceImage, let _ = documentImage else {
            return
        }
        startValidation.isEnabled = true
    }
}

extension HomeViewController: ScanFaceDelegate {
    func scanCompleted(imageData: Data, landmarks: VNFaceObservation) {
        faceImage = imageData
        self.landmarks = landmarks
        scanFaceImage.image = UIImage(data: imageData)
        shouldEnableValidation()
    }
}

extension HomeViewController: ScanDocumentDelegate {
    func scanCompleted(imageData: Data, texts: [String]) {
        documentImage = imageData
        self.texts = texts
        scanDocumentImage.image = UIImage(data: imageData)
        shouldEnableValidation()
    }
}
