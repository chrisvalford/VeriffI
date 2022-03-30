/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller from which to invoke the document scanner.
*/

import UIKit
import VisionKit
import Vision

class HomeViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let faceLandmarkIdentifier = "faceLandmarkVC"
    static let scanDocumentIdentifier = "scanDocumentVC"

    enum ScanMode: Int, CustomStringConvertible {
        case face = 0
        case document
        
        var description: String {
            switch self {
            case .face:
                return "faceLandmarkVC"
            case .document:
                return "scanDocumentVC"
            }
        }
    }
    
    var scanMode: ScanMode = .document
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let resultsViewController = self.resultsViewController else {
                print("resultsViewController is not set")
                return
            }
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        resultsViewController.addRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
    }

    @IBAction func scan(_ sender: UIControl) {
        guard let scanMode = ScanMode(rawValue: sender.tag) else { return }
        self.scanMode = scanMode
        if scanMode == .document {
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            present(documentCameraViewController, animated: true)
        } else {
            // "faceLandmarkVC"
            guard let faceLandmarkVC = self.storyboard?.instantiateViewController(withIdentifier: ScanMode.face.description) else {
                return
            }
            self.present(faceLandmarkVC, animated: true)
        }
    }
    
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
}

extension HomeViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var vcID: String?
        
        //TODO: replace with ScanMode enum description
        switch scanMode {
        case .face:
            vcID = HomeViewController.faceLandmarkIdentifier
        default:
            vcID = HomeViewController.scanDocumentIdentifier
        }
        
        if let vcID = vcID {
            resultsViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? (UIViewController & RecognizedTextDataSource)
        }
        
        self.activityIndicator.startAnimating()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultsVC = self.resultsViewController {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
