//
//  TodoAppEndToEndTests.swift
//  TodoAppEndToEndTests
//
//  Created by Yasuhiro Yoshida on 2022/02/08.
//

import XCTest

class WhenAppIsLaunched: XCTestCase {

  func testItShouldNotDisplayAnyTasks() {
    let app = XCUIApplication()
    continueAfterFailure = false
    app.launch()

    XCUIDevice.shared.orientation = UIDeviceOrientation.portrait;

    let tasksList = app.tables["tasksList"]
    XCTAssertEqual(tasksList.cells.count, 0)
  }

  override func tearDown() {
    Springboard.deleteApp()
  }
}

class WhenUserSavesANewTask: XCTestCase {

  func testItShouldBeAbleToDisplayTaskSuccessfully() {
    let app = XCUIApplication()
    continueAfterFailure = false
    app.launch()

    XCUIDevice.shared.orientation = UIDeviceOrientation.portrait;

    let titleTextField = app.textFields["titleTextField"]
    titleTextField.tap()
    titleTextField.typeText("Task A")

    let descriptionTextField = app.textFields["descriptionTextField"]
    descriptionTextField.tap()
    descriptionTextField.typeText("Task A description")

    let saveButton = app.buttons["saveButton"]
    saveButton.tap()

    let tasksList = app.tables["tasksList"]

    XCTAssertEqual(tasksList.cells.count, 1)
  }

  func testItDisplaysErrorMessageWhenTitleAlreadyExists() {
    let app = XCUIApplication()
    continueAfterFailure = false
    app.launch()

    XCUIDevice.shared.orientation = UIDeviceOrientation.portrait;

    let titleTextField = app.textFields["titleTextField"]
    titleTextField.tap()
    titleTextField.typeText("Task A")

    let descriptionTextField = app.textFields["descriptionTextField"]
    descriptionTextField.tap()
    descriptionTextField.typeText("Task A description")

    let saveButton = app.buttons["saveButton"]
    saveButton.tap()

    titleTextField.tap()
    titleTextField.typeText("Task A")

    saveButton.tap()

    let errorMessage = app.staticTexts["errorMessage"]
    XCTAssertEqual(errorMessage.label, "Task has already been added")

    let tasksList = app.tables["tasksList"]
    XCTAssertEqual(tasksList.cells.count, 1)
  }

  override func tearDown() {
    Springboard.deleteApp()
  }
}

class WhenUserDeletesTask: XCTestCase {

  private var app: XCUIApplication!

  override func setUp() {
    app = XCUIApplication()
    continueAfterFailure = false
    app.launch()

    XCUIDevice.shared.orientation = UIDeviceOrientation.portrait;

    let titleTextField = app.textFields["titleTextField"]
    titleTextField.tap()
    titleTextField.typeText("Task A")
    let descriptionTextField = app.textFields["descriptionTextField"]
    descriptionTextField.tap()
    descriptionTextField.typeText("Task A description")
    let saveButton = app.buttons["saveButton"]
    saveButton.tap()
  }

  func testItShouldDeleteTaskSuccessfully() {
    let tasksList = app.tables["tasksList"]
    XCTAssertEqual(tasksList.cells.count, 1)

    let cell = app.tables["tasksList"].cells["Task A, Medium"]
    cell.swipeLeft()
    app.tables["tasksList"].buttons["Delete"].tap()

    XCTAssertEqual(tasksList.cells.count, 0)
    XCTAssertFalse(cell.exists)
  }

  override func tearDown() {
    Springboard.deleteApp()
  }
}

class WhenUserMarksTaskAsFavorite: XCTestCase {

  var app: XCUIApplication!

  override func setUp() {
    app = XCUIApplication()
    continueAfterFailure = false
    app.launch()

    XCUIDevice.shared.orientation = UIDeviceOrientation.portrait;

    let titleTextField = app.textFields["titleTextField"]
    titleTextField.tap()
    titleTextField.typeText("Task A")

    let descriptionTextField = app.textFields["descriptionTextField"]
    descriptionTextField.tap()
    descriptionTextField.typeText("Task A description")

    let saveButton = app.buttons["saveButton"]
    saveButton.tap()
  }

  func testItShouldMarkAsFavorite() {
    let tasksList = app.tables["tasksList"]
    let cell = tasksList.cells["Task A, Medium"]
    cell.tap()

    app.images["favoriteImage"].tap()
    app.buttons["closeButton"].tap()

    XCTAssertTrue(tasksList.cells["Task A, heart.fill, Medium"].exists)
  }

  override func tearDown() {
    Springboard.deleteApp()
  }
}

