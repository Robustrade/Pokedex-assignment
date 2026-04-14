//
//  HapticsManager.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import UIKit

protocol HapticsProviding {
    func favouriteAdded()
}

final class HapticsManager: HapticsProviding {
    static let shared = HapticsManager()

    private init() {}

    func favouriteAdded() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
