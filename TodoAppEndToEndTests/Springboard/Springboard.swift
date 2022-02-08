//
//  Springboard.swift
//  TodoAppEndToEndTests
//
//  Created by Yasuhiro Yoshida on 2022-02-09.
//

import XCTest

class Springboard {
  static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

  class func deleteApp() {

    XCUIApplication().terminate()
    springboard.activate()

    let icon = springboard.icons.matching(identifier: "TodoApp").firstMatch
    icon.press(forDuration: 1.3)

    if springboard.buttons["Remove App"].waitForExistence(timeout: 5.0) {
      springboard.buttons["Remove App"].tap()

      if springboard.alerts.buttons["Delete App"].waitForExistence(timeout: 5.0) {
        springboard.alerts.buttons["Delete App"].tap()

        if springboard.alerts.buttons["Delete"].waitForExistence(timeout: 5.0) {
          springboard.alerts.buttons["Delete"].tap()
        } else  {
          error("Delete")
        }
      } else {
        error("Delete App")
      }
    } else {
      error("Remove App")
    }
  }

  private class func error(_ forWhat: String) {
    fatalError("Could not delete app - '\(forWhat)' button was not captured")
  }
}
