//
//  MotionManager.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 12.06.26.
//
import Foundation
import CoreMotion
import Combine

@MainActor
final class MotionManager: ObservableObject {

    static let shared =
        MotionManager()

    @Published var x: Double = 0
    @Published var y: Double = 0

    private let manager =
        CMMotionManager()

    private init() {

        manager.deviceMotionUpdateInterval =
            1.0 / 60.0

        manager.startDeviceMotionUpdates(
            to: .main
        ) { [weak self] motion, _ in

            guard let motion else {
                return
            }

            let roll =
                motion.attitude.roll

            let pitch =
                motion.attitude.pitch

            self?.x =
                abs(roll) > 0.15
                ? roll
                : 0

            self?.y =
                abs(pitch) > 0.15
                ? pitch
                : 0
        }
    }
}
