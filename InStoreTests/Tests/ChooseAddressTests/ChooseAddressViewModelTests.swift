//
//  ChooseAddressViewModelTests.swift
//  InStoreTests
//
//  Created by sandra on 6/23/22.
//  Copyright © 2022 mac. All rights reserved.
//

import XCTest
@testable import InStore

class ChooseAddressViewModelTests: XCTestCase {
    
    private var sut : ChooseAddressViewModel!
    private var repo : RepositoryProtocol!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        repo = MockRepository(localDataSource: MockLocalDataSource(), apiClient: MockAPIClient(fileName: "ChooseAddresses"))
        sut = ChooseAddressViewModel(repo: repo, myOrder: PostOrderRequest())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repo = nil
        sut = nil
    }

    func testSut_whenInitCalled_repoIsSet(){
        XCTAssertNotNil(sut.repo)
    }
    
    func testSut_whenInitCalled_myOrderIsSet(){
        XCTAssertNotNil(sut.myOrder)
    }

    func testSut_whenGetDataCalled_allAddressesReturn(){
        sut.getData()
        XCTAssertEqual(sut.addressesList.count, 3)
    }
    
    func testSut_whenFailToCallNetwork_stateEmptyReturn(){
        repo = MockRepository(localDataSource: MockLocalDataSource(), apiClient: MockAPIClient(fileName: "Error"))
        sut = ChooseAddressViewModel(repo: repo, myOrder: PostOrderRequest())
        sut.getData()
        XCTAssertTrue(sut.addressesList.isEmpty)
        XCTAssertEqual(sut.state, .empty)
    }
    }
