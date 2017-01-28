//
//  HomePageViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 1/22/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class HomePageViewController: UIViewController,CLLocationManagerDelegate {

    var mapView:GMSMapView!
    var locationManager = CLLocationManager()
    var location:CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Navigation Drawer
        /*navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: Selector("didTapOpenButton:")
        )*/
        //Google Maps Integration
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse /*|| CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized*/){
            location=locationManager.location
            //let camera=GMSCameraPosition.camera(withLatitude: 37.785834, longitude: -122.406417, zoom: 6.0)
            let camera=GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6.0)
            mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view.addSubview(mapView)
            //self.location
            let marker=GMSMarker()
            //marker.position=CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
            marker.position=CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //marker.title = "You"
            marker.map=mapView
            //Map ends here
            
        }
    
    }
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location=locations.first
        let camera=GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6.0)
        mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view.addSubview(mapView)
        let marker=GMSMarker()
        //marker.position=CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
        marker.position=CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //marker.title = "You"
        marker.map=mapView
    }*/
    
    func didTapOpenButton(sender: UIBarButtonItem) {
//        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
//            drawerController.setDrawerState(.Opened, animated: true)
//        }
    }

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
