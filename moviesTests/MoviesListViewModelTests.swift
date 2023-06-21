//
//  moviesTests.swift
//  moviesTests
//
//  Created by Sushant Verma on 21/6/2023.
//

import Quick
import Nimble
@testable import movies

final class MoviesListViewModelTests: QuickSpec {
    override class func spec() {
        describe("MoviesListViewModelTests") {
            let viewModel: any MoviesListViewModel = MoviesListViewModelImpl()

            it("has correct page title") {
                expect(viewModel.pageTitle).to(equal("Movies"))
            }
        }
    }
}
