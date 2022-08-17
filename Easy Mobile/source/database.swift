//
//  database.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 17.06.2022.
//

import Foundation

class database{

    func of_connect() -> MySQL.Connection? {
        //create the connection object
        //let ls_serverIp = "195.179.237.106"
        //let ls_user = "u913328660_school"
        //let ls_password = "School123.!"
        //let ls_dbname = "u913328660_school"

        //connection penceresinde seçilen connection verilerini al
        let ls_def_con = UserDefaults.standard.string(forKey: "Last_Connected") ?? "0"
        
        if ls_def_con == "0"{
            messagebox("Database Connection","Please set you database connection.")
            return nil
        }
        
     
        let ls_serverIp  = UserDefaults.standard.string(forKey: "ip" + ls_def_con) ?? ""
        var ls_port = UserDefaults.standard.string(forKey: "port" + ls_def_con) ?? "3306"
        let ls_dbname = UserDefaults.standard.string(forKey: "database" + ls_def_con) ?? ""
        let ls_user = UserDefaults.standard.string(forKey: "username" + ls_def_con) ?? ""
        let ls_password = UserDefaults.standard.string(forKey: "password" + ls_def_con) ?? ""
        if ls_port == ""{
            ls_port = "3306"
        }
        let li_port = Int(ls_port)
        
        let con = MySQL.Connection()
        do{
            try con.open(ls_serverIp, user:ls_user , passwd: ls_password, dbname:ls_dbname, port: li_port!)
        }
        catch (let e) {
            return nil
        }
        
        return con
    }

    
    
    
    func of_getTables()->Int{
        
        //Daha önce databasee bağlanıp tablo adlarını almıysa pas geç, veritabanına tekrar connect yapılırsa
        //DbColumns resetleniyor yani tekrar okunur
        if (DbColumns.count > 0){
            return DbColumns.count
        }
        
        
        if let con = of_connect(){
            do {
                //veritabanındaki tablo ve alan adlarını oku
                let ls_sql = "SELECT table_name, COLUMN_NAME, COLUMN_TYPE, column_default, is_nullable, data_type, CHARACTER_OCTET_LENGTH, NUMERIC_PRECISION, column_key FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = Database() and 1=? order by ORDINAL_POSITION"


                let stmt = try con.prepare(ls_sql)
                let smtp = try stmt.query([1])
                   

                repeat {
                    
                    if con.hasMoreResults {
                        try _ = con.nextResult()
                    }
                    
                    //tablo ve alan adlarını sturcure'a doldur
                    while let row = try smtp.readRow() {
                        DbColumns.append(column(table_name: row["table_name"] as! String,
                                        column_name: row["COLUMN_NAME"] as? String,
                                        column_type: row["COLUMN_TYPE"] as? String,
                                        column_default : row["column_default"] as? String,
                                        is_null :row["is_nullable"] as? String,
                                        data_type : row["data_type"] as? String,
                                        column_lenght : Int(row["CHARACTER_OCTET_LENGTH"] as? String ?? "0"),
                                        column_precision : Int(row["NUMERIC_PRECISION"] as? String ?? "0"),
                                        key: row["column_key"] as? String))
                        
                    }
                } while con.hasMoreResults
                }
                catch (let err) {
                  print(err)
            }
            try! con.close()
        }
        return DbColumns.count
    }





    func of_test_sql(_ as_sql:String){
        if let con = of_connect(){
            do {
                try con.prepare(as_sql)
                try con.close()
                messagebox("SQL", "Success!")
             }
            catch (let err) {
                //messagebox("SQL Error", err.localizedDescription)
            }
            
     
        }
    }
}
