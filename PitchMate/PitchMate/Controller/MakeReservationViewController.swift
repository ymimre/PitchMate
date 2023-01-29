//
//  LoginViewController.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 27.12.2022.
//import UIKit

import FirebaseAuth
import Firebase

class MakeReservationViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var hourTableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    private let reservationDataSource = ReservationDataSource()
    private let calendarHelper = CalendarHelper()
    private let authenticatePhoneNumber = AuthenticatePhoneNumber()
    private var displayedDate = Date()
    private let todaysDate = Date()
    private var selectedCell: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Reservation"
        dateLabel.text = calendarHelper.dateToString(date: displayedDate)
        updateArrowButtons()
        reservationDataSource.delegate = self
        reservationDataSource.getListOfReservations()
    }
    
    func updateArrowButtons() {
        if displayedDate == todaysDate {
            leftButton.tintColor = UIColor.systemGray
            leftButton.isUserInteractionEnabled = false
        } else {
            leftButton.tintColor = UIColor.systemBlue
            leftButton.isUserInteractionEnabled = true
        }
        
        if displayedDate < calendarHelper.nextWeek(date: todaysDate) {
            rightButton.tintColor = UIColor.systemBlue
            rightButton.isUserInteractionEnabled = true
        } else {
            rightButton.tintColor = UIColor.systemGray
            rightButton.isUserInteractionEnabled = false
        }

    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let phoneNumber = Auth.auth().currentUser?.phoneNumber else {return}
        let newReservation = Reservation(date: calendarHelper.dateToString(date: displayedDate), hour: selectedCell, reservation_id: "\(reservationDataSource.getNumberOfReservations())", userid: phoneNumber)
        reservationDataSource.addReservation(reservation: newReservation)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainScreenViewController = storyBoard.instantiateViewController(withIdentifier: "mainscreen")
        mainScreenViewController.modalPresentationStyle = .overFullScreen
        self.present(mainScreenViewController, animated: true)
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        displayedDate = calendarHelper.previousDay(date: displayedDate)
        dateLabel.text = calendarHelper.dateToString(date: displayedDate)
        updateArrowButtons()
        resetSubmitButton()
        hourTableView.reloadData()
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        displayedDate = calendarHelper.nextDay(date: displayedDate)
        dateLabel.text = calendarHelper.dateToString(date: displayedDate)
        updateArrowButtons()
        resetSubmitButton()
        hourTableView.reloadData()
    }
    
    func resetSubmitButton() {
        submitButton.isUserInteractionEnabled = false
        submitButton.tintColor = UIColor.systemGray
    }
}

extension MakeReservationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationDataSource.getNumberOfHours()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HourCell") as? HourTableViewCell
        else{
            return UITableViewCell()
        }
        if let hour = reservationDataSource.getHour(for: indexPath.row) {
            cell.hourLabel.text = hour
        }
        let unavailableSlots = reservationDataSource.getUnavailableTimeslots(date: calendarHelper.dateToString(date: displayedDate))
       
        if unavailableSlots!.contains(indexPath.row) {
            cell.isUserInteractionEnabled = false
            cell.availabilityView.backgroundColor = UIColor.systemRed
        } else {
            cell.isUserInteractionEnabled = true
            cell.availabilityView.backgroundColor = UIColor.systemGreen
        }
        return cell
    }
}

extension MakeReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submitButton.isUserInteractionEnabled = true
        submitButton.tintColor = UIColor.systemBlue
        selectedCell = indexPath.row
    }
}

extension MakeReservationViewController: ReservationDataDelegate {
    func reservationListLoaded() {
        self.hourTableView.reloadData()
    }
}
