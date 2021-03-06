//
//  Settings.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import Foundation

class Settings {
    
    struct Const {
        static let AvailableCreditsKey = "Settings.Available" //
        static let ChangeKey = "Settings.Change.Indicator" //if the settings have been changed:
        static let HintIndexKey = "Settings.Hint.Index"
        static let PurchasedUidKey = "Settings.Purchased.Ball.Uid"
        static let SkinsKey = "Settings.Skins" //purchased ball skins
        static let BackDropChoiceKey = "Settings.BackDrop.Choice" // 0/1/2/3/4/5
        static let BackDropsKey = "Settings.Back.Drops"
    }
    let defaults = NSUserDefaults.standardUserDefaults()
    var availableCredits: Int {
        get { return defaults.objectForKey(Const.AvailableCreditsKey) as? Int ?? 8 }
        set { defaults.setObject(newValue, forKey: Const.AvailableCreditsKey) }
    }
    var backDropChoice: Int {
        get { return defaults.objectForKey(Const.BackDropChoiceKey) as? Int ?? 4 }
        set { defaults.setObject(newValue, forKey: Const.BackDropChoiceKey) }
    }
    var lastHint: Int {
        get { return defaults.objectForKey(Const.HintIndexKey) as? Int ?? 0 }
        set { defaults.setObject(newValue, forKey: Const.HintIndexKey) }
    }
    var mybackDrops: [String] {
        get { return defaults.objectForKey(Const.BackDropsKey) as? [String] ?? ["digital_art_1024x1024.jpg"]}
        set { defaults.setObject(newValue, forKey: Const.BackDropsKey) }
    }
    var mySkins: [String] {
        get { return defaults.objectForKey(Const.SkinsKey) as? [String] ?? ["perfect_bubble40"]}
        set { defaults.setObject(newValue, forKey: Const.SkinsKey) }
    }
    var purchasedUid: String? {
        get { return defaults.objectForKey(Const.PurchasedUidKey) as? String ?? "" }  //causes warning Invalid asset name supplied:  no worries
        set { defaults.setObject(newValue, forKey: Const.PurchasedUidKey) }
    }
    var changed: Bool {
        get { return defaults.objectForKey(Const.ChangeKey) as? Bool ?? false }
        set {
            defaults.setObject(newValue, forKey: Const.ChangeKey)
            defaults.synchronize()
        }
    }
    
}
