//
//  NewMeetingView.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 21/09/21.
//

import UIKit

class NewMeetingView: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var totalView                            : UIView!
    @IBOutlet weak var headerView                           : UIView!
    @IBOutlet weak var contentView                          : UIView!
    @IBOutlet weak var scrollView                           : UIScrollView!
    @IBOutlet weak var scrollableContentView                : UIView!
    @IBOutlet weak var scrollableContentViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Header view
    @IBOutlet weak var backArrowImage                   : UIImageView!
    @IBOutlet weak var backButton                       : UIButton!
    @IBOutlet weak var saveButton                       : UIButton!
    @IBOutlet weak var screenTitleLabel                 : UILabel!
    @IBOutlet weak var headerDividerView                : UIView!

    //MARK: Meeting options view
    @IBOutlet weak var meetingOptionsView               : UIView!
    @IBOutlet weak var meetingTypeView                  : UIView!
    @IBOutlet weak var privateRadioImage                : UIImageView!
    @IBOutlet weak var privateMeetingLabel              : UILabel!
    @IBOutlet weak var privateMeetingButton             : UIButton!
    @IBOutlet weak var publicRadioImage                 : UIImageView!
    @IBOutlet weak var publicConferenceLabel            : UILabel!
    @IBOutlet weak var publicConferenceButton           : UIButton!
    
    //MARK: Password view
    @IBOutlet weak var totalPasswordView                : UIView!
    @IBOutlet weak var toggleView                       : UIView!
    @IBOutlet weak var passwordView                     : UIView!
    @IBOutlet weak var totalPasswordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requirePasswordLabel             : UILabel!
    @IBOutlet weak var requirePasswordToggle            : UISwitch!
    @IBOutlet weak var passwordLabel                    : UILabel!
    @IBOutlet weak var passwordField                    : UITextField!
    @IBOutlet weak var passwordViewHeightConstraint     : NSLayoutConstraint!
    
    //MARK: Meeting type view
    @IBOutlet weak var meetingTypeAndCompanyView        : UIView!
    @IBOutlet weak var meetingTitleView                 : UIView!
    @IBOutlet weak var meetingLocationView              : UIView!
    @IBOutlet weak var meetingTypeLabel                 : UILabel!
    @IBOutlet weak var meetingTypeButton                : UIButton!
    @IBOutlet weak var meetingTypeDropdownView          : UIView!
    @IBOutlet weak var internalTypeButton               : UIButton!
    @IBOutlet weak var externalTypeButton               : UIButton!
    @IBOutlet weak var companyLabel                     : UILabel!
    @IBOutlet weak var companySelectionButton           : UIButton!
    
    //MARK: Title and Location fields
    @IBOutlet weak var titleField                       : UITextField!
    @IBOutlet weak var titleBottonView                  : UIView!
    @IBOutlet weak var locationField                    : UITextField!
    @IBOutlet weak var sectionDividerViewOne            : UIView!
    
    //MARK: Meeting time settings
    @IBOutlet weak var startTimeView                    : UIView!
    @IBOutlet weak var endTimeView                      : UIView!
    @IBOutlet weak var repeatView                       : UIView!
    @IBOutlet weak var allDayView                       : UIView!
    @IBOutlet weak var timeZoneView                     : UIView!
    @IBOutlet weak var startTimeLabel                   : UILabel!
    @IBOutlet weak var startTimeValueField              : UITextField!
    @IBOutlet weak var startTimeButton                  : UIButton!
    @IBOutlet weak var endTimeLabel                     : UILabel!
    @IBOutlet weak var endTimeValueField                : UITextField!
    @IBOutlet weak var endTimeButton                    : UIButton!
    @IBOutlet weak var repeatLabel                      : UILabel!
    @IBOutlet weak var repeatValueLabel                 : UILabel!
    @IBOutlet weak var repeatButton                     : UIButton!
    @IBOutlet weak var allDayLabel                      : UILabel!
    @IBOutlet weak var allDayToggle                     : UISwitch!
    @IBOutlet weak var timeZoneHeightConstraint         : NSLayoutConstraint!
    @IBOutlet weak var timeZoneLabel                    : UILabel!
    @IBOutlet weak var timeZoneValueLabel               : UILabel!
    @IBOutlet weak var timeZoneButton                   : UIButton!
    @IBOutlet weak var sectionDividerViewTwo            : UIView!
    
    //MARK:- Variables
    let ud = UserDefaults.standard
    var isMeetingTypeDropdownShown  = false
    let date                        = Date()
    var datePicker                  = UIDatePicker()
    let dateFormatter               = DateFormatter()
    var currentTextField            = UITextField()
    let meetingListViewObj          = MeetingsListView()
    
    var privacy                     = ""
    var allDay                      = ""
    var meetingDictionary           = Dictionary<String, String?>()
    var idToUpdate:Int!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [MeetingsList]()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchAllMeetings()
        
        setupUI()
    }
    
    //MARK:- Userdefined Methods
    
    //MARK: CRUD Methods
    func fetchAllMeetings() {
        do {
            models = try context.fetch(MeetingsList.fetchRequest())
            print("\nAll records fetched successfully")
        } catch {
            print("\nFailed to fetch records.")
        }
        
    }
    
    func setupUI() {
        
        print("Models count -- ",models.count)
        print("Models -- ",models)
        
        setBackgroundColorForView(
            [sectionDividerViewOne, sectionDividerViewTwo],
            color: blueColor.withAlphaComponent(0.2)
        )
    
        scrollableContentViewHeightConstraint.constant = 810
        
        // Header view
        backArrowImage.image            = UIImage(named: "back_arrow")
        if ud.bool(forKey: "isEditClicked") == true {
            screenTitleLabel.text       = "Edit Meeting"
            saveButton.setTitle("Update", for: .normal)
        }
        else {
            screenTitleLabel.text       = "New Meeting"
            saveButton.setTitle("Save", for: .normal)
        }
        
        // Meeting options
        privateMeetingLabel.text        = "Private meeting"
        publicConferenceLabel.text      = "Public conference"
        if #available(iOS 13.0, *) {
            privateRadioImage.image     = UIImage(systemName: "circle.circle.fill")
            publicRadioImage.image      = UIImage(systemName: "circle.circle")
            privacy                     = "private"
        } else {
            // Fallback on earlier versions
            privacy                     = "private"
        }
        privateRadioImage.alpha                             = 1.0
        publicRadioImage.alpha                              = 0.3
        totalPasswordView.alpha                             = 1.0
        totalPasswordViewHeightConstraint.constant          = 102
        meetingTypeDropdownView.backgroundColor             = .white
        meetingTypeDropdownView.alpha                       = 0.0
        
        // Adding shadow to meeting type dropdown view
        meetingTypeDropdownView.layer.cornerRadius          = 10
        meetingTypeDropdownView.layer.shadowColor           = UIColor.black.cgColor
        meetingTypeDropdownView.layer.shadowOpacity         = 0.1
        meetingTypeDropdownView.layer.shadowOffset          = .zero
        meetingTypeDropdownView.layer.shadowPath            = UIBezierPath(rect: meetingTypeDropdownView.bounds).cgPath
        meetingTypeDropdownView.layer.shouldRasterize       = true
        meetingTypeDropdownView.layer.rasterizationScale    = UIScreen.main.scale
        meetingTypeDropdownView.layer.shadowRadius          = 5
        
        // Require password
        requirePasswordLabel.text       = "Require meeting password"
        passwordLabel.text              = "Password"
        passwordField.placeholder       = "Add password..."
        passwordField.delegate          = self
        passwordField.isSecureTextEntry = true
        totalPasswordView.alpha         = 1.0
        
        // Meeting type
        meetingTypeLabel.text           = "Meeting Type"
        companyLabel.text               = "Company"
        companySelectionButton.setTitle("Select Company", for: .normal)
        
        // Title and Location
        titleField.placeholder          = "Title"
        locationField.placeholder       = "Location"
        titleField.delegate             = self
        locationField.delegate          = self
        
        // Scheduling
        getCurrentDateTime()
        
        startTimeLabel.text             = "Starts"
        endTimeLabel.text               = "Ends"
        repeatLabel.text                = "Repeat"
        repeatValueLabel.text           = "Never"
        allDayLabel.text                = "All day"
        timeZoneLabel.text              = "Time zone"
        timeZoneValueLabel.text         = "Kolkata"
        
        startTimeValueField.delegate    = self
        endTimeValueField.delegate      = self
        startTimeValueField.tintColor   = .clear
        endTimeValueField.tintColor     = .clear
        
        allDayToggle.isOn               = false
        
        if ud.bool(forKey: "isEditClicked") == true {
            setupEditMeetingUI()
        }
    }
    
    func setupEditMeetingUI() {
        ud.set(false, forKey: "isEditClicked")
        
        print("Meeting details to Update -- ",meetingDictionary)
        
        let Id          = meetingDictionary["id"]!
        let Privacy     = meetingDictionary["privacy"]!
        let Password    = meetingDictionary["password"]!
        let Type        = meetingDictionary["meetingType"]!
        let Company     = meetingDictionary["company"]!
        let Title       = meetingDictionary["title"]!
        let Location    = meetingDictionary["location"]!
        let Starts      = meetingDictionary["startTime"]!
        let Ends        = meetingDictionary["endTime"]!
        
        idToUpdate      = Int(Id!)
        
        /*
        print("\n\(Id)\n\(Privacy)\n\(Password)\n\(Type)\n\(Company)\n\(Title)\n\(Location)\n\(Starts)\n\(Ends)")
        */
        
        if Privacy == "" || Privacy == nil {
            privacy = ""
        }
        else if Privacy == "private" {
            if #available(iOS 13.0, *) {
                privateRadioImage.image = UIImage(systemName: "circle.circle.fill")
                publicRadioImage.image  = UIImage(systemName: "circle.circle")
                privacy                 = "private"
            } else {
                // Fallback on earlier versions
                privacy                 = "private"
            }
            privateRadioImage.alpha = 1.0
            publicRadioImage.alpha = 0.3
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut , animations: {
                self.totalPasswordView.alpha = 1.0
                self.totalPasswordViewHeightConstraint.constant = 102
                self.scrollableContentViewHeightConstraint.constant += 102
            }, completion: nil)
        }
        else if Privacy == "public" {
            if #available(iOS 13.0, *) {
                privateRadioImage.image = UIImage(systemName: "circle.circle")
                publicRadioImage.image  = UIImage(systemName: "circle.circle.fill")
                privacy                 = "public"
            } else {
                // Fallback on earlier versions
                privacy                 = "public"
            }
            publicRadioImage.alpha = 1.0
            privateRadioImage.alpha = 0.3
            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn , animations: {
                self.totalPasswordView.alpha = 0.0
                self.totalPasswordViewHeightConstraint.constant = 0
                self.scrollableContentViewHeightConstraint.constant -= 102
                self.totalPasswordView.alpha = 0.0
            }, completion: nil)
        }
        
        if Password == "" || Password == nil {
            passwordField.text = ""
        }
        else {
            passwordField.text = Password as! String
            passwordField.isSecureTextEntry = false
        }
        
        if Type == "Internal" {
            meetingTypeButton.setTitle("Internal", for: .normal)
        }
        else if Type == "External" {
            meetingTypeButton.setTitle("External", for: .normal)
        }
        
        titleField.text             = Title
        locationField.text          = Location as! String
        startTimeValueField.text    = Starts
        endTimeValueField.text      = Ends

    }
    
    // Sets a custom background color to UIview
    func setBackgroundColorForView(_ allViews: [UIView], color: UIColor) {
        for view in allViews {
            view.backgroundColor = color
        }
    }
    
    // Return current date string of format '15 Sep'
    func getCurrentDate() -> String {
        let now = date
        dateFormatter.dateFormat = "dd MMM"
        let todayDate = dateFormatter.string(from: now)
        print("Current Date -- ",todayDate)
        return todayDate
    }
    
    // Get current date, time to autofill start and end time fields
    func getCurrentDateTime() {
        var nowDate = ""
        var nowTime = ""
        var currentDateTime = ""
        
        let now = date
        dateFormatter.dateFormat = "dd MMM"
        nowDate = dateFormatter.string(from: now)
        dateFormatter.timeStyle = .short
        nowTime = dateFormatter.string(from: now)
        print("\(nowDate)"," \(nowTime)")
        currentDateTime = "\(nowDate), " + "\(nowTime)"
        startTimeValueField.textAlignment = .right
        startTimeValueField.text = currentDateTime
        let timeAfter30Mins = date.addingTimeInterval(1800)
        endTimeValueField.textAlignment = .right
        endTimeValueField.text = dateFormatter.string(from: timeAfter30Mins)
    }

    //MARK: Date Picker Custom Methods
    func openStartDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(startDatePickerValueChangedHandler(datePicker:)), for: .valueChanged)
        startTimeValueField.inputView = datePicker
        startTimeValueField.becomeFirstResponder()
    }
    
    @objc func startDatePickerValueChangedHandler(datePicker: UIDatePicker) {
        if let datePicker = startTimeValueField.inputView as? UIDatePicker {
           
            var nowDate = ""
            var nowTime = ""
            var currentDateTime = ""
            
            let now = date
            dateFormatter.dateFormat = "dd MMM"
            nowDate = dateFormatter.string(from: datePicker.date)
            dateFormatter.timeStyle = .short
            nowTime = dateFormatter.string(from: datePicker.date)
            print("\(nowDate)"," \(nowTime)")
            currentDateTime = "\(nowDate), " + "\(nowTime)"
            startTimeValueField.textAlignment = .right
            startTimeValueField.text = currentDateTime
            let timeAfter30Mins = datePicker.date.addingTimeInterval(1800)
            endTimeValueField.textAlignment = .right
            endTimeValueField.text = dateFormatter.string(from: timeAfter30Mins)
        
            print(datePicker.date)
        }
        print(datePicker.date)
    }
    
    func openEndDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(endDatePickerValueChangedHandler(datePicker:)), for: .valueChanged)
        endTimeValueField.inputView = datePicker
        endTimeValueField.becomeFirstResponder()
    }
    
    @objc func endDatePickerValueChangedHandler(datePicker: UIDatePicker) {
        if let datePicker = endTimeValueField.inputView as? UIDatePicker {
            
            var date = ""
            var time = ""
            var selectedDate = ""
            
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.dateFormat = "dd MMM"
            date = dateFormat.string(from: datePicker.date)
            selectedDate = date
            dateFormat.timeStyle = .short
            time = dateFormat.string(from: datePicker.date)
            let timeArr = time.components(separatedBy: "at")
            time = timeArr[1]
            endTimeValueField.textAlignment = .right
            if selectedDate == getCurrentDate() {
                print("same date")
                endTimeValueField.text = "\(time)"
            }
            else {
                print("another date")
                endTimeValueField.text = "\(date)," + "\(time)"
            }
            print(datePicker.date)
        }
        print(datePicker.date)
    }
    
    //MARK:- Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func meetingTypeButtonAction(_ sender: Any) {
        currentTextField.resignFirstResponder()
        if meetingTypeButton.titleLabel?.text == "Internal" {
            internalTypeButton.setTitleColor(blueColor, for: .normal)
            externalTypeButton.setTitleColor(.lightGray, for: .normal)
        }
        else {
            internalTypeButton.setTitleColor(.lightGray, for: .normal)
            externalTypeButton.setTitleColor(blueColor, for: .normal)
        }
        if isMeetingTypeDropdownShown == false {
            isMeetingTypeDropdownShown = true
            UIView.animate(withDuration: 0.2){
                self.meetingTypeDropdownView.alpha = 1.0
            }
        }
        else {
            isMeetingTypeDropdownShown = false
            UIView.animate(withDuration: 0.2){
                self.meetingTypeDropdownView.alpha = 0.0
            }
        }
    }
    
    @IBAction func internalTypeButtonAction(_ sender: Any) {
        meetingTypeDropdownView.alpha = 0.0
        meetingTypeButton.setTitle("Internal", for: .normal)
    }
    
    @IBAction func externalTypeButtonAction(_ sender: Any) {
        meetingTypeDropdownView.alpha = 0.0
        meetingTypeButton.setTitle("External", for: .normal)
    }
    
    @IBAction func startTimeButtonAction(_ sender: Any) {
        openStartDatePicker()
    }
    
    @IBAction func endTimeButtonAction(_ sender: Any) {
        openEndDatePicker()
    }
    
    @IBAction func privateMeetingButtonAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            privateRadioImage.image = UIImage(systemName: "circle.circle.fill")
            publicRadioImage.image = UIImage(systemName: "circle.circle")
            privacy = "private"
        } else {
            // Fallback on earlier versions
            privacy = "private"
        }
        privateRadioImage.alpha = 1.0
//        publicRadioImage.image = UIImage(systemName: "circle.circle")
        publicRadioImage.alpha = 0.3
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut , animations: {
            self.totalPasswordView.alpha = 1.0
            self.totalPasswordViewHeightConstraint.constant = 102
            self.scrollableContentViewHeightConstraint.constant += 102
        }, completion: nil)
    }
    
    @IBAction func publicConferenceButtonAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            publicRadioImage.image = UIImage(systemName: "circle.circle.fill")
            privateRadioImage.image = UIImage(systemName: "circle.circle")
            privacy = "public"
        } else {
            // Fallback on earlier versions
            privacy = "public"
        }
        publicRadioImage.alpha = 1.0
        privateRadioImage.alpha = 0.3
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn , animations: {
            self.totalPasswordView.alpha = 0.0
            self.totalPasswordViewHeightConstraint.constant = 0
            self.scrollableContentViewHeightConstraint.constant -= 102
            self.totalPasswordView.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func requirePasswordToggleAction(_ sender: UISwitch) {
        if requirePasswordToggle.isOn {
            print("requirePassword Toggle isOn")
            passwordViewHeightConstraint.constant = 50
            passwordView.alpha = 1.0
            totalPasswordViewHeightConstraint.constant += 50
            scrollableContentViewHeightConstraint.constant += 50
            requirePasswordToggle.isOn = false
            requirePasswordToggle.setOn(true, animated:true)
        } else {
            print("requirePassword Toggle isOn")
            passwordViewHeightConstraint.constant = 0
            passwordView.alpha = 0.0
            totalPasswordViewHeightConstraint.constant -= 50
            scrollableContentViewHeightConstraint.constant -= 50
            requirePasswordToggle.isOn = true
            requirePasswordToggle.setOn(false, animated:true)
        }
    }
    
    @IBAction func allDayToggleAction(_ sender: UISwitch) {
        if allDayToggle.isOn {
            print("allDay Toggle isOn")
            timeZoneView.alpha = 0.0
            timeZoneHeightConstraint.constant = 0
            allDayToggle.isOn = true
        } else {
            print("allDay Toggle isOff")
            timeZoneView.alpha = 1.0
            timeZoneHeightConstraint.constant = 50
            allDayToggle.isOn = false
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        var alertTitle = ""
        var alertMessage = ""
        if saveButton.titleLabel?.text == "Update" {
            self.meetingListViewObj.updateMeeting(
                indexToUpdate: idToUpdate,
                privacy: privacy,
                password: passwordField.text!,
                meetingType: (meetingTypeButton.titleLabel?.text)!,
                company: "Krify",
                title: titleField.text!,
                location: locationField.text!,
                startTime: startTimeValueField.text!,
                endTime: endTimeValueField.text!
            )
            alertTitle = "Updated"
            alertMessage = "Meeting info has been updated"
        }
        else if saveButton.titleLabel?.text == "Save"  {
            self.meetingListViewObj.createMeeting(
                privacy: privacy,
                password: passwordField.text!,
                meetingType: (meetingTypeButton.titleLabel?.text)!,
                company: "Krify",
                title: titleField.text!,
                location: locationField.text!,
                startTime: startTimeValueField.text!,
                endTime: endTimeValueField.text!
            )
            alertTitle = "Saved"
            alertMessage = "New meeting has been created"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            self.setupUI()
            self.titleField.text = ""
            self.locationField.text = ""
            self.passwordField.text = ""
            self.passwordField.placeholder = "Add password..."
            self.totalPasswordView.isHidden = false
            self.passwordView.isHidden = false
            self.timeZoneView.isHidden = false
            self.passwordView.alpha = 1.0
            self.passwordViewHeightConstraint.constant = 50
            self.timeZoneHeightConstraint.constant = 50
            
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
}

//MARK:- Extensions

//MARK: TextField Delegates
extension NewMeetingView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if currentTextField == passwordField {
            UIView.animate(withDuration: 0.2){
                self.meetingTypeDropdownView.alpha = 0.0
            }
        }
        else if currentTextField == titleField {
            UIView.animate(withDuration: 0.2){
                self.meetingTypeDropdownView.alpha = 0.0
            }
        }
        else if currentTextField == locationField {
            UIView.animate(withDuration: 0.2){
                self.meetingTypeDropdownView.alpha = 0.0
            }
        }
        else if currentTextField == startTimeValueField {
            self.openStartDatePicker()
        }
        else if currentTextField == endTimeValueField {
            self.openEndDatePicker()
        }
    }
}
