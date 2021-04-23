//
//  StrengthViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit
import MapKit
import CoreLocation

class StrengthViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var exerciseName: UILabel!
    var exercise : Exercise?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    var locationAccess = false
    
    var locationsPassed = [CLLocation]()
    var isRunning = false
    var route: MKPolyline?
    var distanceTraveled = 0.0
    
    var seconds: Int = 60
    var timer = Timer()
 
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseName.text = exercise?.name
        seconds = exercise?.time ?? 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        mapView.delegate = self
        //reset()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        //disableAllButtons()
        startButton.setTitleColor(.green, for: .normal)
        checkLocationServices()
    }
    
//    func reset() {
//        removeOverlays()
//        distanceTraveled = 0
//        locationsPassed.removeAll()
//        route = nil
//    }
    
    
    
    
    
    
    
    
    //timer code
    //*******************************************************************************************************
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(StrengthViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        seconds = exercise?.time ?? 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        resumeTapped = false
        self.pauseButton.setTitle("Pause",for: .normal)
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
//            timerLabel.text = String(seconds)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension StrengthViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
//        if isRunning {
//            addLocationsToArray(locations)
//        }
        
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("MSH: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            //enableButtons()
            //errorView.isHidden = true
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        } else {
//            disableAllButtons()
            locationManager.stopUpdatingLocation()
//            errorView.isHidden = false
//            errorView.setErrorMessage("Location not found")
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //errorView.isHidden = true
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("bad")
//            disableAllButtons()
//            errorView.isHidden = false
//            errorView.setErrorMessage("Please enable Location Services")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("authorized")
            //errorView.isHidden = true
            locationManager.requestLocation()
            centerViewOnUserLocation()
            break
        case .notDetermined:
            print("ask authorized")
            locationManager.requestAlwaysAuthorization()
        default:
            print("not authorized")
            //disableAllButtons()
            //Alert error
            locationManager.stopUpdatingLocation()
//            errorView.isHidden = false
//            errorView.setErrorMessageLocationAlways()
            break
        }
    }
}
