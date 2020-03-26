//
//  ViewController.swift
//  CountryRegion
//
//  Created by Andrii Tishchenko on 26.03.2020.
//  Copyright © 2020 Andrii Tishchenko. All rights reserved.
//

import UIKit
import MapKit


enum GeoError: Error {
    case invalidType
}

class ViewController: UIViewController {

  @IBOutlet weak var mmap: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vahvah(filename: "ukr.geo")
    vahvah(filename: "hun.geo")

}
  
  
  func vahvah(filename:String){
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
             fatalError("Couldn't find \(filename) in main bundle.")
         }
         do {
              let data: Data = try Data(contentsOf: file)
              let decoder = MKGeoJSONDecoder()
              let geoJSONFeatures = try decoder.decode(data)
              
              guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
                throw GeoError.invalidType
              }
              let geometry = features.flatMap({ $0.geometry })
              let ov = geometry.compactMap({ $0 as? MKOverlay })
              
              self.mmap.addOverlays(ov)
         } catch {
             fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
         }
      
    }
  }


extension ViewController:MKMapViewDelegate{
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKMultiPolygon {
          let polygonView =  MKMultiPolygonRenderer(overlay: overlay)
          polygonView.strokeColor = UIColor.magenta
          polygonView.fillColor = UIColor.green
          return polygonView
    }
    if overlay is MKPolygon {
          let polygonView =  MKPolygonRenderer(overlay: overlay)
          polygonView.strokeColor = UIColor.magenta
          polygonView.fillColor = UIColor.red
          return polygonView
    }
    return MKOverlayRenderer()
  }
}
