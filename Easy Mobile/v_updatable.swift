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
    
 
    //Soldaki tableviewden tablo adi secilince sagda columnlari listele
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
      if (tableView == tableview1){
            gs_updatable_table = gsA_table_names[row]
            TableColumns = DbColumns.filter() {$0.table_name.lowercased() == gs_updatable_table}
            tableview2.reloadData()
       }
       return true
    }

     
    //tabloname ve column name row sayilari
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
        
        // secilmeyen alanlara bakacagiz bunlarin icinde not null ve default degeri olmayan alan varsa
        // bu alani secmelisiniz diye mesaj verecegiz ayni zamanda secilen alanlari gsA_updatable_columns
        // array ine dolduruyoruz
        var ls_nullFileds = ""
        var ls_updatable_columns_type:[String]=[]
        for row in 0...TableColumns.count - 1{
            if (tableview2.isRowSelected(row)){
                gsA_updatable_columns.append(TableColumns[row].column_name!)
                ls_updatable_columns_type.append(TableColumns[row].column_type!)
            }else{
                
                //not null bir alansa ve dafault degeri olmayan bir alansa
                if (TableColumns[row].is_null == "NO"){
                    
                    //null olabilen alanlari bir stringe ekledik
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
        //eksik alan varsa mesaj ver devem etmesine izi verme
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
            gs_pk_type = of_getSwiftType(row.column_type!)
        }
        
       
        //updatable alanları virgül ile birbirine bağla string ve date alanlarin basina tirnak ekle
        let ls_updatable_columns = gsA_updatable_columns.joined(separator: ", ")
        var ls_updatable_columns_with$ = ""
        var ls_upd_set_string = ""
        var li_i = 0
        
        
        for colname in gsA_updatable_columns{
            if (ls_updatable_columns_with$ != ""){
                ls_updatable_columns_with$ += ", "
            }
            //update için id = $id, adi=$adi şeklinde string oluştur
            if (ls_upd_set_string != ""){
                ls_upd_set_string += ", "
            }

            // Alan string ise basina sonuna tirnak koy
            if of_isDBTypeString(ls_updatable_columns_type[li_i]){
                ls_updatable_columns_with$ += "'$" + colname + "'"
                ls_upd_set_string += colname + " = '$" + colname + "'"
            }else{
                ls_updatable_columns_with$ += "$" + colname
                ls_upd_set_string += colname + " = $" + colname
            }

            li_i+=1
        }
        
        // primary key string ise basina sonuna tirnak ekle
        var ls_pk = "$" + gs_pk
        if of_isDBTypeString(gs_pk_type){
            ls_pk = "'$" + gs_pk + "'"
        }
            
        //fixme select sonundaki where adi=$adi ifadesi icinilk adi ifadesinin tablodaki tipini ogrenip
        // ona gore ikinci adi ifadesini tirnak icine almalisin adi = '$adi' yapmalisin
        // sql objesini son kismina bak
        gs_delete_sql = "Delete From " + gs_updatable_table + " Where " + gs_pk + " = " + ls_pk
            
        gs_insert_sql = "Insert Into " + gs_updatable_table + "(" + ls_updatable_columns + ") Values(" + ls_updatable_columns_with$ + ")"
        
        gs_update_sql = "Update " + gs_updatable_table + " Set " + ls_upd_set_string + " Where " + gs_pk + " = " + ls_pk
        
         
        return 1
     }
    
   
    
  
 
}




