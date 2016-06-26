//
//  ViewController.swift
//  Billiam
//
//  Created by Bill He on 6/20/16.
//  Copyright © 2016 Bill He. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var activityTextField : UITextField!
    @IBOutlet var startingTimeTextField : UITextField!
    @IBOutlet var timeSlider : UISlider!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var infoLabel : UILabel!
    @IBOutlet var requiredSwitch : UISwitch!
    @IBOutlet var strictSwitch : UISwitch!
    
    // Data model: These strings will be the data for the table view cells
    var activities: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    @IBAction func timeSliderAction(sender : AnyObject) {
        timeSlider.value = round(timeSlider.value);
        let hours : Int = Int(timeSlider.value/4);
        let minutes : Int = Int(timeSlider.value%4)*15;
        
        //let value = timeSlider.value/4;
        timeLabel.text = String(hours) + " hr " + String(minutes) + " min";// String(format:"%.2f", value) + " hr";
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.activities[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        infoLabel.text = "You tapped cell number \(indexPath.row)."
        
        fadeViewInThenOut(infoLabel, delay: 1)
    }
    
    
    // this method handles row deletion
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // remove the item from the data model
            activities.removeAtIndex(indexPath.row)
            
            // delete the table view row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
    @IBAction func addTapped(sender : AnyObject) {
        fadeViewInThenOut(infoLabel, delay: 1)
        var activityFullString : String;
        let activityStr : String = activityTextField.text!
        let strictTimeStr : String = startingTimeTextField.text!
        let timeLabelStr : String = timeLabel.text!
        
        if (activityStr.characters.count == 0) {
            infoLabel.text = "Please enter an activity"
            fadeViewInThenOut(infoLabel, delay: 1);
        } else if (strictSwitch.on && strictTimeStr.characters.count == 0) {
            infoLabel.text = "Please enter a starting time"
            fadeViewInThenOut(infoLabel, delay: 1);
        } else {
            activityFullString = activityStr + " for " + timeLabelStr;
            if (requiredSwitch.on) {
                activityFullString += " [Mandatory";
            }
            if (strictSwitch.on) {
                activityFullString += " starting at " + strictTimeStr
            }
            if (requiredSwitch.on) {
                activityFullString += "]";
            }
            infoLabel.text = "Added " + activityFullString;
            fadeViewInThenOut(infoLabel, delay: 1);
            activities.append(activityFullString)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: activities.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            tableView.endUpdates()

        }
        // Update Table Data
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fadeViewInThenOut(view : UIView, delay: NSTimeInterval) {
        
        let animationDuration = 0.25
        
        // Fade in the view
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animateWithDuration(animationDuration, delay: delay, options: .CurveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }
}
