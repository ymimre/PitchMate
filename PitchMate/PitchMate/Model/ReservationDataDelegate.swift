//
//  ReservationDataDelegate.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 3.01.2023.
//

import Foundation

protocol ReservationDataDelegate {
    func reservationListLoaded()
    func reservationListOfUserLoaded()
}

extension ReservationDataDelegate {
    func reservationListLoaded() {}
    func reservationListOfUserLoaded() {}
}
