//
//  ScreenshotTests.swift
//  ScreenshotTests
//
//  Created by Mark Volkmann on 2/22/23.
//

import XCTest

final class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testScreenshots() throws {
        try aboutScreen()
        try peopleScreen()
        try occasionsScreen()
        try giftsScreen()
        try settingsScreen()
    }

    func aboutScreen() throws {
        tapTabBarButton(label: "about-tab")
        try textExists("To use it, follow the steps below:")
        snapshot("1-about")
    }

    func peopleScreen() throws {
        tapTabBarButton(label: "people-tab")
        try textExists("People")
        snapshot("2-people")
    }

    func occasionsScreen() throws {
        tapTabBarButton(label: "occasions-tab")
        try textExists("Occasions")
        snapshot("3-occasions")
    }

    func giftsScreen() throws {
        tapTabBarButton(label: "gifts-tab")
        try textExists("Gifts")
        snapshot("4-gifts")
    }

    func settingsScreen() throws {
        tapTabBarButton(label: "settings-tab")
        try textExists("Settings")
        snapshot("5-settings")
    }
}
