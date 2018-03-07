//
//  STBasicInfoViewController.swift
//  st_ring
//
//  Created by euisuk_lee on 2017. 9. 18..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Photos

class STBasicInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ContentsView: UIView!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var uploadCollection: UICollectionView!
    @IBOutlet weak var gunBariLabel: UILabel!
    @IBOutlet weak var gunBarI: UISegmentedControl!
    @IBOutlet weak var gunBarICheck: UIView!
    @IBOutlet weak var schoolTextfield: selectTextField!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var schoolCheck: UIView!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var specialtyTextfield: UITextField!
    @IBOutlet weak var specialtyCheck: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextfield: selectTextField!
    @IBOutlet weak var locationCheck: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightTextfield: selectTextField!
    @IBOutlet weak var heightCheck: UIView!
    @IBOutlet weak var bodyCheck: UIView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bodyTextfield: selectTextField!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var smokeSegmented: UISegmentedControl!
    @IBOutlet weak var smokeCheck: UIView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinkTextfield: selectTextField!
    @IBOutlet weak var drinkCheck: UIView!
    @IBOutlet weak var religionTextfield: selectTextField!
    @IBOutlet weak var religionCheck: UIView!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var bloodTextfield: selectTextField!
    @IBOutlet weak var bloodCheck: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var BasicInfoLabel: UILabel!
    @IBOutlet weak var sexCheck: UIView!
    @IBOutlet weak var birthCheck: UIView!
    @IBOutlet weak var gunbariGuideLabel: UILabel!
    @IBOutlet weak var birthTextField: selectTextField!
    @IBOutlet weak var sexSegmented: UISegmentedControl!
    @IBOutlet weak var NextBtnLocation: NSLayoutConstraint!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var religionLabel: UILabel!
    
    let gunbariArray = ["군필", "미필", "해당없음"]
    let schoolArray = ["인서울상위", "인서울4년제", "수도권4년제", "4년제", "전문대", "해외대학", "고등학교"]
    let locationArray = ["서울", "부산", "인천", "광주", "울산", "대전", "대구", "경기", "강원", "경남", "경북", "충북", "충남", "전북", "전남"]
    let heightArray:[Int] = Array(140...200)
    let bloodArray = ["A", "B", "O", "AB"]
    let MbodyArray = ["마름", "슬림", "보통", "근육질", "통통한"]
    let WbodyArray = ["마름", "슬림", "보통", "글래머", "통통한"]
    let drinkArray = ["알코올 몰라요", "적당히즐김", "술고래"]
    let religionArray = ["무교", "기독교", "불교", "천주교", "기타"]
    var profilImg : [UIImage?] = [nil, nil, nil, nil, nil, nil]
    let uploadLabel : [String] = [
        "메인 사진\n(필수)",
        "전신 사진\n(선택)",
        "프로필 사진1 \n(필수)",
        "프로필 사진2 \n(필수)",
        "프로필 사진3 \n(선택)",
        "프로필 사진4 \n(선택)"
    ]
    let toolBar = UIToolbar()
    let cellPicker = UIImagePickerController()

    var birthPicker = UIDatePicker()
    var defualtPicker = UIPickerView()
    var schoolPicker = UIPickerView()
    var locationPicker = UIPickerView()
    var heightPicker = UIPickerView()
    var bloodPicker = UIPickerView()
    var drinkPicker = UIPickerView()
    var religionPicker = UIPickerView()
    var MbodyPicker = UIPickerView()
    var WbodyPicker = UIPickerView()
    var currentIndexPathrow : Int!
    var nextBtnYLocation:CGPoint!
    var sex = Bool()
    var email = String()
    var pw = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.image = UIImage(named: "backbtn")
        newBackButton.tintColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
        
        self.nextBtn.layer.cornerRadius = 10
        self.gunBarICheck.layer.cornerRadius = 5
        self.schoolCheck.layer.cornerRadius = 5
        self.specialtyCheck.layer.cornerRadius = 5
        self.locationCheck.layer.cornerRadius = 5
        self.heightCheck.layer.cornerRadius = 5
        self.bloodCheck.layer.cornerRadius = 5
        self.bodyCheck.layer.cornerRadius = 5
        self.smokeCheck.layer.cornerRadius = 5
        self.drinkCheck.layer.cornerRadius = 5
        self.religionCheck.layer.cornerRadius = 5
        self.birthCheck.layer.cornerRadius = 5
        self.sexCheck.layer.cornerRadius = 5
        
        schoolPicker.delegate = self
        locationPicker.delegate = self
        heightPicker.delegate = self
        bloodPicker.delegate = self
        drinkPicker.delegate = self
        religionPicker.delegate = self
        MbodyPicker.delegate = self
        WbodyPicker.delegate = self
        specialtyTextfield.delegate = self
        uploadCollection.delegate = self
        uploadCollection.dataSource = self
        
        schoolTextfield.inputView = schoolPicker
        locationTextfield.inputView = locationPicker
        heightTextfield.inputView = heightPicker
        drinkTextfield.inputView = drinkPicker
        religionTextfield.inputView = religionPicker
        bloodTextfield.inputView = bloodPicker
        birthTextField.inputView = birthPicker
        bodyTextfield.inputView = MbodyPicker
        birthPicker.datePickerMode = .date
        birthPicker.locale = NSLocale.init(localeIdentifier: "ko") as Locale
        
        self.toolBar.barStyle = .default
        self.toolBar.isTranslucent = true
        self.toolBar.sizeToFit()
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = UIColor.mainGray
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolBar.setItems([spaceButton, doneButton], animated: false)
        self.toolBar.isUserInteractionEnabled = true
        
        let textFieldArray = [schoolTextfield, specialtyTextfield,  locationTextfield, heightTextfield, bodyTextfield, drinkTextfield, religionTextfield, bloodTextfield, birthTextField]
        
        for i in textFieldArray {
            i?.delegate = self
            i?.inputAccessoryView = self.toolBar
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "1998-01-01")
        birthPicker.date = date!
        
        if (UIScreen.main.bounds.height == 568) {
            self.bodyLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.bloodLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.specialtyLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.drinkLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.smokeLabel.font =  UIFont(name: "NanumSquare", size: 11)
            self.heightLabel.font =  UIFont(name: "NanumSquare", size: 11)
            self.schoolLabel.font =  UIFont(name: "NanumSquare", size: 11)
            self.locationLabel.font =  UIFont(name: "NanumSquare", size: 11)
            self.gunBariLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.gunbariGuideLabel.font = UIFont(name: "NanumSquare", size: 8)
            self.religionLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.birthLabel.font = UIFont(name: "NanumSquare", size: 11)
            self.sexLabel.font = UIFont(name: "NanumSquare", size: 11)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.schoolPicker){
            return schoolArray.count
        } else if (pickerView == self.locationPicker){
            return locationArray.count
        } else if (pickerView == self.heightPicker) {
            return heightArray.count
        } else if (pickerView == self.bloodPicker) {
            return bloodArray.count
        } else if (pickerView == self.drinkPicker) {
            return drinkArray.count
        } else if (pickerView == self.religionPicker) {
            return religionArray.count
        } else if (pickerView == self.MbodyPicker) {
            return MbodyArray.count
        } else if (pickerView == self.WbodyPicker) {
            return WbodyArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == self.schoolPicker){
            return schoolArray[row]
        } else if (pickerView == self.locationPicker){
            return locationArray[row]
        } else if (pickerView == self.heightPicker) {
            return String(describing: heightArray[row])
        } else if (pickerView == self.bloodPicker) {
            return bloodArray[row]
        } else if (pickerView == self.drinkPicker) {
            return drinkArray[row]
        } else if (pickerView == self.religionPicker) {
            return religionArray[row]
        } else if (pickerView == self.MbodyPicker) {
            return MbodyArray[row]
        } else if (pickerView == self.WbodyPicker) {
            return WbodyArray[row]
        } else {
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == self.schoolPicker){
            self.schoolTextfield.text = schoolArray[row]
        } else if (pickerView == self.locationPicker){
            self.locationTextfield.text = self.locationArray[row]
        } else if (pickerView == self.heightPicker) {
            self.heightTextfield.text = String(describing: heightArray[row]) + " cm"
        } else if (pickerView == self.bloodPicker) {
            self.bloodTextfield.text = bloodArray[row]
        } else if (pickerView == self.drinkPicker) {
            self.drinkTextfield.text = drinkArray[row]
        } else if (pickerView == self.religionPicker) {
            self.religionTextfield.text = religionArray[row]
        } else if (pickerView == self.MbodyPicker) {
            self.bodyTextfield.text = MbodyArray[row]
        } else if (pickerView == self.WbodyPicker) {
            self.bodyTextfield.text = WbodyArray[row]
        } else {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgUploadCollectionViewCell", for: indexPath)
            as! imgUploadCollectionViewCell
        
        cell.cellImg.layer.cornerRadius = 15
        cell.cellImg.layer.borderWidth = 1
        cell.CellLabel.text! = uploadLabel[indexPath.row]
        cell.cellBtn.addTarget(self, action: #selector(self.uploadCell), for: .touchUpInside)
        cell.cellImg.image = profilImg[indexPath.row]
        cell.cellBtn.tag = indexPath.row
        cell.defualtImg.isHidden = false
        cell.CellLabel.isHidden = true
        if(cell.cellImg.image != nil) {
            cell.CellLabel.isHidden = true
            cell.defualtImg.isHidden = true
        }
        if indexPath.row < 2 {
            cell.cellImg.layer.borderColor = UIColor.mainYello.cgColor
            cell.defualtImg.image = UIImage(named: "addPink")
        } else {
            cell.cellImg.layer.borderColor = UIColor.mainGray.cgColor
            cell.defualtImg.image = UIImage(named: "addGray")
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: uploadCollection.frame.size.height + 50, height: uploadCollection.frame.size.height)
        } else {
            return CGSize(width: uploadCollection.frame.size.height, height: uploadCollection.frame.size.height)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let a = currentIndexPathrow {
            profilImg[a] = chosenImage
        }
        uploadCollection.reloadData()
        CheckInput()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        let scrollPoint : CGPoint = CGPoint(x : 0, y: self.specialtyTextfield.frame.origin.y)
        self.ScrollView.setContentOffset(scrollPoint, animated: true)
        
        if textField.text != "" {
            if textField == schoolTextfield {
                schoolCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == specialtyTextfield {
                specialtyCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == locationTextfield {
                locationCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == heightTextfield {
                heightCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == bloodTextfield {
                bloodCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == bodyTextfield {
                bodyCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == drinkTextfield {
                drinkCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == religionTextfield {
                religionCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if textField == birthTextField {
                birthCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
            }
            
            if(specialtyTextfield.text == "") {
                specialtyCheck.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
            }
        }
        CheckInput()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint(x : 0, y: textField.frame.origin.y)
        self.ScrollView.setContentOffset(scrollPoint, animated: true)
        
        if textField.text! == ""{
            if (textField == schoolTextfield){
                schoolTextfield.text = schoolArray[0]
            } else if (textField == locationTextfield) {
                locationTextfield.text = locationArray[0]
            } else if (textField == heightTextfield) {
                if sex == true {
                    heightTextfield.text = "173 cm"
                } else {
                    heightTextfield.text = "160 cm"
                }
            } else if (textField == bodyTextfield) {
                bodyTextfield.text = MbodyArray[0]
            } else if (textField == drinkTextfield) {
                drinkTextfield.text = drinkArray[0]
            } else if (textField == religionTextfield) {
                religionTextfield.text = religionArray[0]
            } else if (textField == bloodTextfield) {
                bloodTextfield.text = bloodArray[0]
            } else if (textField == birthTextField) {
                birthPicker.addTarget(self, action: #selector(datePickerValueSet), for: UIControlEvents.valueChanged)
                birthTextField.text = "1998-01-01"
            } else if (textField == specialtyTextfield) {
                specialtyTextfield.text = ""
            }
        }
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    
    @IBAction func gunBaRi(_ sender: Any) {
        gunBarICheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
        CheckInput()
    }
    
    @IBAction func smoke(_ sender: Any) {
        smokeCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
        CheckInput()
    }
    
    @IBAction func sex(_ sender: Any) {
        sexCheck.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0)
        
        if(sexSegmented.selectedSegmentIndex == 0){
            bodyTextfield.inputView = MbodyPicker
            gunBarI.isHidden = false
            gunBariLabel.isHidden = false
            gunBarICheck.isHidden = false
            gunbariGuideLabel.isHidden = false
            heightPicker.selectRow(33, inComponent: 0, animated: true)
            NextBtnLocation.constant = 77
            self.sex = true
        } else {
            gunBarI.isHidden = true
            gunBariLabel.isHidden = true
            gunBarICheck.isHidden = true
            gunbariGuideLabel.isHidden = true
            bodyTextfield.inputView = WbodyPicker
            heightPicker.selectRow(20, inComponent: 0, animated: true)
            NextBtnLocation.constant = 30
            self.sex = false
        }
        CheckInput()
    }
    
    
    @objc func tapView() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let QAView = self.storyboard?.instantiateViewController(withIdentifier: "STQAViewController") as! STQAViewController
        let index = self.heightTextfield.text?.index((self.heightTextfield.text?.startIndex)!, offsetBy: 3)
        let height = self.heightTextfield.text?.substring(to: index!)
        
        var UserBasicInfo = basicInfo()
        UserBasicInfo.email = self.email
        UserBasicInfo.password = self.pw
        UserBasicInfo.login_format = UserDefaults.standard.string(forKey: "login_format")
        UserBasicInfo.birthday = self.birthTextField.text!
        UserBasicInfo.education = (self.schoolTextfield?.text)!
        UserBasicInfo.department = (self.specialtyTextfield?.text)!
        UserBasicInfo.location = (self.locationTextfield?.text)!
        UserBasicInfo.height = height
        UserBasicInfo.body_form = (self.bodyTextfield?.text)!
        if self.smokeSegmented.titleForSegment(at: self.smokeSegmented.selectedSegmentIndex) == "흡연자" {
            UserBasicInfo.smoke = true
        } else {
            UserBasicInfo.smoke = false
        }
        UserBasicInfo.drink = (self.drinkTextfield?.text)!
        UserBasicInfo.religion = (self.religionTextfield?.text)!
        UserBasicInfo.blood_type = (self.bloodTextfield?.text)!
        UserBasicInfo.fcm_token = UserDefaults.standard.string(forKey: "fcm_token")
        QAView.profileImg = self.profilImg
        if sex {
            QAView.sex = "male"
            UserBasicInfo.military_service_status = self.gunBarI.titleForSegment(at: self.gunBarI.selectedSegmentIndex)!
        } else {
            QAView.sex = "female"
        }
        QAView.userBasicInfo = UserBasicInfo
        self.navigationController?.pushViewController(QAView, animated: true)
    }
    
    @objc func uploadCell(sender : UIButton) {
        cellPicker.allowsEditing = false
        cellPicker.sourceType = .photoLibrary
        cellPicker.delegate = self
        self.currentIndexPathrow = sender.tag
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: self.present(cellPicker, animated: true, completion: nil)
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                self.present(self.cellPicker, animated: true, completion: nil)
                
            }
        })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.")
        }
    }
    
    @objc func backAction() {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: "입력하신내용은 저장되지 않습니다. \n되돌아가시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func datePickerValueSet(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func CheckInput() {
        let indicatorArray = [sexCheck, birthCheck, schoolCheck, specialtyCheck, locationCheck, heightCheck, bloodCheck, bodyCheck, smokeCheck, drinkCheck, religionCheck]
        var rightCounter = 0
        var imageCounter = 0
        for i in indicatorArray {
            if i?.backgroundColor == UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1.0) {
                rightCounter += 1
            }
        }
        
        for i in profilImg {
            if i != nil {
                imageCounter += 1
            }
        }
        
        if (rightCounter==11 && imageCounter >= 2) {
            self.nextBtn.isEnabled = true
            self.nextBtn.backgroundColor = UIColor.mainYello
        }
    }
}
