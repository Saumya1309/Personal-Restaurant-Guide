import SwiftUI
import GoogleMaps
import MapKit

struct RouteView: View
{
    let restaurant: Restaurant
    
    // Object that holds all the infomration related to the map
    @StateObject var viewModel = RouteViewModel()
    
    var body: some View
    {
        ZStack
        {
            // Shows the map of the viewModel just like the PlaceView
            viewModel.mapView
                .edgesIgnoringSafeArea(.all)
            
            VStack
            {
                HStack (alignment: .center)
                {
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            VStack
                            {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            
                            VStack
                            {
                                Text("Your location")
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 40, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color("BGColor"))
                                
                                Text(restaurant.name)
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 40, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color("BGColor"))
                            }
                        }
                    }
                }
                .frame(width: 250, height: 100)
                .background(Color.accentColor)
                
                Spacer()
                
                VStack(alignment: .leading)
                {
                    Text("\(viewModel.timeToRestaurant) (\(viewModel.distanceToRestaurant))")
                        .padding()
                    Text("Fastest route now due to traffic conditions")
                        .padding()
                }
                .background(.white)
                .padding()
            }
        }
        .onAppear{
            // When the view loads we check if we have location permission to calculate the route
            viewModel.CheckLocationServicesEnabled(restaurant: restaurant)
        }
    }
}


struct MapViewRoute: UIViewRepresentable
{
    typealias UIViewType = GMSMapView
    
    let restaurantLocation: CLLocationCoordinate2D
    
    let myLocation: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> GMSMapView
    {
        // Moves the camera to the restaurant position
        let camera = GMSCameraPosition.camera(withLatitude: restaurantLocation.latitude, longitude: restaurantLocation.longitude, zoom: 6)
        // We create the map and go to the camera location
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }
    
    // This method fires when we update our location
    func updateUIView(_ uiView: GMSMapView, context: Context)
    {
        // Clear the past route and markers
        uiView.clear()
        // Adds a marker in our location and at the restaurant location
        context.coordinator.addMarker(mapView: uiView, restaurantLocation: restaurantLocation, myLocation: myLocation)
        
        // Draws the route to follow
        context.coordinator.DrawDirection(mapView: uiView, restaurantLocation: restaurantLocation, myLocation: myLocation)
    }
    
    func makeCoordinator() -> CoordinatorRoute
    {
        return CoordinatorRoute()
    }
}

class CoordinatorRoute: NSObject
{
    func addMarker(mapView: GMSMapView, restaurantLocation: CLLocationCoordinate2D, myLocation: CLLocationCoordinate2D)
    {
        
        // Our location
        let markerSource = GMSMarker()
        markerSource.position = myLocation
        markerSource.title = "You are here"
        markerSource.map = mapView
        
        // Restaurant location
        let markerDestination = GMSMarker()
        markerDestination.position = restaurantLocation
        markerDestination.title = "Restaurant"
        markerDestination.map = mapView
    }
    
    func DrawDirection(mapView: GMSMapView, restaurantLocation: CLLocationCoordinate2D, myLocation: CLLocationCoordinate2D)
    {
        // We add the origin and destination location to a string so that it looks like this
        // example: "19.043456,109.345063"
        let origin = "\(myLocation.latitude),\(myLocation.longitude)"
        let destination = "\(restaurantLocation.latitude),\(restaurantLocation.longitude)"
        
        // We get the route data in json, to get it we use the link provided by google where we have to change the origin, location and the api key for ours
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCdcX0HZa9BxaSy4iCgNzQB6HAuyLjYQKQ"
        
        // We convert the urlString to URL
        let url = URL(string: urlString)
        
        // We try to get the data
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            do
            {
                // Deserialice the json and add the result to a NSArray
                let json = try JSONSerialization.jsonObject(with: data!,options: .allowFragments) as! [String : AnyObject]
                let routes = json["routes"] as! NSArray
                
                OperationQueue.main.addOperation {
                    // Because what we get is not a route as a whole, but a bunch of parts, like turn left, right, forward, etc
                    // we have to loop through and draw each part
                    for route in routes
                    {
                        // We get the points from the previous json array
                        let routeOverviewPolyline: NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                        
                        // For all the points we create a line
                        let points = routeOverviewPolyline.object(forKey: "points")
                        let path = GMSPath.init(fromEncodedPath: points! as! String)
                        let polyline = GMSPolyline.init(path: path)
                        
                        polyline.strokeWidth = 3
                        polyline.strokeColor = UIColor(Color.blue)
                        
                        // Get the bounds of the path so we can correctly move the camera to
                        // show the whole route
                        let bounds = GMSCoordinateBounds(path: path!)
                        
                        // Animates the camera to move to fit the route inside the screen
                        mapView.animate(with: GMSCameraUpdate.fit(bounds,withPadding: 30.0))
                        polyline.map = mapView
                    }
                }
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }).resume()
    }
}

final class RouteViewModel: NSObject, ObservableObject, CLLocationManagerDelegate
{
    // Location manager to check the current location as well as ask for permissions
    @Published var locationManager: CLLocationManager?
    
    @Published var distanceToRestaurant: String = ""
    @Published var timeToRestaurant: String = ""
    
    // Random data so the app doesn't crash if it has problems with the location manager
    @State var restaurant = Restaurant(name: "Crazy taco",
                                       stars: 1,
                                       image: "placeholder",
                                       address: "Taco Bell, 10th Street, Great Bend",
                                       description: "Great tacos",
                                       phone: "12345",
                                       tags: ["","Mexican","Organic","",""],
                                       openTime: "09:30 PM",
                                       position: CLLocationCoordinate2D(latitude: 19.4509921, longitude: -99.1371576))
    
    // Reference to the current map
    @Published var mapView = MapViewRoute(restaurantLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0), myLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    func CheckLocationServicesEnabled(restaurant: Restaurant)
    {
        if CLLocationManager.locationServicesEnabled()
        {
            // If location services are enabled then assign that
            // as well as fill the restaurant information
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            self.restaurant = restaurant
        }
        else
        {
            print("Error creating location manager")
        }
    }
    
    private func CheckLocationPermission()
    {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus
        {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
            locationManager.stopUpdatingLocation()
        case .denied:
            print("Denied")
            locationManager.stopUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // If we have permissions then start drawing the route
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        CheckLocationPermission() // If the user changed the permissions then we re check the current status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            locationManager?.startUpdatingLocation()
            print("Found user's location: \(location)")
            
            // Gets the distan, time and draws the route from the current location to the restaurant
            GetTotalDistance()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func GetTotalDistance()
    {
        // We do the same as the DrawDirections method
        
        let origin = "\(locationManager!.location!.coordinate.latitude),\(locationManager!.location!.coordinate.longitude)"
        let destination = "\(restaurant.position.latitude),\(restaurant.position.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&units=imperial&mode=driving&language=en-EN&sensor=false&key=AIzaSyCdcX0HZa9BxaSy4iCgNzQB6HAuyLjYQKQ"
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!,options: .allowFragments) as! [String : AnyObject]
                let rows = json["rows"] as! NSArray
                
                let dic = rows[0] as! Dictionary<String, Any>
                let elements = dic["elements"] as! NSArray
                let dis = elements[0] as! Dictionary<String, Any>
                let distanceKilometers = dis["distance"] as! Dictionary<String, Any>
                let kilometers = distanceKilometers["text"]! as! String
                
                let rideTime = dis["duration"] as! Dictionary<String, Any>
                let time = rideTime["text"]! as! String
                
                let restaurantLocation = CLLocationCoordinate2D(latitude: self.restaurant.position.latitude, longitude: self.restaurant.position.longitude)
                let myLocation = CLLocationCoordinate2D(latitude: self.locationManager!.location!.coordinate.latitude, longitude: self.locationManager!.location!.coordinate.longitude)
                
                // Once we have all the data we need, we have to update from the main thread as it's only possible to do it from there
                // otherwise changes wont reflect
                DispatchQueue.main.async {
                    self.distanceToRestaurant = kilometers
                    self.timeToRestaurant = time
                    self.mapView = MapViewRoute(restaurantLocation: restaurantLocation, myLocation: myLocation)
                }
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }).resume() // Resume means we launch all the code above
    }
}

struct RouteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        RouteView(restaurant: Restaurant(name: "Crazy taco",
                                         stars: 1,
                                         image: "placeholder",
                                         address: "Taco Bell, 10th Street, Great Bend",
                                         description: "Great tacos",
                                         phone: "12345",
                                         tags: ["","Mexican","Organic","",""],
                                         openTime: "09:30 PM",
                                         position: CLLocationCoordinate2D(latitude: 19.4509921, longitude: -99.1371576)))
    }
}
