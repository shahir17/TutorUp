//
//  SearchViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 9/16/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var window: UIWindow?
    
    
    let mapView: MKMapView = {
        var map = MKMapView()
        map.showsPointsOfInterest = true
        map.showsBuildings = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
        
    }()
    
    let searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.placeholder = "Search for Places"
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let searchAreaButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Search ", for: .normal)
        button.addTarget(self, action: #selector(handleSearchArea), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.alpha = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
        
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("error")
            }
            else {
                //removing annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                //getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //zoom in 
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    func handleSearchArea(){
        
        //let searchController = UISearchController(searchResultsController: nil)
        //searchController.searchBar.delegate = self
        //present(searchController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "Search"
        self.window = UIWindow(frame: UIScreen.main.bounds)
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Configure", style: .plain, target: self, action: #selector(handleConfigure))
        view.addSubview(mapView)
        view.addSubview(searchAreaButton)
                    view.bringSubview(toFront: searchAreaButton)
        view.addSubview(searchBar)
        
         
        setupMapView()
        changeSearchButtonTextWhenCityEntered()
        
        //user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }

    }
    func setupMapView(){
        //x,y,w,h
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 30).isActive = true
        
        //button
        searchAreaButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        searchAreaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchAreaButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchAreaButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        
        //search bar
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func handleConfigure(){
        tabBarController?.selectedIndex = 3
    }
    
    
    func changeSearchButtonTextWhenCityEntered(){
        
       
    }
    
    
    func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            let alertController = UIAlertController(title: "Error", message: logoutError.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)

        }
        
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
        
    }


    

    }
