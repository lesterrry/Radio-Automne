//
//  SetupMenu.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 03.10.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation

struct SetupMenu {
    struct SetupMenuElement {
        let title: String
        var value: Int
        let bounds : (Int, Int)
        let isAction: Bool
    }
    var elements: [SetupMenuElement]
    var selected: Int
    func getRaw() -> String{
        var n = "   *** USE KEYBOARD ***\n"
        var i = 1
        for e in self.elements{
            e.isAction ?
                n.append((i == self.selected ? "> " : "  ") + e.title + "\n") :
                n.append((i == self.selected ? "> " : "  ") + e.title + " = " + String(e.value) + "\n")
            i += 1
        }
        return n
    }
    
    public static func get(for: [SetupMenuElement]) -> SetupMenu{
        return SetupMenu(elements: `for`, selected: 1)
    }
    
    public func increment(_ completion: [() -> ()] = [{}]) -> SetupMenu{
        var els = self.elements
        let sel = self.selected - 1
        if !els[sel].isAction{
            if els[sel].value < els[sel].bounds.1 {
                els[sel].value += 1
            }
        }else{
            completion[sel]()
        }
        return SetupMenu(elements: els, selected: self.selected)
    }
    public func decrement() -> SetupMenu{
        var els = self.elements
        if els[self.selected - 1].value > els[self.selected - 1].bounds.0 {
            els[self.selected - 1].value -= 1
        }
        return SetupMenu(elements: els, selected: self.selected)
    }
    
    public func upSel() -> SetupMenu{
        var m = self
        if m.selected < m.elements.count {
            m.selected += 1
        }
        else{
            m.selected = 1
        }
        return m
    }
    public func downSel() -> SetupMenu{
        var m = self
        if m.selected > 1 {
            m.selected -= 1
        }
        else{
            m.selected = m.elements.count
        }
        return m
    }
}

