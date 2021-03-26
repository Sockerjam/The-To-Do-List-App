//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Niclas Jeppsson on 26/03/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoListTests: XCTestCase {

    var toDoListVC:ToDoListViewController!
    var addItemVC:AddItemVC!
    
    override func setUp() {
        toDoListVC = ToDoListViewController(viewModel: ToDoListModelImpl())
        addItemVC = AddItemVC(with: ToDoListModelImpl())
    }
    
    override func tearDown() {
        toDoListVC = nil
        addItemVC = nil
    }
    
    func testViewController(){
        if addItemVC.isBeingPresented {
            XCTAssert(toDoListVC.navigationController?.topViewController == toDoListVC)
            XCTAssert(addItemVC.navigationController?.topViewController == addItemVC)
        }
    }

}
