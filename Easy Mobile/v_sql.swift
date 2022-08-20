//
//  v_connect.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 17.06.2022.
//

import Foundation
import SwiftUI



class v_sql: ViewController{
    @IBOutlet weak var tv_sql: NSScrollView!
    @IBOutlet weak var tf_app_name: NSTextField!
    @IBOutlet weak var cbx_delete: NSButton!
    @IBOutlet weak var cbx_insert: NSButton!
    @IBOutlet weak var cbx_select: NSButton!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tv_sql.documentView!.insertText(UserDefaults.standard.string(forKey: "last_sql") ?? "")
    }
    
    
    
    
    
    func of_finish()->Int {
         
        if (tf_app_name.stringValue.of_trim() == ""){
            messagebox("Error","Please enter a name for your objects!")
            return -1
        }
        
        if gs_template_folder == ""{
            messagebox("Error","Please click Settings button to enter template folder!")
            return -1
        }
        
        let ls_sql = (tv_sql.documentView! as! NSTextView).string.of_trim()
        UserDefaults.standard.set(ls_sql, forKey: "last_sql")
        gs_appName = tf_app_name.stringValue
       
        // proje adi degistiyse onceki projeye ait degiskenleri resetle
        if gs_last_appName != gs_appName{
            search_fields = []
            gs_last_appName = gs_appName
        }
        
        
        
        gb_select = cbx_select.state == NSButton.StateValue.on
        gb_delete = cbx_delete.state == NSButton.StateValue.on
        gb_insert = cbx_insert.state == NSButton.StateValue.on

    
        if database().of_getTables() == 0{
            return -1
        }
        of_parseSql(ls_sql!)
        return 1
        
   }
     
}








/*
let workspace = NSWorkspace.shared
let path = workspace.absolutePathForApplication(withBundleIdentifier: Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String)
    print(path)

if let file = Bundle.main.url(forResource: "Result", withExtension: "txt"){
    print(file)
}

 
 
 
 let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
   let documentsDirectory = urls[0]

 
*/
