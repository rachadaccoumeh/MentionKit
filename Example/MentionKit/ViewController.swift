//
//  ViewController.swift
//  MentionKit
//
//  Created by rachadaccoumeh on 07/20/2023.
//  Copyright (c) 2023 .. All rights reserved.
//

import UIKit
import MentionKit

class ViewController: UIViewController {
	
	
	
	

	@IBOutlet weak var mentionTextView: MentionTextView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var mentionName: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var mentionList:[MentionRow] = []
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 1", MentionKit: "id 1"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 2", MentionKit: "id 2"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 3", MentionKit: "id 3"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 4", MentionKit: "id 4"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 5", MentionKit: "id 5"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 6", MentionKit: "id 6"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 7", MentionKit: "id 7"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 8", MentionKit: "id 8"))
		mentionList.append(MentionRow(pictureURL: nil, mentionName: "user 9", MentionKit: "id 9"))
		if #available(iOS 13.0, *) {
			mentionTextView.initilize(trigger: "@", mentionsList: mentionList, keepTrigger: true,imagePlaceHolder: UIImage(systemName: "person.crop.circle"))
		} else {
			// Fallback on earlier versions
		}
	}

	
	@IBAction func sendButtonClicked(_ sender: Any) {
		
		textView.text=mentionTextView.sendMessage()
		
	}
	
	var MentionKit:Int=111110
	var index = 0

	@IBAction func mentionClicked(_ sender: Any) {
		MentionKit+=1
		index+=1
		if(mentionName.text.isEmpty){
			mentionTextView.addMention(MentionKit: "\(MentionKit)", mentionDisplayName: "user‎ \(index)")
		}else{
			mentionTextView.addMention(MentionKit: "\(MentionKit)", mentionDisplayName: mentionName.text)
		}
	}

}

