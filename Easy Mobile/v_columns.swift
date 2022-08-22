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
    var ii_searchORpicture = 1
    
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
        
        //daha önce seçilen picture alanini seç
        var ls_search_field = ""
        if ii_searchORpicture == 2{
            ls_search_field = gs_picture_field
            if let li_row = SqlColumns.index(where: { $0.column_name == ls_search_field}) {
                let index = NSIndexSet(index: li_row)
                tableview.selectRowIndexes(index as IndexSet, byExtendingSelection: false)
            }
        }else{
            //daha önce seçilen search alanlarini seç
            for col in search_fields{
                ls_search_field = col.column_name!
                print(ls_search_field)
                if let li_row = SqlColumns.index(where: { $0.column_name == ls_search_field}) {
                    tableview.selectRowIndexes(NSIndexSet(index: li_row) as IndexSet, byExtendingSelection: true)
                }
            }
        }
    }
    
    
  
    override func viewDidDisappear() {
        if ii_searchORpicture == 1{
            search_fields = []
        }
        
        for row in 0...SqlColumns.count{
            if tableview.isRowSelected(row){
                if ii_searchORpicture == 1{
                    search_fields.append(SqlColumns[row])
                }else{
                    gs_picture_field = SqlColumns[row].column_name!
                }
            }
         }
        
        
        if ii_searchORpicture == 2{
            self.view.window?.close()
        }
    }
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
       return SqlColumns.count
    }

  
   
    
    //picture field secildi ise multi select yok hemen kapat
    func tableViewSelectionDidChange(_ notification: Notification) {
        if ii_searchORpicture == 2{
            self.view.window?.close()
        }
    }
    
   

     
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
       
        cell.textField?.stringValue = SqlColumns[row].column_name!
        return cell
    }
    
    
   
    
    func of_finish()->Int {
        if ii_searchORpicture == 1{
            if search_fields.count == 0{
                messagebox("Error","Please select column for search!")
                return -1
            }
        }else{
            if gs_picture_field.count == 0{
                messagebox("Error","Please select column for picture field!")
                return -1
            }
  
        }
        
        return 1
    }
 
 
}




