//
//  v_updatable.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 26.06.2022.
//

import Foundation
import SwiftUI




class v_updatable: ViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    @IBOutlet weak var tableview1: NSTableView!
    @IBOutlet weak var tableview2: NSTableView!
    var TableColumns = [column]()
    
    
   
    
    override func viewDidLoad() {
        tableview1.delegate = self
        tableview1.dataSource = self
        tableview2.delegate = self
        tableview2.dataSource = self
        tableview1.reloadData() // bu olmazsa geri tuşuna basıp sqli değiştirip gelirsen yeni tablo adı görünmez
    }
    
 
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
      if (tableView == tableview1){
            gs_updatable_table = gsA_table_names[row]
            TableColumns = DbColumns.filter() {$0.table_name.lowercased() == gs_updatable_table}
            tableview2.reloadData()
       }
       return true
    }

     
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView == tableview1){
            return gsA_table_names.count
        }else{
            return TableColumns.count
        }
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
       
        switch (tableColumn?.identifier)!.rawValue{
        case "tablename":
            cell.textField?.stringValue = gsA_table_names[row]
        case "columnname":
            cell.textField?.stringValue = TableColumns[row].column_name!
        case "nullable":
            cell.textField?.stringValue = ""
            if (TableColumns[row].is_null == "NO"){
                if let def =  TableColumns[row].column_default{
                }else{
                    cell.textField?.stringValue = "YES"
                }
            }

        default:
            return cell
        }
        return cell
    }
    
    
   
    
    func of_finish()->Int {
        gsA_updatable_columns = [String]()
        if TableColumns.count == 0{
            messagebox("Error","Please select updatable table and columns!")
            return -1
        }
        
        
        var ls_nullFileds = ""
        for row in 0...TableColumns.count - 1{
            if (tableview2.isRowSelected(row)){
                gsA_updatable_columns.append(TableColumns[row].column_name!)
            }else{
                
                if (TableColumns[row].is_null == "NO"){
                    
                    if let def =  TableColumns[row].column_default{
                    }else{
                        if (ls_nullFileds.count > 0){
                            ls_nullFileds += ", "
                        }
                        ls_nullFileds += TableColumns[row].column_name!
                                   
                    }
                }
            }
        }

        var ls_message = ""
        if (ls_nullFileds.count > 0){
            ls_message = "The column " + ls_nullFileds + " is not null and it doesn't have default value, so you have to select it."
            if (ls_nullFileds.contains(",")){
                ls_message = "The columns " + ls_nullFileds + " are not null and they don't have default value, so you have to select them."
            }
         
            messagebox("Error",ls_message)
            return -1
        }
        
        
        
        
        
        //updatable columnları kullanıcıya sorduk tablo ve alanlar belli şimdi o tablonun PK sını bulacağız
        if let row = DbColumns.first(where: {$0.table_name.lowercased() == gs_updatable_table && $0.key == "PRI"}) {
            gs_pk = row.column_name!
            gs_pk_type = of_gettype(row.column_type!)
        }
        
       
        //updatable alanları  virgül ile birbirine bağla
        let ls_updatable_columns = gsA_updatable_columns.joined(separator: ", ")
        let ls_updatable_columns_with$ = "$" + gsA_updatable_columns.joined(separator: ", $")
        

        //update için id = $id, adi=$adi şeklinde string oluştur
        var ls_upd_set_string = ""
        for columnname in gsA_updatable_columns{
            if (ls_upd_set_string != ""){
                ls_upd_set_string += ", "
            }
            ls_upd_set_string += columnname + " = $" + columnname
        }
     
        
        gs_delete_sql = "Delete From " + gs_updatable_table + " Where " + gs_pk + " = $" + gs_pk
        
        gs_insert_sql = "Insert Into " + gs_updatable_table + "(" + ls_updatable_columns + ") Values(" + ls_updatable_columns_with$ + ")"
        
        gs_update_sql = "Update " + gs_updatable_table + " Set " + ls_upd_set_string + " Where " + gs_pk + " = $" + gs_pk
        
         
        return 1
     }
    
   
    
  
 
}




