//
//  SqliteManage.swift
//  SqliteDemo
//
//  Created by soft on 14/9/18.
//  Copyright © 2018年 silvercrest. All rights reserved.
//

import Foundation
import SQLite

/**
 * 数据库管理类
 */
struct SqliteManager {
    var database : Connection!
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do{
            database = try Connection("\(path)/db.sqlite3")
        }
        catch{
            print(error)
        }
    }
}



struct StudentTable {
    private let manager:SqliteManager = SqliteManager()
    private let student_info = Table("student_info")
    
    
    //表字段
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let stuNo = Expression<Int64>("stuNo")
    let sex = Expression<String>("sex")
    let height = Expression<Double>("height")
    let weight = Expression<Double>("weight")
    
    
    init() {
        // 建表
        try! manager.database.run(student_info.create(ifNotExists: true, block: { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(stuNo)
            t.column(sex)
            t.column(height)
            t.column(weight)
        }))
    }
    
    
    func insert(_ stutents:[Student])  {
       _ = stutents.map { insert($0) }
    }
    
    /// 插入一条数据
    func insert(_ student: Student) {
        /// 如果数据库中该条数据数据不存在，就插入
        if !exist(student) {
            let insertOne = student_info.insert( name <- student.name, stuNo <- student.stuNo,sex <- student.sex, height <- student.height, weight <- student.weight)
                /// 插入数据
                try! manager.database.run(insertOne)
        }
    }
    
    
    /**
    * 查询所有学生数据
    */
    func setlectAll() -> [Student] {
        var students = [Student]()
        for student in  try! manager.database.prepare(student_info){
            let newStudent = Student(name: student[name], stuNo: student[stuNo], sex: student[sex], height: student[height], weight: student[weight])
            students.append(newStudent)
        }
        return students
    }
    
    
    /**
    *  更新
    */
    func update(_ newStudent:Student)  {
        let student = student_info.filter(stuNo == newStudent.stuNo)
        try! manager.database.run(student.update(name <- newStudent.name))
    }
    
    
    /**
    *   删除
    */
    func delete(_ newStudent:Student)  {
        do{
            let student = student_info.filter(stuNo == newStudent.stuNo)
            if try manager.database.run(student.delete()) > 0 {
                print("deleted student")
            }else{
                print("student not found")
            }
        }catch{
            print("delete failed:\(error)")
        }
    }

    
    
    /// 判断数据库中某一条数据是否存在
    func exist(_ student: Student) -> Bool {
        let title = student_info.filter(stuNo == student.stuNo)
        // 判断该条数据是否存在，没有直接的方法
        // 可以根据 count 是否是 0 来判断是否存在这条数据，0 表示没有该条数据，1 表示存在该条数据
        let count = try! manager.database.scalar(title.count)
        return count != 0
    }
    
}
