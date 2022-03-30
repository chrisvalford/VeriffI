/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller for unstructured text.
*/

import UIKit
import Vision

class ScanDocumentViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView?
    var transcript = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.text = transcript
    }
}
// MARK: RecognizedTextDataSource
extension ScanDocumentViewController: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        // Create a full transcript to run analysis on.
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            transcript += candidate.string
            transcript += "\n"
        }
        textView?.text = transcript
    }
}
