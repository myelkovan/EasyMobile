//
//  v_updatable.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 26.06.2022.
//

import Foundation
import SwiftUI




class v_columns: ViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    @IBOutlet weak var tableview: NSTableView!
    var ii_search_picture = 1
    
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
        
        //daha önce seçilen column name'i seç
        var ls_search_field = ""
        if ii_search_picture == 1{
            ls_search_field = gs_search_field
        }else{
            ls_search_field = gs_picture_field
        }
        
            
        if let li_row = SqlColumns.index(where: { $0.column_name == ls_search_field}) {
            let index = NSIndexSet(index: li_row)
            tableview.selectRowIndexes(index as IndexSet, byExtendingSelection: false)
        }
    }
    
  
    override func viewDidDisappear() {
        self.view.window?.close()
    }
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
       return SqlColumns.count
    }

  
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        if ii_search_picture == 1{
            gs_search_field = SqlColumns[row].column_name!
            gs_search_field_type = of_gettype(SqlColumns[row].column_type!)
        }else{
            gs_picture_field = SqlColumns[row].column_name!
        }
        return true
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.view.window?.close()
    }
    
   

     
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
       
        cell.textField?.stringValue = SqlColumns[row].column_name!
        return cell
    }
    
    
   
    
    func of_finish()->Int {
        if gs_search_field.count == 0{
            messagebox("Error","Please select column for search!")
            return -1
        }
        
        return 1
    }
 
 
}




