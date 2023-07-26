//
//  mentionRow.swift
//  MentionKit
//
//  Created by rachadaccoumeh on 20/07/2023.
//

import Foundation

public class MentionRow{
	let pictureURL:URL?
	let mentionName:String
	let MentionKit:String
	public init(pictureURL: URL?, mentionName: String, MentionKit: String) {
		self.pictureURL = pictureURL
		self.mentionName = mentionName
		self.MentionKit = MentionKit
	}
	
}
