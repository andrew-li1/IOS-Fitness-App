//
//  StrengthViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit
import MapKit
import CoreLocation

class StrengthViewController: UIViewController {
    
    @IBOutlet weak var exerciseName: UILabel!
    var exercise : Exercise?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    var locationAccess = false
    
    var locationsPassed = [CLLocation]()
    var isRunning = false
    var route: MKPolyline?
    var distanceTraveled = 0.0
    
    var seconds: Int = 60
    var targetDistance: Double = 0.0
    var timer = Timer()
 
    var isTimerRunning = false
    var resumeTapped = false
    var endTapped = false
    //var didNotPressStartAfterReset = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseName.text = exercise?.name
        seconds = exercise?.time ?? 60
        targetDistance = exercise?.distance ?? 0.0
        timerLabel.text = timeString(time: TimeInterval(seconds))
        mapView.delegate = self
        reset()
        setup()
        let loc1 = CLLocation(latitude: 39.954022, longitude: -75.189811)
        let loc2 = CLLocation(latitude: 39.953143, longitude: -75.181932)
        let loc3 = CLLocation(latitude: 39.951688, longitude: -75.182866)
        let loc4 = CLLocation(latitude: 39.952832, longitude: -75.192089)


        locationsPassed.append(loc1)
        locationsPassed.append(loc2)
        locationsPassed.append(loc3)
        locationsPassed.append(loc4)
        self.resetButton.isEnabled = false
        self.pauseButton.isEnabled = false
        //Do any additional setup after loading the view.
    }
    
    func setup() {
        //disableAllButtons()
        startButton.setTitleColor(.green, for: .normal)
        checkLocationServices()
    }
    
    func addLocationsToArray(_ locations: [CLLocation]) {
        for location in locations {
            if !locationsPassed.contains(location) {
                locationsPassed.append(location)
            }
        }
        print(locations)
    }

    @IBAction func locationButtonPressed(_ sender: Any) {
        centerViewOnUserLocation()
    }
    
    func startRun() {
        isRunning = true
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation() //need to change because we are resuming and pausing
        //not selecting new initial point
    }
    
    func stopRun() {
        isRunning = false
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.stopUpdatingLocation()
        displayRoute()
    }
    
    func calculateAndDisplayDistance() {
        var totalDistance = 0.0
        for i in 1..<locationsPassed.count {
            let previousLocation = locationsPassed[i-1]
            let currentLocation = locationsPassed[i]
            totalDistance += currentLocation.distance(from: previousLocation)
        }
        distanceTraveled = totalDistance
        
        if distanceTraveled * 0.001 >= Double(targetDistance) {
            distance.backgroundColor = UIColor.systemGreen
        }
        
        let displayDistance: String
        
        displayDistance = String(format: "Distance Ran: %.2f km", distanceTraveled * 0.001)
        
        distance.text = displayDistance
    }
    
    
    
    
    
    //timer code
    //*******************************************************************************************************
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            centerViewOnUserLocation()
            runTimer()
            startRun()
            self.startButton.isEnabled = false
            self.resetButton.isEnabled = true
            self.pauseButton.isEnabled = true
            //didNotPressStartAfterReset = false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(StrengthViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if self.resumeTapped == false {
            isRunning = false
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            //stopRun()
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            isRunning = true
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            //startRun()
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if self.endTapped == false {
            timer.invalidate()
            //seconds = exercise?.time ?? 60
            //timerLabel.text = timeString(time: TimeInterval(seconds))
            isTimerRunning = false
            resumeTapped = false
            self.pauseButton.setTitle("Pause",for: .normal)
            pauseButton.isEnabled = false
            startButton.isEnabled = true
            stopRun()
            self.endTapped = true
            self.resetButton.setTitle("Reset",for: .normal)
            self.pauseButton.isEnabled = true
            self.startButton.isEnabled = false
        } else {
            timer.invalidate()
            seconds = exercise?.time ?? 60
            timerLabel.text = timeString(time: TimeInterval(seconds))
            isTimerRunning = false
            resumeTapped = false
            self.pauseButton.setTitle("Pause",for: .normal)
            pauseButton.isEnabled = false
            startButton.isEnabled = true
            self.endTapped = false
            self.resetButton.setTitle("End",for: .normal)
            //didNotPressStartAfterReset = true
            self.resetButton.isEnabled = false
            self.startButton.isEnabled = true
            reset()
            let displayDistance = String(format: "Distance Ran: %.2f km", distanceTraveled * 0.001)
            
            distance.text = displayDistance
        }
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.endTapped = true
            self.resetButton.setTitle("Reset",for: .normal)
            self.pauseButton.isEnabled = false
            stopRun()
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

extension StrengthViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        renderer.alpha = 0.5
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let id = "pin"
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = annotation.coordinateType == .start ? .green : .red
            view.calloutOffset = CGPoint(x: -8, y: -3)
            
            return view
        }
        return nil
    }
    
    func displayRoute() {
        
        var routeCoordinates = [CLLocationCoordinate2D]()
        for location in locationsPassed {
            routeCoordinates.append(location.coordinate)
        }
        route = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        guard let route = route else { return }
        mapView.addOverlay(route)
        mapView.setVisibleMapRect(route.boundingMapRect, edgePadding: UIEdgeInsets(top: 200, left: 50, bottom: 50, right: 50), animated: true)
        
        calculateAndDisplayDistance()
        setupAnnotations()
    }
    
    func displayRouteWhileRunning() {

        var routeCoordinates = [CLLocationCoordinate2D]()
        for location in locationsPassed {
            routeCoordinates.append(location.coordinate)
        }
        route = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        guard let route = route else { return }
        mapView.addOverlay(route)
        mapView.setVisibleMapRect(route.boundingMapRect, edgePadding: UIEdgeInsets(top: 200, left: 50, bottom: 50, right: 50), animated: true)

        calculateAndDisplayDistance()
    }
    
    func setupAnnotations() {
        guard let startLocation = locationsPassed.first?.coordinate, let endLocation = locationsPassed.last?.coordinate, locationsPassed.count > 1 else {
            return
        }
        let startAnnotation = CustomAnnotation(coordinateType: .start, coordinate: startLocation)
        let endAnnotation = CustomAnnotation(coordinateType: .end, coordinate: endLocation)
        
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
    }
    
    func removeOverlays() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    func reset() {
        removeOverlays()
        distanceTraveled = 0
        locationsPassed.removeAll()
        route = nil
        distance.backgroundColor = UIColor.systemRed
        distance.text = "Distance Ran: 0.00 km"
    }
}


extension StrengthViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if isRunning {
            addLocationsToArray(locations)
            displayRouteWhileRunning()
        }
        
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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("bad")
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
            locationManager.requestLocation()
            centerViewOnUserLocation()
            break
        case .notDetermined:
            print("ask authorized")
            locationManager.requestAlwaysAuthorization()
        default:
            print("not authorized")
            locationManager.stopUpdatingLocation()
            break
        }
    }
}
