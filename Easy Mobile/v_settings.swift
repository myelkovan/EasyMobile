//
//  v_connect.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 17.06.2022.
//

import Foundation
import SwiftUI




class v_settings: ViewController{

    @IBOutlet weak var tf_temp_folder: NSTextField!
    @IBOutlet weak var tf_default_folder: NSTextField!
 
    
    
    override func viewDidLoad() {
        tf_temp_folder.stringValue = gs_template_folder
        tf_default_folder.stringValue = gs_default_folder 
      }
    
   
    @IBAction func cb_template_folder_clicked(_ sender: Any) {
        tf_temp_folder.stringValue = of_getFolderName(pickFolder : true)
        gs_template_folder = tf_temp_folder.stringValue
        UserDefaults.standard.set(gs_template_folder, forKey: "template_folder")
      }
    
   
    @IBAction func cb_default_folder_clicked(_ sender: Any) {
        tf_default_folder.stringValue = of_getFolderName(pickFolder : true)
        gs_default_folder = tf_default_folder.stringValue
        UserDefaults.standard.set(gs_default_folder, forKey: "default_folder")
    }
 
    
    
    
}





