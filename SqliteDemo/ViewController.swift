//
//  ViewController.swift
//  SqliteDemo
//
//  Created by soft on 14/9/18.
//  Copyright © 2018年 silvercrest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var datas: [Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        datas = StudentTable().setlectAll()
        
        
        let nib =  UINib.init(nibName: "StudentTableViewCell", bundle: nil)
        self.view.addSubview(myTableView)
        self.view.addSubview(addButton)
        myTableView.register(nib, forCellReuseIdentifier: "studentTableCell")
        myTableView.tableFooterView = UIView()
        
        
    }
    
    lazy var myTableView :UITableView = {
        var tableView:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-60))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    lazy var addButton:UIButton = {
        var button:UIButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height-60, width: self.view.frame.size.width, height: 60))
        button.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        button.setTitle("增加", for: .normal)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    
    @objc func clickAddBtn()  {
        var student = Student()
        student.name = "lisi"
        student.height = Double(Int(arc4random_uniform(30)+160))
        student.weight = Double(Int(arc4random_uniform(30)+50))
        student.sex = "女"
        student.stuNo = Int64(Int(arc4random_uniform(1000)))
        StudentTable().insert(student)
        datas = StudentTable().setlectAll()
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}





extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "更新", message: "确认要更新用户名吗？", preferredStyle: UIAlertControllerStyle.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) in
            var student = Student()
            student.name = "zhangsan"
            student.stuNo = self.datas[indexPath.row].stuNo
            StudentTable().update(student)
            self.datas = StudentTable().setlectAll()
            self.myTableView.reloadData()
        }
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let tableCell:StudentTableViewCell = myTableView.dequeueReusableCell(withIdentifier: "studentTableCell") as! StudentTableViewCell
        tableCell.nameLabel.text = datas[row].name
        tableCell.heightLabel.text = String(stringInterpolationSegment: datas[row].height)
        tableCell.weightLabel.text = String(stringInterpolationSegment: datas[row].weight)
        tableCell.sexLabel.text = datas[row].sex
        tableCell.stuNolabel.text = String(stringInterpolationSegment: datas[row].stuNo)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        StudentTable().delete(datas[indexPath.row])
        datas = StudentTable().setlectAll()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

