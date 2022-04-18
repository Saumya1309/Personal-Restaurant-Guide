//
//  RouteView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 04/04/22.
//

import SwiftUI
import GoogleMaps
import MapKit

struct RouteView: View
{
    let restaurant: Restaurant
    
    @StateObject var viewModel = RouteViewModel()
        
    var body: some View
    {
        ZStack
        {
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
            viewModel.CheckLocationServicesEnabled(restaurant: restaurant)
        }
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

struct MapViewRoute: UIViewRepresentable
{
    typealias UIViewType = GMSMapView
    
    let restaurantLocation: CLLocationCoordinate2D
    
    let myLocation: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> GMSMapView
    {
        let camera = GMSCameraPosition.camera(withLatitude: restaurantLocation.latitude, longitude: restaurantLocation.longitude, zoom: 6)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context)
    {
        uiView.clear()
        context.coordinator.addMarker(mapView: uiView, restaurantLocation: restaurantLocation, myLocation: myLocation)
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
        let markerSource = GMSMarker()
        markerSource.position = myLocation
        markerSource.title = "You are here"
        markerSource.map = mapView

        let markerDestination = GMSMarker()
        markerDestination.position = restaurantLocation
        markerDestination.title = "Restaurant"
        markerDestination.map = mapView
    }
    
    func DrawDirection(mapView: GMSMapView, restaurantLocation: CLLocationCoordinate2D, myLocation: CLLocationCoordinate2D)
    {
        let origin = "\(myLocation.latitude),\(myLocation.longitude)"
        let destination = "\(restaurantLocation.latitude),\(restaurantLocation.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCdcX0HZa9BxaSy4iCgNzQB6HAuyLjYQKQ"

        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!,options: .allowFragments) as! [String : AnyObject]
                let routes = json["routes"] as! NSArray
                
                OperationQueue.main.addOperation {
                    for route in routes
                    {
                        let routeOverviewPolyline: NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                        let points = routeOverviewPolyline.object(forKey: "points")
                        let path = GMSPath.init(fromEncodedPath: points! as! String)
                        let polyline = GMSPolyline.init(path: path)
                        
                        
                        polyline.strokeWidth = 3
                        polyline.strokeColor = UIColor(Color.blue)
                        
                        let bounds = GMSCoordinateBounds(path: path!)
                        
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
    @Published var locationManager: CLLocationManager?
    
    @Published var distanceToRestaurant: String = ""
    @Published var timeToRestaurant: String = ""

    @State var restaurant = Restaurant(name: "Crazy taco",
                                                       stars: 1,
                                                       image: "placeholder",
                                                       address: "Taco Bell, 10th Street, Great Bend",
                                                       description: "Great tacos",
                                                       phone: "12345",
                                                       tags: ["","Mexican","Organic","",""],
                                                       openTime: "09:30 PM",
                                                       position: CLLocationCoordinate2D(latitude: 19.4509921, longitude: -99.1371576))
    
    @Published var mapView = MapViewRoute(restaurantLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0), myLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
    func CheckLocationServicesEnabled(restaurant: Restaurant)
    {
        if CLLocationManager.locationServicesEnabled()
        {
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
        case .denied:
            print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        CheckLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            locationManager?.startUpdatingLocation()
            print("Found user's location: \(location)")
            
            GetTotalDistance()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func GetTotalDistance()
    {
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
        }).resume()
    }
}
