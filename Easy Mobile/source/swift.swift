//
//  swift.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 30.06.2022.
//

import Foundation



func of_create_swift(){
    var ls_template = ""
    var ls_outlet_list = ""
    var ls_value_set = ""
    var ls_prefix = ""
    var ls_object = ""
 
    if (gs_template_folder == ""){
        return
    }
    
    
    
    
    
    //CELL ************************************************************************************
    if gb_create_view{
        if gi_viewtype < 3  {
            
            // cell için Outlet satırları ve veri yükleyen satırlar oluşturuluyor
            for row in SqlColumns{
                
                if row.column_name! == gs_picture_field{
                    ls_prefix = "p_"
                    ls_object = "UIImageView!"
                }else{
                    if gsA_updatable_columns.contains(row.column_name!){
                        if row.column_lenght! < 50{
                            ls_prefix = "tf_"
                            ls_object = "UITextField!"
                        }else{
                            ls_prefix = "tf_"
                            ls_object = "UITextView!"
                        }
                    }else{
                        ls_prefix = "lb_"
                        ls_object = "UILabel!"
                    }
                }
                ls_outlet_list += "@IBOutlet weak var " + ls_prefix + row.column_name! + ":" + ls_object + "\r\t"

                
                //FIXME diğer tiplere dönüşüm ele alınmalı
                if row.column_name! != gs_picture_field{
                    if of_getSwiftType(row.column_type!) != "String"{
                        ls_value_set += ls_prefix + row.column_name! + ".text = String(row." + row.column_name! + ")\r\t\t\t"
                    }else{
                        ls_value_set += ls_prefix + row.column_name! + ".text = row." + row.column_name! + "\r\t\t\t"
                    }
                }
            }
                
                
            //image seçilmişse image okuma komutu ekle
            if gs_picture_field.count > 0 {
                let ls_picture = "p_" + gs_picture_field + ".loadImage(String(row." + gs_picture_field + "))" + "\r\t\t\t"
                ls_value_set += ls_picture
            }

            //en sona eklenen fazla satır başı siliniyor
            ls_value_set = ls_value_set.of_left("\r\t\t\t",lastpos: true)!


            //template'i oku
            ls_template = of_read_file("c_sample.txt")
            if ls_template == ""{
                return
            }
           
            
            
            //standart değişiklikleri yap
            ls_template = ls_template.replacingOccurrences(of: "#NAME#", with: "c_" + gs_appName)
            ls_template = ls_template.replacingOccurrences(of: "#DATA_MODEL_NAME#", with: "d_" + gs_appName)
            ls_template = ls_template.replacingOccurrences(of: "#IBOUTLET_LIST#", with: ls_outlet_list)
            ls_template = ls_template.replacingOccurrences(of: "#OBJECT_VALUE_SET#", with: ls_value_set)

            
            if gi_viewtype == 2{
                ls_template = ls_template.replacingOccurrences(of: "UITableViewCell", with: "UICollectionViewCell")
            }

            file().of_write(filename: "SWIFT/" + gs_appName + "/" + "c_" + gs_appName + ".swift", content :ls_template)
        }
            
 


  
    
   
    
    
        //TABLEVIEW - VIEW ***********************************************************************
        //template'i oku
        if gi_viewtype == 3 {
            ls_template = of_read_file("v_view.txt")
        }else{
            ls_template = of_read_file("v_tableview.txt")
        }
        
        if ls_template == ""{
             return
        }
      
        var ls_filter = ""
        for column in gs_search_fields{
            if ls_filter.count > 0{
                ls_filter += " || "
            }
            if of_getSwiftType(column.column_type!) == "String"{
                ls_filter += "$0." + column.column_name! + ".lowercased().contains(searchText.lowercased())"
            }else{
                ls_filter += "String($0." + column.column_name! + ").contains(searchText.lowercased())"
            }
        }
        
        //view için outlet listesi oluştur
        ls_outlet_list = ""
        if gs_search_fields.count > 0{
            //ls_template = ls_template.replacingOccurrences(of: "UITableViewController", with: "UITableViewController, UISearchBarDelegate")
            //ls_outlet_list = "@IBOutlet weak var searchbar: UISearchBar!\r\t"
        }

        //Genel değişiklikleri yap
        ls_template = ls_template.replacingOccurrences(of: "#IBOUTLET_LIST#", with: ls_outlet_list)
        ls_template = ls_template.replacingOccurrences(of: "#NAME#", with: "v_" + gs_appName)
        ls_template = ls_template.replacingOccurrences(of: "#DATA_MODEL#", with: "d_" + gs_appName)
        ls_template = ls_template.replacingOccurrences(of: "#CELL_NAME#", with: "c_" + gs_appName)
        ls_template = ls_template.replacingOccurrences(of: "#FILTER_EXPRESSION#", with: ls_filter)
        
        
     
        if gi_viewtype == 2{
            ls_template = ls_template.replacingOccurrences(of: "UITableView", with: "UICollectionView")
            ls_template = ls_template.replacingOccurrences(of: "tableView", with: "collectionView")
        }
        
        
        //search işlemleri
        if gi_viewtype < 3{
            let li_pos1 = ls_template.of_pos("#SEARCH#")
            let li_pos2 = ls_template.of_pos("#ENDSEARCH#")
            
            if gs_search_fields.count == 0 {
                ls_template.of_replace(starting: li_pos1, to: li_pos2 + 11, as_text: "")
            }else{
                ls_template = ls_template.replacingOccurrences(of: "#SEARCH#", with: "")
                ls_template = ls_template.replacingOccurrences(of: "#ENDSEARCH#", with: "")
            }
        }
            
        //Save file
        file().of_write(filename: "SWIFT/" + gs_appName + "/" + "v_" + gs_appName + ".swift", content :ls_template)

        
    }
    
    
        
    //DATAOBJECT************************************************************
    ls_template = of_read_file("d_sample.txt")
    if ls_template == ""{
         return
    }
    var ls_col_with_type = ""
    var ls_col_with_json = ""
    var ls_col_with_col = ""
    var ls_col_with_type_newline = ""
    let ls_pk_with_type = gs_pk + ":" + of_getSwiftType(gs_pk_type)
    let ls_pk_with_pk = "\"" + gs_pk + "\":" + gs_pk
    var ls_retrieve_argument = ""
    var ls_type = ""
    var ls_colname = ""
    var lb_null:Bool = false
  
    
    
    for row in SqlColumns{
        ls_type = of_getSwiftType(row.column_type!)
        ls_colname = row.column_name!
        lb_null = row.is_null! == "YES"
        
        if lb_null{
            ls_type += "?"
        }
 
        
        ls_col_with_type += ls_colname + " :" + ls_type + ", "
        ls_col_with_type_newline += "var " + ls_colname + " :" + ls_type + "\r\n\t\t"
        ls_col_with_col += "\"" + ls_colname + "\"" + " :" + ls_colname + ", "
  
       
        
        //ls_col_with_json   #COLUMNNAME#  :row["#COLUMNNAME#"] as! String!)
        if ls_type.contains("String"){
            if lb_null{
                ls_col_with_json += ls_colname + " :row[\"" + ls_colname + "\"] as? String,\r\n\t\t\t\t\t\t\t"
            }else{
                ls_col_with_json += ls_colname + " :row[\"" + ls_colname + "\"] as! String,\r\n\t\t\t\t\t\t\t"
            }
        }else{ //FIXME diğer türler dikkate alınmalı
            if lb_null{
                ls_col_with_json += ls_colname + " :"+ls_type+"(row[\"" + ls_colname + "\"] as! String),\r\n\t\t\t\t\t\t\t"
            }else{
                ls_col_with_json += ls_colname + " :"+ls_type+"(row[\"" + ls_colname + "\"] as! String)!,\r\n\t\t\t\t\t\t\t"
            }
        }
    }
         
    
        
    //en sona eklenen fazla virgül vs. siliniyor
    ls_col_with_type = ls_col_with_type.of_left(",",lastpos: true)!
    ls_col_with_col = ls_col_with_col.of_left(",",lastpos: true)!
    ls_col_with_json = ls_col_with_json.of_left(",\r\n\t\t\t\t\t\t\t",lastpos: true)!

   
    //of_retrieve("avm_select.php",parameters: ["ulke":gs_country,"eyalet":as_eyalet])
    if gsA_parameters.count > 0 {
        ls_retrieve_argument = ", parameters: ["
     
        for var parameter in gsA_parameters{
            parameter = parameter.of_right(starting: 1)!
            ls_retrieve_argument += "\"" + parameter + "\": ?, "
        }
        //en sona eklenen fazla virgül siliniyor
        ls_retrieve_argument = ls_retrieve_argument.of_left(",",lastpos: true)!
        ls_retrieve_argument += "]"
    }
    
    ls_template = ls_template.replacingOccurrences(of: "#NAME#", with: "d_" + gs_appName)
    ls_template = ls_template.replacingOccurrences(of: "#COLUMN_WITH_TYPE_NEWLINE#", with: ls_col_with_type_newline)
    ls_template = ls_template.replacingOccurrences(of: "#COLUMN_WITH_TYPE#", with: ls_col_with_type)
    ls_template = ls_template.replacingOccurrences(of: "#COLUMN_WITH_JSON#", with: ls_col_with_json)
    ls_template = ls_template.replacingOccurrences(of: "#COLUMN_WITH_COLUMN#", with: ls_col_with_col)
    ls_template = ls_template.replacingOccurrences(of: "#PK_WITH_TYPE#", with: ls_pk_with_type)
    ls_template = ls_template.replacingOccurrences(of: "#PK_WITH_PK#", with: ls_pk_with_pk)
    ls_template = ls_template.replacingOccurrences(of: "#RETRIEVE_ARGUMENT#", with: ls_retrieve_argument)
    ls_template = ls_template.replacingOccurrences(of: "#PHP_SELECT_NAME#", with: gs_appName + "_select.php")
    ls_template = ls_template.replacingOccurrences(of: "#PHP_INSERT_NAME#", with: gs_appName + "_insert.php")
    ls_template = ls_template.replacingOccurrences(of: "#PHP_DELETE_NAME#", with: gs_appName + "_delete.php")
   
    if gs_search_fields.count == 0 {
        ls_template = ls_template.replacingOccurrences(of: "var originaldata = [str_data]()\r\n", with:"")
        ls_template = ls_template.replacingOccurrences(of: "originaldata = [str_data]()\r\n\t\t", with:"")
        ls_template = ls_template.replacingOccurrences(of: "data = originaldata\r\n", with:"")
        ls_template = ls_template.replacingOccurrences(of: "originaldata",with:"data")
        ls_template = ls_template.replacingOccurrences(of: "\t\t\t}",with:"\t}")
    }
    
    
    if gi_viewtype == 2{
        ls_template = ls_template.replacingOccurrences(of: "UITableViewController", with: "UICollectionViewController")
    }

    
    if gb_delete == false{
        let li_pos1 = ls_template.of_pos("func of_delete")
        let li_pos2 = ls_template.of_pos("}", starting: li_pos1)
        ls_template.of_replace(starting : li_pos1, to: li_pos2, as_text: "")
    }
    if gb_insert == false{
        let li_pos1 = ls_template.of_pos("func of_update")
        let li_pos2 = ls_template.of_pos("}", starting: li_pos1)
        ls_template.of_replace(starting : li_pos1, to: li_pos2, as_text: "")
    }

    
    file().of_write(filename: "SWIFT/" + gs_appName + "/" + "d_" + gs_appName + ".swift", content :ls_template)
   
}

    
