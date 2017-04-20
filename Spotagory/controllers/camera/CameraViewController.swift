//
//  CameraViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/7/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IGAssetsPickerDelegate/*, ImagePickerDelegate*/ {
    
    var onlyPhotoTaken : Bool = false
    var withoutCaption : Bool = false
    var pageTitle : String? = nil
    
    var categoryId : String? = nil
    var categoryName : String? = nil

    @IBOutlet weak var viewCameraContainer: UIView!
    @IBOutlet weak var labelSessionMode: UILabel!
    @IBOutlet weak var buttonTorchMode: UIButton!
    @IBOutlet weak var buttonCameraSwitch: UIButton!
    @IBOutlet weak var buttonSessionMode: UIButton!
    @IBOutlet weak var viewVideoTimer: UIView!
    @IBOutlet weak var labelVideoRecordNote: UILabel!
    @IBOutlet weak var constraintForVideoTimerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelVideoTimer: UILabel!
    @IBOutlet weak var buttonCenterMain: UIButton!
    
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    
    var callback : MediaCallback? = nil
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput : AVCaptureMovieFileOutput?
    var stillImageOutput : AVCaptureStillImageOutput?
    var isVideoMode = false
    var currentCameraPosition : AVCaptureDevicePosition = .Back
    var isRecording = false
    
    var timer = NSTimer()
    var recordStartTime : NSTimeInterval = 0
    @IBOutlet weak var lableHold: UILabel!
    
    private var tempVideoFilePath: NSURL = {
        let tempPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("tempVideo").URLByAppendingPathExtension("mp4").absoluteString
        if NSFileManager.defaultManager().fileExistsAtPath(tempPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(tempPath)
            } catch { }
        }
        return NSURL(string: tempPath)!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        constraintForVideoTimerViewHeight.constant = 0
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        configureWithBackCamera()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        viewCameraContainer.layer.addSublayer(videoPreviewLayer!)
        
        if self.onlyPhotoTaken {
            self.buttonSessionMode.enabled = false
        }
        
        labelCategory.text = categoryName
        
        let text = "Press and hold to record"
        let linkTextColor = "hold"
        
        let range = (text as NSString).rangeOfString(linkTextColor)
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
        lableHold.attributedText = attributedString
        
        self.lableHold.hidden = true
        viewVideoTimer.hidden = true
        
        PostKeeper.keeper.clearKeeper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        session!.startRunning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view bounds \(viewCameraContainer.bounds)")
        
        videoPreviewLayer!.frame = viewCameraContainer.bounds
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        session!.stopRunning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sid_deliver" {
            let controller = segue.destinationViewController as! MediaPreviewViewController
            controller.withoutCaptionInput = self.withoutCaption
            if sender != nil {
                if sender!.isKindOfClass(UIImage) {
                    controller.capturedImage = sender as? UIImage
                } else if sender!.isKindOfClass(NSURL) {
                    controller.videoURL = sender as? NSURL
                }
            }
            controller.callback = self.callback
        }
    }
    
    func configureWithBackCamera() {
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
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
        }
        
        currentCameraPosition = .Back
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        if session!.canAddOutput(stillImageOutput!) {
            session!.addOutput(stillImageOutput!)
        }
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cameraWithPosition(position : AVCaptureDevicePosition) -> AVCaptureDevice? {
        if let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
            for device in devices {
                if device.position == position {
                    return device as? AVCaptureDevice
                }
            }
        }
        
        return nil
    }

    @IBAction func onSwitchCamera(sender: AnyObject) {
        
        if session != nil {
            
            let blurView = UIVisualEffectView(frame: viewCameraContainer!.bounds)
            blurView.effect = UIBlurEffect(style: .Light)
            blurView.alpha = 1
            viewCameraContainer!.addSubview(blurView)
            
            UIView.transitionWithView(viewCameraContainer!, duration: 0.5, options: .TransitionFlipFromLeft, animations: nil) { (finished) -> Void in
                
                self.session!.beginConfiguration()
                
                if let currentInput = self.session!.inputs[0] as? AVCaptureDeviceInput {
                    
                    self.session!.removeInput(currentInput)
                    
                    var newCamera : AVCaptureDevice? = nil
                    if currentInput.device.position == .Back {
                        
                        newCamera = self.cameraWithPosition(.Front)
                        
                        self.currentCameraPosition = .Front
                        
                    } else {
                        
                        newCamera = self.cameraWithPosition(.Back)
                        self.currentCameraPosition = .Back
                        
                    }
                    
                    if newCamera != nil {
                        
                        var error: NSError?
                        var input: AVCaptureDeviceInput!
                        do {
                            input = try AVCaptureDeviceInput(device: newCamera!)
                        } catch let error1 as NSError {
                            error = error1
                            input = nil
                            print(error!.localizedDescription)
                        }
                        
                        if error == nil && self.session!.canAddInput(input) {
                            self.session!.addInput(input)
                        }
                        
                    }
                }
                
                self.session!.commitConfiguration()
                
                UIView.animateWithDuration(0.5, animations: { 
                        blurView.alpha = 0
                    }, completion: { (completed) in
                        blurView.removeFromSuperview()
                })
                
            }
            
        }
        
    }
    
    @IBAction func onFlashMode(sender: AnyObject) {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasFlash {
            do {
                try device.lockForConfiguration()
                if device.flashMode == .On {
                    device.flashMode = .Off
                    buttonTorchMode.setImage(UIImage(named: "icon_camera_flash"), forState: .Normal)
                } else {
                    device.flashMode = .On
                    buttonTorchMode.setImage(UIImage(named: "icon_camera_flash_off"), forState: .Normal)
                }
                device.unlockForConfiguration()
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    @IBAction func onCapture(sender: AnyObject) {
        
        if isVideoMode {
            
            if !isRecording {
                
                
                UIView.transitionWithView(buttonCenterMain,
                                          duration: 0.5,
                                          options: .TransitionCrossDissolve,
                                          animations: { 
                                                self.buttonCenterMain.setImage(UIImage(named: "icon_video_button_recording"), forState: .Normal)
                                            }, completion: { (completed) in
                                                if self.movieFileOutput != nil {
                                                    self.movieFileOutput!.startRecordingToOutputFileURL(self.tempVideoFilePath, recordingDelegate: self)
                                                }
                                                
                                                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.onUpdateTime), userInfo: nil, repeats: true)
                                                self.recordStartTime = NSDate().timeIntervalSince1970
                                                
                                                self.buttonTorchMode.enabled = false
                                                self.buttonCameraSwitch.enabled = false
                                                
                                                self.isRecording = true
                                            })
                
            } else {
                
                UIView.transitionWithView(buttonCenterMain,
                                          duration: 0.5,
                                          options: .TransitionCrossDissolve,
                                          animations: {
                                            
                                            self.buttonCenterMain.setImage(UIImage(named: "icon_video_button"), forState: .Normal)
                                            
                                        }, completion: { (completed) in
                                            
                                            if self.movieFileOutput != nil {
                                                self.movieFileOutput!.stopRecording()
                                            }
                                            
                                            self.timer.invalidate()
                                            
                                            self.isRecording = false
                                            
                                            self.buttonTorchMode.enabled = true
                                            self.buttonCameraSwitch.enabled = true
                                            
                                            self.performSegueWithIdentifier("sid_deliver", sender: self.tempVideoFilePath)
                                            
                                    })
            }
            
        } else {
            
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                videoConnection.videoOrientation = self.videoPreviewLayer!.connection.videoOrientation
                stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                    var originalImage = UIImage(data: imageData)!
                    
                    if self.currentCameraPosition == .Front {
                        originalImage = UIImage(CGImage: originalImage.CGImage!, scale: 1.0, orientation: .LeftMirrored)
                    }
                    
                    let capturedImage = originalImage.fixOrientation()
                    
                    self.performSegueWithIdentifier("sid_deliver", sender: capturedImage)
                    
                })
            }
            
        }
    }
    
    @IBAction func onSessionMode(sender: AnyObject) {
        
        let blurView = UIVisualEffectView(frame: viewCameraContainer!.bounds)
        blurView.effect = UIBlurEffect(style: .Light)
        blurView.alpha = 0
        viewCameraContainer!.addSubview(blurView)
        
        UIView.animateWithDuration(0.1, animations: {
            
                blurView.alpha = 1
            
            }) { (completed) in
                
                if !self.isVideoMode {
                    
                    self.lableHold.hidden = false
                    self.viewCategory.hidden = true
                    self.viewVideoTimer.hidden = false
                    
                    self.isVideoMode = true
                    self.constraintForVideoTimerViewHeight.constant = 100
                    
//                    self.labelVideoRecordNote.alpha = 0
                    self.labelVideoTimer.alpha = 0
                    
                    self.session!.sessionPreset = AVCaptureSessionPresetHigh
                    
                    self.session!.stopRunning()
                    self.session!.beginConfiguration()
                    
                    if self.session!.outputs != nil {
                        for output in self.session!.outputs! {
                            self.session!.removeOutput(output as! AVCaptureOutput)
                        }
                    }
                    
                    if self.movieFileOutput == nil {
                        self.movieFileOutput = AVCaptureMovieFileOutput()
                    }
                    
                    if (self.session!.canAddOutput(self.movieFileOutput) == true) {
                        self.session!.addOutput(self.movieFileOutput)
                    }
                    
                    self.session!.commitConfiguration()
                    self.session!.startRunning()
                    
                    UIView.animateWithDuration(0.5, animations: {
                        self.view.layoutIfNeeded()
                        self.viewCameraContainer.setNeedsLayout()
                        self.viewVideoTimer.setNeedsLayout()
                        self.videoPreviewLayer!.frame = self.viewCameraContainer.bounds
                        
                        }, completion: { completed in
                            
                            self.buttonCenterMain.setImage(UIImage(named: "icon_video_button"), forState: .Normal)
                            self.labelSessionMode.text = "PHOTO"
                            self.buttonSessionMode.setImage(UIImage(named: "icon_camera_photo"), forState: .Normal)
                            
                            UIView.animateWithDuration(0.5, animations: {
//                                self.labelVideoRecordNote.alpha = 1
                                self.labelVideoTimer.alpha = 1
                                blurView.alpha = 0
                                }, completion: { completed in
                                    blurView.removeFromSuperview()
                            })
                            
                    })
                    
                } else {
                    
                    self.lableHold.hidden = true
                    self.viewCategory.hidden = false
                    self.constraintForVideoTimerViewHeight.constant = 0
                    
//                    self.labelVideoRecordNote.alpha = 0
                    self.labelVideoTimer.alpha = 0
                    
                    self.isVideoMode = false
                    self.isRecording = false
                    
                    self.session!.sessionPreset = AVCaptureSessionPresetPhoto
                    
                    self.session!.stopRunning()
                    self.session!.beginConfiguration()
                    
                    if self.session!.outputs != nil {
                        for output in self.session!.outputs! {
                            self.session!.removeOutput(output as! AVCaptureOutput)
                        }
                    }
                    
                    if self.session!.canAddOutput(self.stillImageOutput!) {
                        self.session!.addOutput(self.stillImageOutput!)
                    }
                    
                    self.session!.commitConfiguration()
                    self.session!.startRunning()
                    
                    UIView.animateWithDuration(0.5, animations: {
                        
                        self.view.layoutIfNeeded()
                        self.viewCameraContainer.setNeedsLayout()
                        self.viewVideoTimer.setNeedsLayout()
                        self.videoPreviewLayer!.frame = self.viewCameraContainer.bounds
                        
                        }, completion: { completed in
                            
                            self.buttonCenterMain.setImage(UIImage(named: "icon_camera_button"), forState: .Normal)
                            self.labelSessionMode.text = "VIDEO"
                            self.buttonSessionMode.setImage(UIImage(named: "icon_camera_video"), forState: .Normal)
                            
                            UIView.animateWithDuration(0.5, animations: {
//                                self.labelVideoRecordNote.alpha = 0
                                self.labelVideoTimer.alpha = 0
                                blurView.alpha = 0
                            }, completion: { completed in
                                blurView.removeFromSuperview()
                            })
                    })
                    
                }
        }
        
    }

    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
    }
    
    func onUpdateTime() {
        
        let currentTime = NSDate().timeIntervalSince1970
        let seconds = currentTime - self.recordStartTime
        
        self.labelVideoTimer.text = NSString(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60)) as String
    }
    
    @IBAction func onCameraRoll(sender: AnyObject) {
        let picker = IGAssetsPickerViewController()
        picker.delegate = self
        picker.cropAfterSelect = true
        
        if self.onlyPhotoTaken {
            picker.fetchOptions  = PHFetchOptions()
            picker.fetchOptions.predicate = NSPredicate(format:"mediaType = %d", PHAssetMediaType.Image.rawValue)
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func IGAssetsPickerFinishCroppingToAsset(asset: AnyObject!) {
        if asset.isKindOfClass(UIImage) {
            self.performSegueWithIdentifier("sid_deliver", sender: asset as! UIImage)
        } else if asset.isKindOfClass(NSURL) {
            self.performSegueWithIdentifier("sid_deliver", sender: asset as! NSURL)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true) { 
            self.performSegueWithIdentifier("sid_deliver", sender: image)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage]) {
//        self.performSegueWithIdentifier("sid_deliver", sender: images[0])
//    }
//    
//    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage]) {
//        self.performSegueWithIdentifier("sid_deliver", sender: images[0])
//    }
//    
//    func cancelButtonDidPress(imagePicker: ImagePickerController) {
//        
//    }
    
}
