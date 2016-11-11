//
//  ViewController.swift
//  MergeCocosCreatorJSON
//
//  Created by 杨权 on 16/11/11.
//  Copyright © 2016年 Relax-Happy. All rights reserved.
//

import Cocoa
import FileKit
import SwiftyJSON

class ViewController: NSViewController {
    
    @IBOutlet weak var status: NSTextFieldCell!
    @IBOutlet weak var inputPath: NSTextFieldCell!
    @IBOutlet weak var outputPath: NSTextFieldCell!
    @IBOutlet weak var runButton: NSButton!
    @IBOutlet weak var inputButton: NSButton!
    @IBOutlet weak var outputButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func onSelectInputPathAction(sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.directoryURL = NSURL(string: Path.UserDesktop.rawValue)
        if panel.runModal() == NSModalResponseOK {
            if !panel.URLs.isEmpty {
                status.title = ""
                inputPath.title = panel.URLs[0].relativePath ?? ""
            }
        }
    }
    
    @IBAction func onSelectOutputPathAction(sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.directoryURL = NSURL(string: Path.UserDesktop.rawValue)
        if panel.runModal() == NSModalResponseOK {
            if !panel.URLs.isEmpty {
                status.title = ""
                outputPath.title = panel.URLs[0].relativePath ?? ""
            }
        }
    }
    
    @IBAction func onRunAction(sender: NSButton) {
        if inputPath.title.isEmpty {
            status.title = "需要提供待合并的JSON文件所在目录"
            return;
        }
        
        if outputPath.title.isEmpty {
            status.title = "需要提供整合后的JSON文件所在目录"
            return;
        }
        
        inputPath.enabled = false
        outputPath.enabled = false
        inputButton.enabled = false
        outputButton.enabled = false
        sender.enabled = false
        status.title = "开始合并"
        
        let path = Path(inputPath.title)
        var list = [Path]()
        if path.isDirectory {
            list.appendContentsOf(path.children(recursive: true).filter { $0.pathExtension.lowercaseString == "json" })
        }
        if list.isEmpty {
            promptMsg("没有找到JSON文件");
            return;
        }
        let obj = generateJSONByFiles(list);
        
        var result = false
        if let data = try? obj.rawData() where data.length > 0 {
            let jsonPath = Path(outputPath.title) + "output.json"
            if !jsonPath.exists {
                let _ = try? jsonPath.createFile()
            }
            result = (try? data.writeToURL(NSURL(fileURLWithPath: jsonPath.rawValue), options: [.AtomicWrite])) != nil
        }
        
        if (result) {
            promptMsg("已完成");
        } else {
            promptMsg("合并失败");
        }
    }
    
    private func generateJSONByFiles(paths: [Path]) -> JSON {
        var obj = JSON([String: JSON]())
        
        for path in paths {
            if path.exists {
                if let data = try? DataFile(path: path).read() {
                    let udid = path.fileName.substringToIndex(path.fileName.endIndex.advancedBy(-5))
                    obj[udid] = JSON(data: data)
                }
            }
        }
        
        return obj
    }
    
    private func promptMsg(msg: String) {
        inputPath.enabled = true
        outputPath.enabled = true
        inputButton.enabled = true
        outputButton.enabled = true
        runButton.enabled = true
        status.title = msg
    }


}

