//
//  v_connect.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 17.06.2022.
//

import Foundation
import SwiftUI




class v_settings: ViewController{


    @IBOutlet weak var tf_project_folder: NSTextField!
    @IBOutlet weak var tf_temp_folder: NSTextField!
    
    override func viewDidLoad() {
        tf_temp_folder.stringValue = gs_template_folder
        tf_project_folder.stringValue = gs_project_folder 
      }
    
   
    @IBAction func cb_template_folder_clicked(_ sender: Any) {
        tf_temp_folder.stringValue = of_getFolderName(pickFolder : true)
        gs_template_folder = tf_temp_folder.stringValue
        UserDefaults.standard.set(gs_template_folder, forKey: "template_folder")
      }
    
   
    @IBAction func cb_project_folder_clicked(_ sender: Any) {
        tf_project_folder.stringValue = of_getFolderName(pickFolder : true)
        gs_project_folder = tf_project_folder.stringValue
        UserDefaults.standard.set(gs_project_folder, forKey: "project_folder")
    }
 
    
    
    
}





