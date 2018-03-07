//
//  STWhiteMemberViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 19..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import Alamofire
import SwiftyJSON

class STWhiteMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var xHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var idButton: UIImageView!
    @IBOutlet weak var SMSButton: UIButton!
    @IBOutlet weak var idImageView: UIImageView!
    
    let idImgPicker = UIImagePickerController()
    var idImg: UIImage?
    var isSMS = false
    var isIdCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idImgPicker.allowsEditing = false
        idImgPicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(STWhiteMemberViewController.tapIDPicker))
        idButton.isUserInteractionEnabled = true
        idButton.addGestureRecognizer(gesture)
        
        //set layout
        SMSButton.layer.shadowColor = UIColor.gray.cgColor
        SMSButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        SMSButton.layer.shadowRadius = 10
        SMSButton.layer.shadowOpacity = 0.2
        
        idButton.layer.shadowColor = UIColor.gray.cgColor
        idButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        idButton.layer.shadowRadius = 10
        idButton.layer.shadowOpacity = 0.2
        
        idImageView.layer.cornerRadius = 5
        
        doneBtn.backgroundColor = .mainGray
        doneBtn.setTitleColor(UIColor.darkGray, for: .normal)
        doneBtn.isEnabled = false
        
        if (UIScreen.main.bounds.height == 812) {
            xHeightConstraint.constant += 34
            doneBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        }
        
        if UserDefaults.standard.bool(forKey: "whiteMemberDone") {
            let alert = UIAlertController(title: "신청완료", message: "화이트 맴버 신청을 완료하셨습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { handler in
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            }))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SMSCertificationAction(_ sender: Any) {
        let WebView = self.storyboard?.instantiateViewController(withIdentifier: "STSMSConfirmViewController")
        
        self.present(WebView!, animated: true, completion: nil)
    }

    @IBAction func CloseAction(_ sender: Any) {
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        idImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        idButton.image = UIImage(named: "idDoneButton")
        idImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        isIdCard = true
        checkInvaild()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapIDPicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: {handler in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: {handler in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func certificationAction(_ sender: Any) {
        if let _ = idImg {
            uploadIDCard()
        }
    }
    
    func openLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        idImgPicker.sourceType = .photoLibrary
        switch status {
        case .authorized: self.present(idImgPicker, animated: true, completion: nil)
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                self.present(self.idImgPicker, animated: true, completion: nil)
                
            }
        })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.")
        }
    }
    
    func openCamera() {
        idImgPicker.sourceType = .camera
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.present(idImgPicker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    self.present(self.idImgPicker, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "카메라 사용", message: "카메라를 사용하려면, [설정 > 개인 정보 보호 > 카메라]에서 스트링 카메라 사용을 허용해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func uploadIDCard() {
        let url = String.domain! + "information/register/id-card-image/"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String.myId!,
            "account-sex" : String.mySex!
        ]
        
        let URI = try! URLRequest(url: url, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: {MultipartFormData in
            self.addImageData(multipartFormData: MultipartFormData, image: self.idImg!)
        }, with: URI, encodingCompletion: {result in
            switch result {
            case .success(let upload, _, _):
                print(result)
                upload.responseJSON { response in
                    let JSONresult = JSON(response.result.value)
                    let result = JSONresult["result"].boolValue
                    
                    if result {
                        UserDefaults.standard.set(true, forKey: "whiteMemberDone")
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(_):
                print(result)
            }
        })
    }
    
    private func addImageData(multipartFormData: MultipartFormData, image: UIImage){
        let data = image.jpeg(image, .low)

        multipartFormData.append(data!, withName: "image",fileName: "image.jpg", mimeType: "image/jpeg")
    }
    
    func checkInvaild() {
        if isIdCard && isSMS {
            doneBtn.isEnabled = true
            doneBtn.backgroundColor = UIColor.mainYello
        }
    }
}
