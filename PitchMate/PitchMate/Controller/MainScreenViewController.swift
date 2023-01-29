//
//  LoginViewController.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 27.12.2022.
//

import UIKit
import FirebaseAuth
import Firebase    

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var reservationTableView: UITableView!
    
    private let reservationDataSource = ReservationDataSource()
    private let calendarHelper = CalendarHelper()
    private let authenticatePhoneNumber = AuthenticatePhoneNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reservationDataSource.delegate = self
        reservationDataSource.getListOfReservations()
        reservationDataSource.getReservationListOfUser()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "defaultPhoneNumber")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "login")
        loginViewController.modalPresentationStyle = .overFullScreen
        self.present(loginViewController, animated: true)
    }
}

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationDataSource.getNumberOfReservationsOfUser()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell") as? ReservationTableViewCell
        else{
            return UITableViewCell()
        }
        
        if let reservation = reservationDataSource.getReservationOfUser(for: indexPath.row) {
            cell.dateLabel.text = reservation.date
            cell.hourLabel.text = reservationDataSource.getHour(for: reservation.hour)
        }
        return cell
    }
}

extension MainScreenViewController: ReservationDataDelegate {
    func reservationListOfUserLoaded() {
        self.reservationTableView.reloadData()
    }
    
    func reservationListLoaded() {
        self.reservationDataSource.getReservationListOfUser()
        self.reservationTableView.reloadData()
        
    }
    
}
