//
//  v_tables.swift
//  Easy Mobile
//
//  Created by Murat Yelkovan on 21.08.2022.
//


import Foundation
import SwiftUI




class v_tables: ViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    @IBOutlet weak var tableview1: NSTableView!
    @IBOutlet weak var tableview2: NSTableView!
    var columns = [column]()
    var columns2 = [column]()
    var tables = [String]()
  
   
    
    override func viewDidLoad() {
        tableview1.delegate = self
        tableview1.dataSource = self
        tableview2.delegate = self
        tableview2.dataSource = self
        if columns.count == 0 {
            database().of_getTables()
        }
        tables = Array(Set(DbColumns.map{$0.table_name}))
        tableview1.reloadData() // bu olmazsa geri tuşuna basıp sqli değiştirip gelirsen yeni tablo adı görünmez
    }
    
    

 
    //tabloname ve column name row sayilari
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView == tableview1){
            return tables.count
        }else{
            return columns.count
        }
    }
 

    //Soldaki tableviewden tablo adi secilince sagda columnlari listele
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
      if (tableView == tableview1){
  
          if tableview1.isRowSelected(row) {
              columns += DbColumns.filter() {$0.table_name.lowercased() == tables[row]}
          }else{
              columns = columns.filter() {$0.table_name.lowercased() != tables[row]}
          }
            tableview2.reloadData()
       }
       return true
    }

     
   
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
    
        switch (tableColumn?.identifier)!.rawValue{
        case "tablename":
            cell.textField?.stringValue = tables[row]
        case "alias":
            cell.textField?.stringValue = tables[row].of_left(1)!
         case "columnname":
            cell.textField?.stringValue = columns[row].column_name!
        case "columntype":
            cell.textField?.stringValue = columns[row].column_type!

        default:
            return cell
        }
        return cell
    }
    
    @IBAction func cb_cancel_clicked(_ sender: Any) {
        self.view.window?.close()
    }
    
    
    @IBAction func cb_ok_clicked(_ sender: Any) {
        var ls_tables : [String] = []
        var ls_sql = ""
      
        
         for row in 0...tables.count - 1 {
           // if tableview1.isRowSelected(row) {
               
               let column = tableview1.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "alias"))
                let cell: NSTextFieldCell = (column?.dataCell(forRow: row))! as! NSTextFieldCell
                print(cell. stringValue)
                //print(cell.textField.raw)
               
                
            //}
        }

        
        for i in 0...columns.count - 1 {
            if tableview2.isRowSelected(i) {
                
                if ls_tables.contains(columns[i].table_name) == false{
                    ls_tables.append(columns[i].table_name)
                }
                
                ls_sql += columns[i].column_name!
                if i < columns.count - 1{
                    ls_sql += ", "
                }
                
            }
        }
        
        if ls_sql.count > 0{
            gs_paste_sql = "Select " + ls_sql + " From " + ls_tables.joined(separator: ",")
            sqlview!.tv_sql.documentView!.selectAll(1)
            sqlview!.tv_sql.documentView!.insertText(gs_paste_sql)
        }
        self.view.window?.close()

       
    }
    
    /*
    func of_finish()->Int {
       
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
           
        
        //FIXME select sonundaki where adi=$adi ifadesi icinilk adi ifadesinin tablodaki tipini ogrenip
        // ona gore ikinci adi ifadesini tirnak icine almalisin adi = '$adi' yapmalisin
        // sql objesini son kismina bak tamam
        
        
        //insert yapiliyorsa pk alanin sqlde olmasi lazim cunku delete, update isleminde id kullanilacak
        // kullanici bu alani secmeyi unuttu ise eklemelisin
        if gb_insert{
            if SqlColumns.contains(where: {$0.column_name == gs_pk}) == false{
                gs_select_sql = gs_select_sql.replacingOccurrences(of: "select", with: "select " + gs_pk + ", ")
                
                if let row = DbColumns.first(where: {$0.table_name.lowercased() == gs_updatable_table && $0.column_name?.lowercased() == gs_pk}) {
                    SqlColumns.append(row)
                }
            }
                                
        }
     
         
        gs_delete_sql = "Delete From " + gs_updatable_table + " Where " + gs_pk + " = " + ls_pk
            
        gs_insert_sql = "Insert Into " + gs_updatable_table + "(" + ls_updatable_columns + ") Values(" + ls_updatable_columns_with$ + ")"
        
        gs_update_sql = "Update " + gs_updatable_table + " Set " + ls_upd_set_string + " Where " + gs_pk + " = " + ls_pk
        
         
        return 1
     }
    
   */
    
  
 
}




