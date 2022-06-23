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
    
    private var sut : ChooseAddressViewModelType!
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

    

}
