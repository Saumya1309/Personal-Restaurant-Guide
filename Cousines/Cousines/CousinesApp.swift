//
//  CousinesApp.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI
import GoogleMaps

@main
struct CousinesApp: App
{
    init()
    {
        GMSServices.provideAPIKey("AIzaSyCdcX0HZa9BxaSy4iCgNzQB6HAuyLjYQKQ")
    }
    
    var body: some Scene
    {
        WindowGroup
        {
            SignInView()
        }
    }
}
