//
//  LocationSelectorViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 2/5/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import GoogleMaps
//import CoreLocation
import GooglePlaces

class LocationSelectorViewController: UIViewController,CLLocationManagerDelegate,UISearchBarDelegate,GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate {

    var locationManager = CLLocationManager()
    var location:CLLocation!
    var mapView:GMSMapView!
    var rCoordinate:CLLocationCoordinate2D!
    var resultsArray=[String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            locationManager.requestLocation()
            location=locationManager.location
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
            location=locationManager.location
            let camera=GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate=self
            mapView.isMyLocationEnabled=true
            mapView.settings.myLocationButton = true
            mapView.camera=camera
            mapView.padding = UIEdgeInsetsMake(0, 0, 40, 0)
            view = mapView
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title="Rendezvous Point"
        marker.map=self.mapView
        let alert = UIAlertController(title: "Rendezvous Point", message: "Set this location as your Rendezvous Point", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.rCoordinate=coordinate
            self.performSegue(withIdentifier: "Finalize", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction!) in
            marker.map = nil
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Finalize"){
            let destination = segue.destination as? AddMembersViewController
            destination?.rCoordinate = rCoordinate
        }
    }
    
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }*/
    
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title="Rendezvous Point"
        marker.map=mapView
    }*/
    
    @IBAction func search(_ sender: AnyObject) {
        let searchControl = GMSAutocompleteViewController()//UISearchController(searchResultsController: nil)
        searchControl.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(searchControl,animated: true,completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        self.mapView.camera=camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Failed to auto complete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //Delete
    /*func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async {
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            let camera=GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10.0)
            self.mapView.camera=camera
            marker.title="Address: \(title)"
            marker.map=self.mapView
        }
    }*/
    
    //textChange in search bar function
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil,callback: {(results,error:Error?) -> Void in
            self.resultsArray.removeAll()
            if results == nil{
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            //self.searchResultController.reloa
        })
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
