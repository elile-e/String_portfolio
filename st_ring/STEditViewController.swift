//
//  STEditViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 12. 28..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Photos
import KRWordWrapLabel
import SwiftyJSON
import Alamofire

class STEditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var schoolTextField: selectTextField!
    @IBOutlet weak var careerTextfield: UITextField!
    @IBOutlet weak var locationTextField: selectTextField!
    @IBOutlet weak var heightTextField: selectTextField!
    @IBOutlet weak var bloodTextField: selectTextField!
    @IBOutlet weak var bodyTextField: selectTextField!
    @IBOutlet weak var drinkTextField: selectTextField!
    @IBOutlet weak var religionTextField: selectTextField!
    @IBOutlet weak var smokeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputBar: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ScrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    let gunbariArray = ["군필", "미필", "해당없음"]
    let schoolArray = ["인서울상위", "인서울4년제", "수도권4년제", "4년제", "전문대", "해외대학", "고등학교"]
    let locationArray = ["서울", "부산", "인천", "광주", "울산", "대전", "대구", "경기", "강원", "경남", "경북", "충북", "충남", "전북", "전남"]
    let heightArray:[Int] = Array(140...200)
    let bloodArray = ["A", "B", "O", "AB"]
    let MbodyArray = ["마름", "슬림", "보통", "근육질", "통통한"]
    let WbodyArray = ["마름", "슬림", "보통", "글래머", "통통한"]
    let drinkArray = ["알코올 몰라요", "적당히즐김", "술고래"]
    let religionArray = ["무교", "기독교", "불교", "천주교", "기타"]
    let cellPicker = UIImagePickerController()
    let toolBar = UIToolbar()
    
    var basicInfoProfile = basicInfo()
    var fullProfile: fullProfile?
    var QAMessage = [message]()
    var sex : String?
    var currentEditMessage : IndexPath?
    var jsonProfile = JSON()
    var editingImgArray = [editImage]()
    var editImgArray = [editImage]()
    var editQAArray = [message]()
    var editingQAArray = [message]()
    var approvedImgCount = 0
    var editCategory = 0
    var editCounter = 0
    
    
    var profilImg: [UIImage?] = [nil, nil, nil, nil, nil, nil]
    var currentIndexPathrow : Int!
    var schoolPicker = UIPickerView()
    var locationPicker = UIPickerView()
    var heightPicker = UIPickerView()
    var bloodPicker = UIPickerView()
    var drinkPicker = UIPickerView()
    var religionPicker = UIPickerView()
    var MbodyPicker = UIPickerView()
    var WbodyPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate, datasource
        CollectionView.delegate = self
        CollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        schoolPicker.delegate = self
        locationPicker.delegate = self
        heightPicker.delegate = self
        bloodPicker.delegate = self
        drinkPicker.delegate = self
        religionPicker.delegate = self
        MbodyPicker.delegate = self
        WbodyPicker.delegate = self
        inputTextView.delegate = self
        
        schoolTextField.inputView = schoolPicker
        locationTextField.inputView = locationPicker
        heightTextField.inputView = heightPicker
        drinkTextField.inputView = drinkPicker
        religionTextField.inputView = religionPicker
        bloodTextField.inputView = bloodPicker
        bodyTextField.inputView = MbodyPicker
        
        //set toolbar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let textFielArray = [schoolTextField, careerTextfield, locationTextField, heightTextField, bloodTextField, bodyTextField, drinkTextField, religionTextField]
        
        for i in textFielArray {
            i?.delegate = self
            i?.inputAccessoryView = toolBar
        }
        
        //set ui
        if (UIScreen.main.bounds.height == 812) {
            doneHeight.constant += 34
            doneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
        
        bodyTextField?.text! = self.jsonProfile["body_form"].stringValue
        bloodTextField?.text! = self.jsonProfile["blood_type"].stringValue
        heightTextField?.text! = self.jsonProfile["height"].stringValue + "cm"
        careerTextfield?.text! = self.jsonProfile["department"].stringValue
        schoolTextField?.text! = self.jsonProfile["education"].stringValue
        drinkTextField?.text! = self.jsonProfile["drink"].stringValue
        religionTextField?.text! = self.jsonProfile["religion"].stringValue
        locationTextField?.text! = self.jsonProfile["location"].stringValue
        
        if self.jsonProfile["smoke"].boolValue {
            smokeSegmentedControl?.selectedSegmentIndex = 1
        } else {
            smokeSegmentedControl?.selectedSegmentIndex = 0
        }
        
        tableViewHeight.constant = CGFloat(estimateTableViewHeight(text: QAMessage))
        tableView.layoutIfNeeded()
        tableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        inputBar.isHidden = true
        inputTextView.layer.borderColor = UIColor.mainGray.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 15
        sendButton.backgroundColor = .mainGray
        sendButton.layer.cornerRadius = 6
        
        //set notification
        NotificationCenter.default.addObserver(self, selector: #selector(STEditViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STEditViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgUploadCollectionViewCell", for: indexPath) as! imgUploadCollectionViewCell
        let tapgesture = targetTapGestureRecognizer(target: self, action: #selector(self.uploadCell(sender:)))
        tapgesture.target = indexPath.row
        
        cell.cellBtn.addGestureRecognizer(tapgesture)
        cell.cellImg.layer.cornerRadius = 15
        cell.cellImg.layer.borderWidth = 1
        
        cell.cellImg.image = self.profilImg[indexPath.row]
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
        
        for i in editImgArray {
            if i.index == indexPath.row {
                cell.cellImg.image = i.image
                cell.defualtImg.isHidden = true
                cell.blurView.layer.cornerRadius = 15
                cell.blurView.isHidden = false
                cell.isUserInteractionEnabled = false
                break
            } else {
                cell.blurView.isHidden = true
                cell.isUserInteractionEnabled = true
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.size.height + 50, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var textWidth : CGSize = estimateFrameForText(QAMessage[indexPath.row].text!)
        
        if QAMessage[indexPath.row].sex != self.sex!{
            let cell = MYEditTableViewCell(style: .default, reuseIdentifier: "MYEditTableViewCell")
            
            cell.textView.text! = QAMessage[indexPath.row].text!
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
            cell.selectionStyle = .none
            if textWidth.width > 100 {
                cell.bubbleWidthAnchor?.constant = textWidth.width + 35
            } else {
                cell.bubbleWidthAnchor?.constant = 100 + 35
                cell.textView.textAlignment = .center
            }
            
            for i in editQAArray {
                if i.question_id == QAMessage[indexPath.row].question_id {
                    cell.textView.text! = i.text!
                    cell.editButton.setTitle("심사중", for: .normal)
                    cell.editButton.isEnabled = false
                    textWidth = estimateFrameForText(i.text!)
                    if textWidth.width > 100 {
                        cell.bubbleWidthAnchor?.constant = textWidth.width + 35
                    } else {
                        cell.bubbleWidthAnchor?.constant = 100 + 35
                        cell.textView.textAlignment = .center
                    }
                    break
                }
            }
            
            cell.textView.sizeToFit()
            return cell
        } else {
            let cell = OtherTableViewCell(style: .default, reuseIdentifier: "OtherTableViewCell")
            cell.textView.text! = QAMessage[indexPath.row].text!
            cell.textView.sizeToFit()
            cell.bubbleWidthAnchor?.constant = textWidth.width + 35
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        
        if QAMessage[indexPath.row].sex != self.sex {
            if editQAArray.count > 0 {
                for i in editQAArray {
                    if (QAMessage[indexPath.row].question_id! == i.question_id!) {
                        height = estimateFrameForText(i.text!).height + 50
                    } else {
                        height = estimateFrameForText(QAMessage[indexPath.row].text!).height + 50
                    }
                }
            } else {
                height = estimateFrameForText(QAMessage[indexPath.row].text!).height + 50
            }
        } else {
            height = estimateFrameForText(QAMessage[indexPath.row].text!).height + 25
        }
        
        return height
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
        if pickerView == self.schoolPicker {
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
            schoolTextField.text = schoolArray[row]
        } else if (pickerView == self.locationPicker){
            locationTextField.text = locationArray[row]
        } else if (pickerView == self.heightPicker) {
            heightTextField.text = String(describing: heightArray[row]) + "cm"
        } else if (pickerView == self.bloodPicker) {
            bloodTextField.text = bloodArray[row]
        } else if (pickerView == self.drinkPicker) {
            drinkTextField.text = drinkArray[row]
        } else if (pickerView == self.religionPicker) {
            religionTextField.text = religionArray[row]
        } else if (pickerView == self.MbodyPicker) {
            bodyTextField.text = MbodyArray[row]
        } else if (pickerView == self.WbodyPicker) {
           bodyTextField.text = WbodyArray[row]
        } else {
            return
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var editMax = 0
        var editingMax = 0
        if editingImgArray.count > 0 {
            let editingSortedArray = editingImgArray.sorted() {a , b in a.index! > b.index!}
            editingMax = editingSortedArray[0].index!
        }
        
        if editImgArray.count > 0 {
            let editSortedArray = editImgArray.sorted() {a , b in a.index! > b.index!}
            editMax = editSortedArray[0].index!
        }
        
        let counts = [editMax, editingMax, approvedImgCount]
        let updateInt = counts.sorted() {$0 > $1}
        
        if let a = currentIndexPathrow {
            if a < updateInt[0] {
                profilImg[a] = chosenImage
                if editingImgArray.count == 0 {
                    editingImgArray.append(editImage(index: currentIndexPathrow, image: chosenImage))
                } else {
                    
                }
            } else {
                var editMax = 0
                var profileMax = 0
                
                for (index, i) in profilImg.enumerated() {
                    if i == nil {
                        profileMax = index - 1
                        break
                    }
                }
                
                for i in editImgArray {
                    if editMax < i.index! {
                        editMax = i.index!
                    }
                }
                
                let Max = editMax > profileMax ? editMax : profileMax
                
                editingImgArray.append(editImage(index: Max + 1, image: chosenImage))
                profilImg[Max + 1] = chosenImage
            }
        }
        CollectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.inputTextView.text = ""
        self.inputTextView.textColor = .black
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if self.inputTextView.text == "" {
            self.inputTextView.text = "질문에 응답해주세요! (5자 이상)"
            self.inputTextView.textColor = .lightGray
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if (self.inputTextView.text == "") {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else if (self.inputTextView.text == "질문에 응답해주세요! (5자 이상") {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else if self.inputTextView.text!.count < 5 {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else {
            self.sendButton.isEnabled = true
            self.sendButton.backgroundColor = .mainYello
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint(x : 0, y: textField.frame.origin.y)
        ScrollView.setContentOffset(scrollPoint, animated: true)
        ScrollViewBottom.constant = (UIScreen.main.bounds.height == 812) ? -79 : -45
        doneButton.isHidden = true
        inputBar.isHidden = true
        
        if textField.text! == ""{
            if textField == schoolTextField {
                schoolTextField.text = schoolArray[0]
            } else if textField == locationTextField {
                locationTextField.text = locationArray[0]
            } else if textField == heightTextField {
                if String.mySex! == "male" {
                    heightTextField.text = "173 cm"
                } else {
                    heightTextField.text = "160 cm"
                }
            } else if textField == bodyTextField {
                bodyTextField.text = MbodyArray[0]
            } else if textField == bodyTextField {
                bodyTextField.text = drinkArray[0]
            } else if textField == religionTextField {
                religionTextField.text = religionArray[0]
            } else if textField == bloodTextField {
                bloodTextField.text = bloodArray[0]
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint(x : 0, y: bloodTextField.frame.origin.y)
        ScrollView.setContentOffset(scrollPoint, animated: true)
        doneButton.isHidden = false
        ScrollViewBottom.constant = 0
    }
    
    @objc func uploadCell(sender : targetTapGestureRecognizer) {
        currentIndexPathrow = sender.target!
        
        if self.profilImg[sender.target!] == nil {
            self.editImg(sender: sender)
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { handler in
                self.editImg(sender: sender)
            }))
            alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: {handler in
                self.deleteImg(sender: sender)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func tapView() {
        self.view.endEditing(true)
    }
    
    private func estimateFrameForText(_ text: String) -> CGSize {
        let cellsize = KRWordWrapLabel(frame: CGRect(x: 0, y: 0, width: 230, height: 20))
        var estimateSize: CGSize!
        
        cellsize.text = text
        cellsize.numberOfLines = 0
        cellsize.lineBreakMode = .byWordWrapping
        cellsize.font = UIFont(name: "NanumSquare", size: 14)
        cellsize.translatesAutoresizingMaskIntoConstraints = false
        cellsize.preferredMaxLayoutWidth = 230
        cellsize.textAlignment = .left
        cellsize.sizeToFit()
        estimateSize = cellsize.intrinsicContentSize
        
        return estimateSize
    }
    
    @objc func editButtonAction(sender : UIButton){
        if let cell = sender.superview?.superview as? MYEditTableViewCell {
            if cell.editButton.titleLabel?.text == "수정하기" {
                inputBar.isHidden = false
                doneButton.isHidden = true
                currentEditMessage = tableView.indexPath(for: cell)
                
                cell.editButton.setTitle("취소", for: .normal)
            } else {
                inputBar.isHidden = true
                doneButton.isHidden = false
                self.view.endEditing(true)
                
                cell.editButton.setTitle("수정하기", for: .normal)
            }
        }
    }
    
    func estimateTableViewHeight(text: [message]) -> Int{
        var height = 0
        
        for i in text {
            height += Int(self.estimateFrameForText(i.text!).height)
        }
        height += 225
        print(height)
        
        return height
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func editImg(sender : targetTapGestureRecognizer) {
        cellPicker.allowsEditing = false
        cellPicker.sourceType = .photoLibrary
        cellPicker.delegate = self
        
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
    
    func deleteImg(sender : targetTapGestureRecognizer) {
        profilImg.remove(at: sender.target!)
        profilImg.append(nil)
        
        for (index, i) in editingImgArray.enumerated() {
            if i.index! == currentIndexPathrow {
                editingImgArray.remove(at: index)
                break
            }
        }
        
        CollectionView.reloadData()
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    
    @IBAction func editQAAction(_ sender: Any) {
        var question_id = 0
        
        doneButton.isHidden = false
        inputBar.isHidden = true
        QAMessage[(self.currentEditMessage?.row)!].text = self.inputTextView.text
        editingQAArray.append(message(text: self.inputTextView.text, sex: nil, create_time: nil, group_id: nil, question_id: QAMessage[(self.currentEditMessage?.row)!].question_id))
        self.view.endEditing(true)
        
        tableViewHeight.constant = CGFloat(estimateTableViewHeight(text: QAMessage))
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue , let window = self.view.window?.frame {
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: (window.height - keyboardSize.height))
            
            if UIScreen.main.bounds.height == 812 {
                doneHeight.constant -= 34
                doneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0 )
            }
            
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let widow = self.view.window?.frame
        
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: self.view.frame.origin.y,
                                 width: self.view.frame.width,
                                 height: (widow?.height)!)
        
        if UIScreen.main.bounds.height == 812 {
            doneHeight.constant += 34
            doneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        indicatorView.isHidden = false
        ActivityIndicator.startAnimating()
        
        if editingImgArray.count > 0 {
            self.editCategory += 1
            self.uploadEditImg()
        }
        
        if editingQAArray.count > 0 {
            var answer = [message]()
            for i in editingQAArray {
                answer.append(message(text: i.text!, sex: nil, create_time: nil, group_id: nil, question_id: i.question_id!))
            }
            self.editCategory += 1
            self.uploadEditQnA(text: answer)
        }
        
        editAccountInfo()
        editCategory += 1
    }
    
    func uploadEditImg() {
        let url = String.domain! + "information/register/edit-image/"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String.myId!,
            "account-sex" : String.mySex!
        ]
        
        let URI = try! URLRequest(url: url, method: .post, headers: headers)
        
        for i in editingImgArray {
            Alamofire.upload(multipartFormData: {MultipartFormData in
                self.addImageData(multipartFormData: MultipartFormData, image: i.image!, index: i.index!)
            }, with: URI, encodingCompletion: {result in
                switch result {
                case .success(let upload, _, _):
                    print(result)
                    upload.responseJSON { response in
                        print(response)
                        let jSON = JSON(response.result.value)
                        print(jSON["message"].stringValue)
                        self.editCounter += 1
                        self.uploadChecker()
                    }
                case .failure(let encodingError):
                    print(result)
                }
            })
        }
    }
    
    func uploadEditQnA(text: [message]) {
        var array = [[String : Any]]()
        for i in text {
            let Answer = ["question_id" : i.question_id!, "answer" : i.text!] as [String : Any]
            array.append(Answer)
        }
        let param = ["qna_list" : array] as [String : Any]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String.myId!,
            "account-sex" : String.mySex!
        ]
        
        Alamofire.request(String.domain! + "information/register/edit-introduction-qna/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers ).responseJSON{response in
            switch response.result {
            case .success:
                print("edit-introduction-qna : " + "\(response.result.value)")
                let jSON = JSON(response.result.value)
                print(jSON["message"].stringValue)
                self.editCounter += 1
                self.uploadChecker()
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func editAccountInfo() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String.myId!,
            "account-sex" : String.mySex!
        ]

        let param = [
            "education": schoolTextField.text!,
            "department" : careerTextfield.text!,
            "location": locationTextField.text!,
            "height" : (heightTextField.text! as NSString).replacingOccurrences(of: "cm", with: ""),
            "body_form" : bodyTextField.text!,
            "smoke" : smokeSegmentedControl.selectedSegmentIndex == 0 ? false : true,
            "drink" : drinkTextField.text!,
            "religion" : religionTextField.text!,
            "blood_type" : bloodTextField.text!
        ] as [String : Any]
        
        print(param)
        Alamofire.request(String.domain! + "information/register/edit-account-info/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseString{response in
            switch response.result {
            case .success:
                print("edit-account-info : \(response.result.value!)")
                self.editCounter += 1
                self.uploadChecker()
                
            case .failure(let error):
                print(response)
                print("error - edit-account-info :" + String(describing: error))
            }
        }
    }
    
    private func addImageData(multipartFormData: MultipartFormData, image: UIImage, index: Int){
        let lowdata = image.jpeg(image ,.lowest)
        let middledata = image.jpeg(image, .low)
        let highdata = image.jpeg(image, .medium)
        
        print(lowdata!.count)
        print(middledata!.count)
        print(highdata!.count)
        print(index)
        multipartFormData.append(lowdata!, withName: "image-small",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(middledata!, withName: "image-medium",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(highdata!, withName: "image-large",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(String(index).data(using: .utf8)!, withName: "image-index")
    }
    
    func uploadChecker() {
        if editCounter == editCategory {
            self.ActivityIndicator.stopAnimating()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
