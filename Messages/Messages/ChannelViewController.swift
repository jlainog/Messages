//
//  ChannelViewController.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
  
    @IBOutlet weak var channelsTable: UITableView!
    internal var channels: [ChannelProtocol]?
    let headerTitles = ["Create Channels", "Public Channels"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTable.delegate = self
        channelsTable.dataSource = self
        
        channels = []
        let service = ChannelService()
        service.listChannels(){ channelsArray in
            self.channels = channelsArray
        }
        
        channels?.append(PublicChannel(json: ["id":1,"name":"Disipulos de JaimeGod"]))
        channelsTable.reloadData()
    }
}

extension ChannelViewController:UITableViewDataSource,UITableViewDelegate{
    
    enum Section: Int {
        case createNewChannelSection = 0
        case currentChannelsSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels!.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels?[indexPath.row]
        channelsTable.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "cell")
        channelsTable.register(UINib(nibName: "NewItemCell", bundle: nil), forCellReuseIdentifier: "newItemCell")
        guard indexPath.section == 1 else{
            let cell = channelsTable.dequeueReusableCell(withIdentifier:"newItemCell",for: indexPath) as! NewItemCell
            return cell
        }
        let cell = channelsTable.dequeueReusableCell(withIdentifier:"cell",for: indexPath) as! ChannelCell
        cell.titleLbl.text = channel?.name
        return cell
        
    }
    
}
