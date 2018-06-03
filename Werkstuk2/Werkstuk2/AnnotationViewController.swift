//
//  AnnotationViewController.swift
//  Werkstuk2
//
//  Created by student on 03/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {
    
    var station = Station()
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var bonus: UILabel!
    @IBOutlet weak var banking: UILabel!
    @IBOutlet weak var bikes: UILabel!
    @IBOutlet weak var avbikes: UILabel!
    @IBOutlet weak var avspaces: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let good = NSLocalizedString("OK", comment: "")
        let bad = NSLocalizedString("NO", comment: "")
        
        number.text = NSLocalizedString("number", comment: "") + ": " + String(station.number)
        name.text = NSLocalizedString("name", comment: "") + ": " + station.name!
        address.text = NSLocalizedString("address", comment: "") + ": " + station.address!
        status.text = NSLocalizedString("status", comment: "") + ": " + station.status!
        bonus.text = NSLocalizedString("bonus", comment: "") + ": " + ((station.bonus) ? good : bad)
        banking.text = NSLocalizedString("banking", comment: "") + ": " + ((station.banking) ? good : bad)
        bikes.text = NSLocalizedString("stands", comment: "") + ": " + String(station.bike_stands)
        avbikes.text = NSLocalizedString("available bikes", comment: "") + ": " + String(station.av_bikes)
        avspaces.text = NSLocalizedString("available stands", comment: "") + ": " + String(station.av_stands)
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
