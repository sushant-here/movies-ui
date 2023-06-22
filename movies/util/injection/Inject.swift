//
//  Inject.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation

@propertyWrapper
struct Inject<Component>{

    var component: Component

    init(){
        self.component = Resolver.shared.resolve(Component.self)
    }

    public var wrappedValue:Component{
        get { return component}
        mutating set { component = newValue }
    }

}
