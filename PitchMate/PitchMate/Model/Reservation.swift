//
//  Reservation.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 3.01.2023.
//

import Foundation

struct Reservation: Decodable, Encodable {
    var date: String?
    var hour: Int
    var reservation_id: String?
    var userid: String?
}
