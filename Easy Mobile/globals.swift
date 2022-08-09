//
//  globals.swift
//  Easy Mobile
//
//  Created by Helenex on 31.07.2022.
//

import Foundation




var DbColumns = [column]()
var SqlColumns = [column]()
var gsA_parameters = [String]()
var gsA_table_names = [String]()
var gs_updatable_table = ""
var gs_updatable_columns = ""
var gs_pk = ""
var gs_pk_type = ""
var gsA_updatable_columns = [String]()
var gs_appName = ""
var gs_last_appName = ""
var gb_select=false
var gb_delete=false
var gb_insert=false
var gs_select_sql = ""
var gs_insert_sql = ""
var gs_delete_sql = ""
var gs_update_sql = ""
var ii_page = 1
var gi_viewtype = 1
var gs_search_field = ""
var gs_search_field_type = ""
var gs_template_folder = ""
var gs_default_folder = ""
var gs_storyboard_path = ""
var gs_created_storyboard_path = ""
var gs_picture_field = ""
var gb_reset_storyboard = true
var gb_create_view = true


struct column{
    var table_name: String
    var column_name: String?
    var column_type: String?
    var column_default : String?
    var is_null : String?
    var data_type : String?
    var column_lenght : Int?
    var column_precision : Int?
    var key: String?
}



func of_read_file(_ filename: String) ->String{
    var ls_path = gs_template_folder + "/" + filename
    
    
    let fileManager: FileManager = .default
       // try! fileManager
        //    .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
      
    if fileManager.fileExists(atPath: ls_path) == false {
        ls_path = gs_default_folder + "/" + filename
    }

    let ls_template = file().of_read( ls_path)
    if ls_template == ""{
        messagebox("Error", ls_path + " could not be read!")
        return ""
    }
   
    return ls_template
}
