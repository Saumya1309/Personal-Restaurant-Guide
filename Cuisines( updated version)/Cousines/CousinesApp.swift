import SwiftUI
import GoogleMaps

@main
struct CousinesApp: App
{
    // We init the google services with our api key so we can use Google Maps later on
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
