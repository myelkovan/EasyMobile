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
    
    
    @IBAction func cb_test_clicked(_ sender: Any) {
        let ls_sql = (tv_sql.documentView! as! NSTextView).string.of_trim()
        database().of_test_sql(ls_sql!)
     }
  
    
     
    
    @IBAction func cb_start_php_clicked(_ sender: Any) {
        let ls_select_php_path = of_getFolderName(pickFolder :false)
           
        var ls_file = ls_select_php_path.of_right("/", lastpos: true)
        if ls_select_php_path.of_right("_")?.lowercased() != "select.php"{
            messagebox("Error", "You should select PHP file for select SQL")
            return
        }
 
        var ls_php_content = file().of_read(ls_select_php_path)
        if ls_php_content == ""{
            messagebox("Error", ls_select_php_path + " could not be read!")
            return
        }
   
        let li_pos1 = ls_php_content.of_pos("$sql")
        let li_pos2 = ls_php_content.of_pos(";",starting: li_pos1)
         
        var ls_sql = ls_php_content.of_mid(location: li_pos1, length: li_pos2 - li_pos1) ?? ""
        ls_sql = ls_sql.of_left(ls_sql.count - 1)!
        ls_sql = ls_sql.of_right("\"")!
        
        ls_file = ls_file!.of_left("_")
        tf_app_name.stringValue = ls_file!
        tv_sql.documentView?.selectAll(sender)
        tv_sql.documentView!.insertText(ls_sql)
    }
    
    
    
    
    func of_finish()->Int {
         
        if (tf_app_name.stringValue.of_trim() == ""){
            messagebox("Error","Please enter a name for your objects!")
            return -1
        }
        
        let ls_sql = (tv_sql.documentView! as! NSTextView).string.of_trim()
        UserDefaults.standard.set(ls_sql, forKey: "last_sql")
        gs_appName = tf_app_name.stringValue
       
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
