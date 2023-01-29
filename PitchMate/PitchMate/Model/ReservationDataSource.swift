//
//  ReservationDataSource.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 29.12.2022.
//

import Foundation
import FirebaseAuth
import Firebase

class ReservationDataSource {
    private let calendarHelper = CalendarHelper()
    private var hoursArray: [String] = []
    private var reservationArray: [Reservation] = []
    private var reservationArrayOfUser: [Reservation] = []
    private let baseURL = "https://pitchmate-67916-default-rtdb.firebaseio.com/reservations"
    private let jsonString = ".json"
    var delegate: ReservationDataDelegate?
    
    init() {
        for index in 0...23 {
            if index < 9 {
                hoursArray.append("0\(index):00 - 0\(index+1):00")
            } else if index == 9 {
                hoursArray.append("0\(index):00 - 10:00")
            } else if index > 9 && index < 23 {
                hoursArray.append("\(index):00 - \(index+1):00")
            } else {
                hoursArray.append("23:00 - 00:00")
            }
        }
    }
    
    func getListOfReservations() {
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)\(jsonString)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) {
                data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.reservationArray = try! decoder.decode([Reservation].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.delegate?.reservationListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func addReservation(reservation: Reservation) {
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/\(getNumberOfReservations())\(jsonString)") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(reservation)
            let uploadTask = session.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(response)
                }
                catch {
                    print(error)
                }
            }
            uploadTask.resume()
        }
    }
    
    func getNumberOfHours() -> Int {
        return hoursArray.count
    }
    
    func getHour(for index: Int) -> String? {
        guard index < hoursArray.count
        else {
            return "null"
        }
        return hoursArray[index]
    }
    
    func getNumberOfReservations() -> Int {
        
        return reservationArray.count
    }
    
    func getReservation(for index: Int) -> Reservation? {
        guard index < reservationArray.count
        else {
            return nil
        }
        
        return reservationArray[index]
    }
    
    func getUnavailableTimeslots(date: String) -> [Int]? {
        var unavailableTimeslots: [Int] = []
        
        let reservationArrayCount = max(0, reservationArray.count-1)
        
        if reservationArrayCount > 0 {
            for index in 0...reservationArrayCount {
                if date == reservationArray[index].date {
                    unavailableTimeslots.append(reservationArray[index].hour)
                }
            }
        }
        return unavailableTimeslots
    }
    
    func getReservationListOfUser() {
        
        guard let phoneNumber = Auth.auth().currentUser?.phoneNumber else {return}
        
        if getNumberOfReservations() > 0 {
            for index in 0...getNumberOfReservations()-1 {
                if reservationArray[index].userid == phoneNumber && reservationArray[index].date! >= calendarHelper.dateToString(date: Date()) {
                    reservationArrayOfUser.append(reservationArray[index])
                }
            }
        }
    }
    
    func getNumberOfReservationsOfUser() -> Int {
        return reservationArrayOfUser.count
    }
    
    func getReservationOfUser(for index: Int) -> Reservation? {
        guard index < reservationArrayOfUser.count
        else {
            return nil
        }
        return reservationArrayOfUser[index]
    }
}
