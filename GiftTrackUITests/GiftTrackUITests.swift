import XCTest

final class GiftTrackUITests: XCTestCase {
    let waitSeconds = 100.0

    override func setUpWithError() throws {
        XCUIApplication().launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testApp() throws {
        try aboutScreen()
        try peopleScreen()
        try occasionsScreen()
        try giftsScreen()
        try settingsScreen()
    }

    func aboutScreen() throws {
        tapTabBarButton(label: "about-tab")
        try textExists("To use it, follow the steps below:")
    }

    func peopleScreen() throws {
        tapTabBarButton(label: "people-tab")
        try textExists("People")
    }

    func occasionsScreen() throws {
        tapTabBarButton(label: "occasions-tab")
        try textExists("Occasions")
    }

    func giftsScreen() throws {
        tapTabBarButton(label: "gifts-tab")
        try textExists("Gifts")
    }

    func settingsScreen() throws {
        tapTabBarButton(label: "settings-tab")
        try textExists("Settings")
    }
}
