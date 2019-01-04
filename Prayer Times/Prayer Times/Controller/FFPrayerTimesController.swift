//
//  ViewController.swift
//  Prayer Times
//
//  Created by Fisnik Fejzullahu on 1/4/19.
//  Copyright © 2019 Katrori. All rights reserved.
//

import UIKit
import MapKit

class FFPrayerTimesController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var latitude: CLLocationDegrees = 0.0
    var longtitude: CLLocationDegrees = 0.0
    
    var selectedDate = Date()
    
    var arrayPrayerNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
    var arrayPrayerTimes = [String]()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Prayer Time"
        
        locManager.requestWhenInUseAuthorization()
  
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            
            latitude = currentLocation.coordinate.latitude
            longtitude = currentLocation.coordinate.longitude
            
            showPrayerTimesFor(lat: latitude, lng: longtitude, date: selectedDate)
        }
        
        tableView.tableFooterView = UITableView()
        
        calendar.placeholderType = .none
        self.calendar.scope = .week
        self.calendar.select(Date())
        
    }
    
    func showPrayerTimesFor(lat:CLLocationDegrees, lng:CLLocationDegrees, date:Date) {
        
        let coordinates = Coordinates(latitude: lat, longitude: lng)
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)

        var params = CalculationMethod.muslimWorldLeague.params
        let dateComp = cal.dateComponents([.year, .month, .day], from: date)
        params.madhab = .hanafi
        if let prayers = PrayerTimes(coordinates: coordinates, date: dateComp, calculationParameters: params) {
        
            cal.timeZone = .current
 
            arrayPrayerTimes = []
            
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.fajr))
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.sunrise))
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.dhuhr))
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.asr))
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.maghrib))
            arrayPrayerTimes.append(dateFormatter.string(from: prayers.isha))
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

  // MARK: - Table View

extension FFPrayerTimesController: UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPrayerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FFPrayerTimeCell", for: indexPath) as! FFPrayerTimeCell
        
        let name = arrayPrayerNames[indexPath.row]
        let time = arrayPrayerTimes[indexPath.row]

        cell.prayerTitle.text = name
        cell.prayerTime.text = time
        
        return cell
    }
}

extension FFPrayerTimesController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        selectedDate = date
         print("did select date \(self.dateFormatter.string(from: date))")
        showPrayerTimesFor(lat: latitude, lng: longtitude, date: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        
        let gregorianCalendar = Calendar.current
        
        if  gregorianCalendar.isDateInToday(date) {
            return UIColor.red
        } else {
            return appearance.borderDefaultColor
        }
    }
}
