//
//  ToDoListUITests.swift
//  ToDoListUITests
//
//  Created by Niclas Jeppsson on 26/03/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoListUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
    
    func testAddNewItemButton(){
        // 1. Given
        let addItemButton = app.navigationBars["The Task Completer"].buttons["add"]
        let addItemView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        // 3. Then
        addItemButton.tap()
        XCTAssert(addItemView.exists)
    }
    
    func testCancelButton(){
        // 1. Given
        let addItemButton = app.navigationBars["The Task Completer"].buttons["add"]
        let cancelButton = app.buttons["Cancel"]
    
        // 3. Then
        addItemButton.tap()
        XCTAssert(cancelButton.isHittable)
        
    }
    
    override func tearDown() {
        app = nil
    }
    
    
    
}
