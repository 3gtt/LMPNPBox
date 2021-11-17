//
//  ViewController.swift
//  LMPNPBox
//
//  Created by LiamLincoln on 10/13/2021.
//  Copyright (c) 2021 LiamLincoln. All rights reserved.
//

import UIKit
import LMPNPBox
import SnapKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView(
            frame: .zero,
            style: .plain
        )
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.separatorInset = .zero
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var datas: [String] = ["NIM", "TIM", "Aliyun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstrainsSubViews()
        registerTableViewCell()
    }

    private func registerTableViewCell() {
        self.tableView.register(cellClass.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setupConstrainsSubViews(){
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override internal func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "NIMIdentifier", sender: nil)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "TIMIdentifier", sender: nil)
        } else {
            self.performSegue(withIdentifier: "AliyunIdentifier", sender: nil)
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        )
//        let red = (CGFloat(arc4random()) / 10.0).truncatingRemainder(dividingBy: 1.0)
//        let green = (CGFloat(arc4random()) / 10.0).truncatingRemainder(dividingBy: 1.0)
//        let blue = (CGFloat(arc4random()) / 10.0).truncatingRemainder(dividingBy: 1.0)
//        cell.backgroundColor = UIColor.init(
//            red: red,
//            green: green,
//            blue: blue,
//            alpha: 1
//        )
        cell.selectionStyle = .none
        cell.textLabel?.text = datas[indexPath.row]
        return cell
        
    }
    
}

extension ViewController {
    
    var cellReuseIdentifier: String {
        let nameSpace = (Bundle.main.infoDictionary?["CFBundleExecutable"] as? String) ?? "LMPNPBox_Example"
        var className: String = "\(type(of: self))"
        className.removeSubrange(className.range(of: "ViewController") ?? "".startIndex..<"".endIndex)
        return nameSpace  + "." + className + "TableViewCell"
    }
    
    var cellClass: AnyClass {
        return NSClassFromString(cellReuseIdentifier) ?? UITableViewCell.self
    }
    
}
