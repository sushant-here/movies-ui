//
//  Resolver.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation

import Foundation

class Resolver{

    static let shared = Resolver()
    var factoryDict: [String: () -> Any] = [:]

    init() {
//        add(type: Protocol.self, { return Implementation() })
        add(type: MoviesService.self, { return TheMovieDBService() })
    }

    func add<Component>(type: Component.Type, _ factory: @escaping () -> Component) {
        factoryDict[String(describing: type.self)] = factory
    }

    func resolve<Component>(_ type: Component.Type) -> Component {
        let component: Component = factoryDict[String(describing:Component.self)]?() as! Component
        return component
    }
}
