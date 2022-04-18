//
//  RouteView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 04/04/22.
//

import SwiftUI
import GoogleMaps

struct PlaceView: View
{
    @State var restaurant: Restaurant
    
    var body: some View
    {
        VStack
        {
            ZStack
            {
                MapView(place: $restaurant)
                
                GeometryReader { geometry in
                    NavigationLink(destination: RouteView(restaurant: restaurant), label: {
                        Text("Start")
                            .frame(width: 110, height: 50)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    })
                    .position(x: geometry.size.width-geometry.size.width/6, y: geometry.size.height-geometry.size.height/15)
                }
                
            }
            
            Spacer()
            HStack
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    Text("Name:")
                    Text("Phone:")
                    Text("Address:")
                    Text("Rating:")
                    Text("Hours:")
                }
                .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 20)
                {
                    Text(restaurant.name)
                    Text(restaurant.phone)
                    Text(restaurant.address)
                    Text("\(restaurant.stars) of 5")
                    Text("Open till \(restaurant.openTime)")
                }
            }
            .padding()
        }
    }
}

struct MapView: UIViewRepresentable
{
    typealias UIViewType = GMSMapView
    
    @Binding var place: Restaurant
    
    func makeUIView(context: Context) -> GMSMapView
    {
        let camera = GMSCameraPosition.camera(withLatitude: place.position.latitude, longitude: place.position.longitude, zoom: 6)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context)
    {
        context.coordinator.addMarker(mapView: uiView)
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(place)
    }
}

class Coordinator: NSObject
{
    private let place: Restaurant
    
    init(_ place: Restaurant)
    {
        self.place = place
    }
    
    func addMarker(mapView: GMSMapView)
    {
        let marker = GMSMarker()
        marker.position = place.position
        marker.title = place.name
        marker.snippet = place.address
        marker.map = mapView
    }
}

extension Coordinator: GMSMapViewDelegate
{
    func mapViewSnapshotReady(_ mapView: GMSMapView)
    {
        mapView.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.init(latitude: place.position.latitude, longitude: place.position.longitude, zoom: 15)))
    }
}

struct PlaceView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlaceView(restaurant: Restaurant(name: "Crazy taco",
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
