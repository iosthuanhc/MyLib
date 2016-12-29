//
//  ViewController.swift
//  TestAVCapture
//
//  Created by HA CONG THUAN on 12/29/16.
//  Copyright © 2016 HA CONG THUAN. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var overLayImage: UIImageView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setup your camera here...
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            // ...
            // The remainder of the session setup will go here...
        }
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if session!.canAddOutput(stillImageOutput) {
            session!.addOutput(stillImageOutput)
            // ...
            // Configure the Live Preview here...
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        mainView.layer.addSublayer(videoPreviewLayer!)
        session!.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = overLayImage.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takephoto_Tap(_ sender: Any) {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    if let cameraImage = UIImage(data: imageData) {
                        self.overLayImage.image = cameraImage
                        //UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                    }
                }
            })
        }
    }

}

