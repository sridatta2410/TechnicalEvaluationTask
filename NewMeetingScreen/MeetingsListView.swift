//
//  MeetingsListView.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 21/09/21.
//

import UIKit
import CoreData

class MeetingsListView: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var totalView                    : UIView!
    @IBOutlet weak var headerView                   : UIView!
    @IBOutlet weak var contentView                  : UIView!
    @IBOutlet weak var screenTitleLabel             : UILabel!
    @IBOutlet weak var backButton                   : UIButton!
    @IBOutlet weak var newMeetingButton             : UIButton!
    @IBOutlet weak var meetingsTable                : UITableView!
    
    //MARK:- Variables
    let ud              = UserDefaults.standard
    let context         = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models  = [MeetingsList]()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    //MARK:- User Defined Methods
    func setupUI() {
        
        screenTitleLabel.text           = "My Meetings"
        contentView.backgroundColor     = #colorLiteral(red: 0.8549019608, green: 0.8980392157, blue: 0.9450980392, alpha: 1)
        
        meetingsTable.delegate          = self
        meetingsTable.dataSource        = self
        
        fetchAllMeetings()
        
        self.meetingsTable.reloadData()
    }
    
    //MARK: CRUD Methods
    
    // Read - Fetches all records from local database
    func fetchAllMeetings() {
        do {
            models = try context.fetch(MeetingsList.fetchRequest())
            models = models.reversed()
            print("\nAll records fetched successfully")
        } catch {
            print("\nFailed to fetch records.")
        }
        
    }
    
    // Create - Creates a new record into local database
    func createMeeting(privacy: String, password: String, meetingType: String, company: String, title: String, location: String, startTime: String, endTime: String) {
        
        let newMeeting          = MeetingsList(context: context)
        newMeeting.privacy      = privacy
        newMeeting.password     = password
        newMeeting.type         = meetingType
        newMeeting.company      = company
        newMeeting.title        = title
        newMeeting.location     = location
        newMeeting.starts       = startTime
        newMeeting.ends         = endTime
        
        do {
            try context.save()
            print("\nMeeting added to DB")
            fetchAllMeetings()
        } catch {
            print("\nFailed to create meeting")
        }
    }
    
    // Update - Fetches and updates a specific record in local database
    func updateMeeting(indexToUpdate: Int, privacy: String, password: String, meetingType: String, company: String, title: String, location: String, startTime: String, endTime: String) {
        do {
            let meeting = try context.fetch(MeetingsList.fetchRequest())
            
            let meet = meeting[indexToUpdate] as! NSManagedObject
            meet.setValue(privacy, forKey: "privacy")
            meet.setValue(password, forKey: "password")
            meet.setValue(meetingType, forKey: "type")
            meet.setValue(company, forKey: "company")
            meet.setValue(title, forKey: "title")
            meet.setValue(location, forKey: "location")
            meet.setValue(startTime, forKey: "starts")
            meet.setValue(endTime, forKey: "ends")
            
            do {
                try context.save()
                print("\nMeeting updated successfully")
                fetchAllMeetings()
            } catch {
                print("\nFailed to update meeting")
            }
        }
        catch {
            print("\nFailed to update meeting")
        }
    }
    
    // Delete - Deletes a specific record from local database
    func deleteMeeting(meeting: MeetingsList) {
        context.delete(meeting)
        do {
            try context.save()
            print("\nMeeting deleted successfully")
            fetchAllMeetings()
            meetingsTable.reloadData()
        } catch {
            print("\nFailed to delete record")
        }
        
    }
    
    //MARK:- Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newMeetingButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMeetingView") as! NewMeetingView
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK:- Extensions

//MARK: TableView Delegate Methods
extension MeetingsListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        var cell: meetingDataCell!
        
        let model = models[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? meetingDataCell
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.8980392157, blue: 0.9450980392, alpha: 1)
        
        cell.meetingView.layer.borderWidth = 0.5
        cell.meetingView.layer.borderColor = #colorLiteral(red: 0.04705882353, green: 0.4666666667, blue: 0.9215686275, alpha: 0.5)
        
        cell.dateView.backgroundColor = blueColor
        
        var fulldate = ""
        var date = ""
        var month = ""
        var startTime = ""
        
        let startDate = model.starts!
        let dateArr = startDate.components(separatedBy: ",")
        fulldate = dateArr[0]
        startTime = dateArr[1]
        
        let monthArr = fulldate.components(separatedBy: " ")
        date = monthArr[0]
        month = monthArr[1]
        
        var endTime = ""
        let endDate = model.ends!
        if endDate.contains(",") {
            let dateArr1 = endDate.components(separatedBy: ",")
            endTime = dateArr1[1]
        }
        else {
            endTime = endDate
        }
        
        cell.dateLabel.text = date
        cell.dateLabel.textColor = .white
        cell.dateLabel.font = UIFont(name: "Lato-Regular", size: 28.0)
        
        cell.dayLabel.text = month.uppercased()
        cell.dayLabel.textColor = .white
        cell.dayLabel.font = UIFont(name: "Lato-Regular", size: 20.0)
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.text = model.title
        
        let duration = "\(startTime.replacingOccurrences(of: " ", with: ""))" + " - " + "\(endTime)"
        cell.timeLabel.text = duration
        
        cell.locationLabel.font = UIFont(name: "Lato-Regular", size: 13.0)
        cell.locationLabel.text = model.location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (editAction) in
            self.ud.set(true, forKey: "isEditClicked")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMeetingView") as! NewMeetingView
            vc.meetingDictionary = [
                "id": String(indexPath.row),
                "privacy": item.privacy,
                "password": item.password,
                "meetingType": item.type,
                "company": item.company,
                "title": item.title,
                "location": item.location,
                "startTime": item.starts,
                "endTime": item.ends
            ]
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.deleteMeeting(meeting: item)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true)
    }
    
}
