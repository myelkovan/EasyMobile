//
//  php.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 20.06.2022.
//

import Foundation


func of_create_php(){
    
    var ls_template = ""
    var ls_param_line = ""
    var ls_param_lines = ""

    if (gs_template_folder == ""){
        return
    }
    
    
    //Select ********************************************************************
   if (gb_select){
        ls_template = file().of_read( gs_template_folder + "/select.php")
        if ls_template == ""{
            messagebox("Error", gs_template_folder + "/select.php could not be read!")
            return
        }
            
        //template'den parametre satırını al
        ls_param_line = of_get_param_line(ls_template)
     
        //Sql de parametre varsa paremetreleri php parametresine çevir
        for var parameter in gsA_parameters{
            parameter = parameter.of_right(starting: 1)!
            ls_param_lines = ls_param_lines + ls_param_line.replacingOccurrences(of: "#PARAMATER#", with: parameter) + "\r"
        }
     
        ls_template = ls_template.replacingOccurrences(of: ls_param_line, with:  ls_param_lines)
        ls_template = ls_template.replacingOccurrences(of: "#SQL#", with: gs_select_sql)
      
        file().of_write(filename: "PHP/" + gs_appName + "/" + gs_appName + "_select.php", content :ls_template)
    }
    
    
    
    
    //Delete ********************************************************************
    if (gb_delete){
        ls_template = file().of_read( gs_template_folder + "/delete.php")
        if ls_template == ""{
            messagebox("Error", gs_template_folder + "/delete.php could not be read!")
            return
        }
            
        //template'den parametre satırını al
        ls_param_line = of_get_param_line(ls_template)

        //delete için PrimaryKey'i kullanacağız, php'ye bu alanı parametre olarak ekle
        ls_param_lines = ls_param_line.replacingOccurrences(of: "#PARAMATER#", with: gs_pk) + "\r"
      
        ls_template = ls_template.replacingOccurrences(of: ls_param_line, with:  ls_param_lines)
        ls_template = ls_template.replacingOccurrences(of: "#SQL#", with: gs_delete_sql)
        
        file().of_write(filename: "PHP/" + gs_appName + "/" + gs_appName + "_delete.php", content :ls_template)
    }
    
    
    //Insert ********************************************************************
    if (gb_insert){
        ls_template = file().of_read( gs_template_folder + "/insert.php")
        if ls_template == ""{
            messagebox("Error", gs_template_folder + "/insert.php could not be read!")
            return
        }
 
        ls_param_line = of_get_param_line(ls_template)
        ls_param_lines = ""
     
        for colname in gsA_updatable_columns{
            ls_param_lines = ls_param_lines + ls_param_line.replacingOccurrences(of: "#PARAMATER#", with: colname) + "\r"
        }

        ls_template = ls_template.replacingOccurrences(of: ls_param_line, with:  ls_param_lines)
        ls_template = ls_template.replacingOccurrences(of: "#SQL_INSERT#", with: gs_insert_sql)
        ls_template = ls_template.replacingOccurrences(of: "#SQL_UPDATE#", with: gs_update_sql)
        ls_template = ls_template.replacingOccurrences(of: "#PK#", with: gs_pk)
        
        file().of_write(filename: "PHP/" + gs_appName + "/" + gs_appName + "_insert.php", content :ls_template)

    }
   
    
    func of_get_param_line(_ as_template:String)->String{
        let li_pos1 = as_template.of_pos("$#PARAMATER#")
        let li_pos2 = as_template.of_pos("\r",starting: li_pos1)
         
        return as_template.of_mid(location: li_pos1, length: li_pos2 - li_pos1) ?? ""
     }

}







