//
//  ViewController.swift
//  geocording
//
//  Created by D7703_29 on 2017. 9. 25..
//  Copyright © 2017년 D7703_29. All rights reserved.
//

import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    
    //var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        zoomToRegion()
        
        /////////////////////////////
        
        let path = Bundle.main.path(forResource: "pinmark", ofType: "plist")
        print("path = \(String(describing: path))")
        
        let contents = NSArray(contentsOfFile: path!)
        print("path = \(String(describing: contents))")
        
        var annotations = [MKPointAnnotation]()
        
        map.delegate = self
        
        // optional binding
        if let myItems = contents {
            // Dictionary Array에서 값 뽑기
            for item in myItems {
                let address = (item as AnyObject).value(forKey: "address")
                let title = (item as AnyObject).value(forKey: "title")
                
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address as! String, completionHandler: { placemarks, error in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        print("placemark[0] = \(String(describing: myPlacemark.name))")
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = title as? String
                        annotation.subtitle = address as? String
                        
                        if let myLocation = myPlacemark.location {
                            annotation.coordinate = myLocation.coordinate
                            annotations.append(annotation)
                        }
                        
                    }
                    print("annotations = \(annotations)")
                    self.map.showAnnotations(annotations, animated: true)
                    self.map.addAnnotations(annotations)
                    
                })
            }
        } else {
            print("contents의 값은 nil")
        }
        
    }

    func zoomToRegion() {
        
        //  DIT 위치정보 35.166197, 129.072594
        let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(center, span)
        
        map.setRegion(region, animated: true)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myPin"
        
        // an already allocated annotation view
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            //annotationView?.pinTintColor = UIColor.green
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        if annotation.title! == "양정역" {
            leftIconView.image = UIImage(named:"zenos1.jpeg" )
            annotationView?.pinTintColor = UIColor.green
        }
        if annotation.title! == "동의과학대학" {
            leftIconView.image = UIImage(named:"zenos2.jpeg" )
            annotationView?.pinTintColor = UIColor.blue
        }
        if annotation.title! == "부산여자대학교" {
            leftIconView.image = UIImage(named:"zenos3.png" )
            annotationView?.pinTintColor = UIColor.black
        }
        if annotation.title! == "양정 대원칸타빌" {
            leftIconView.image = UIImage(named:"zenos4.png" )
            annotationView?.pinTintColor = UIColor.cyan
        }
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
        
    }


}

