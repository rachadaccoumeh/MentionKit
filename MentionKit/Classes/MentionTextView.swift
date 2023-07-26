//
//  PersonSelector.swift
//  MentionKit
//
//  Created by rachadaccoumeh on 20/07/2023.
//

import UIKit



@objc public class MentionTextView: UITextView, PersonSelectorDelegate {
	
	private var mentions: [NSRange: (MentionKit: String, mentionDisplayName: String)] = [:]
	private var isMentionSelected:Bool=false
	public var mentionColor = UIColor.blue
	private var trigger:Character = " "
	private var mentionsList = [MentionRow]()
	private var keepTrigger:Bool=false
	private var personView:PersonSelector?
	private var atCount=0
	private var lastAtCount=0
	private var lastMessage=""
	var mentionsDialogHeight:CGFloat = 150
	private var imagePlaceHolder:UIImage?
	
	
	// MARK: - Initialization
	
	public func initilize(trigger:Character,mentionsList:[MentionRow],keepTrigger:Bool,imagePlaceHolder:UIImage?){
		self.trigger=trigger
		self.mentionsList=mentionsList
		self.keepTrigger=keepTrigger
		self.imagePlaceHolder=imagePlaceHolder
	}
	
	@objc public func initilize(trigger:String,mentionsList:NSArray,keepTrigger:Bool,imagePlaceholder:UIImage?) throws {
		guard let castedMentionsList = mentionsList as? [MentionRow] else {
			throw NSError(domain: "InvalidType", code: 1, userInfo: [NSLocalizedDescriptionKey: "NSArray should be of type MentionRow"])
		}
		self.trigger = trigger.first!
		self.mentionsList = castedMentionsList
		self.mentionsList = castedMentionsList
		self.keepTrigger=keepTrigger
		self.imagePlaceHolder=imagePlaceholder
	}
	
	// MARK: - Person Selector
	
	private func removePersonSelector() {
		self.personView?.removeFromSuperview()
		self.personView = nil;
	}
	private func addPersonSelector() {
		self.personView = PersonSelector()
		self.personView?.initialize(originalPersons: mentionsList, trigger: trigger,imagePlaceHolder: imagePlaceHolder)
		self.personView?.personSelectorDelegate = self;
		self.superview?.addSubview(self.personView!)
		self.personView?.backgroundColor=backgroundColor
		self.personView?.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			self.personView!.heightAnchor.constraint(equalToConstant: mentionsDialogHeight),
			self.personView!.bottomAnchor.constraint(equalTo: self.topAnchor),
			self.personView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.personView!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	
	private func updatePersonSelectorState(){
		atCount=0;
		if (text != ""){
			var i = 0
			while (i <  text.count) {
				if (text[text.index(text.startIndex, offsetBy: i)] == "@") {
					atCount+=1;
				}
				i+=1
			}
			if (text[text.index(text.startIndex, offsetBy: text.count-1)] == "@") {
				if(self.personView == nil){
					addPersonSelector()
				}
			}
			if(self.personView != nil){
				personView?.updateName(text: text)
			}
		}
		if(atCount<lastAtCount){
			removePersonSelector()
		}
		lastAtCount=atCount;
		lastMessage = text;
		
	}
	
	
	// MARK: - PersonView Delegate
	
	func add(id: String) {
		let regexPattern =  "(?<="+String(trigger)+")\\w+"
		if let regex = try? NSRegularExpression(pattern: regexPattern),
		   let match = regex.matches(in: text.lowercased(), range: NSRange(text.startIndex..., in: text)).last,
		   let range = Range(match.range, in: text){
			//			text.removeSubrange(range)
			guard let textRange = selectedTextRange else {
				return
			}
			let locationEnd = self.offset(from: beginningOfDocument, to: textRange.end)
			let index = text.index(text.startIndex,offsetBy: locationEnd-1)
			if (text[index] != trigger){
				let diff = text.distance(from: range.lowerBound, to: range.upperBound)
				for _ in 0...diff-1{
					deleteBackward()
				}
			}
		}
		deleteBackward()
		let mentionRow = mentionsList.first { row in
			row.MentionKit==id
		}
		addMention(MentionKit: mentionRow!.MentionKit, mentionDisplayName: mentionRow!.mentionName)
	}
	
	func killMe() {
		removePersonSelector()
	}
	
	
	// MARK: - UITextView Overrides
	
	public override func deleteBackward() {
		if let range = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: range.start)
			var deletedLength = 1
			if let mentionRange = getMentionRange(for: selectionStart) {
				deletedLength = mentionRange.length
				self.textStorage.replaceCharacters(in: mentionRange, with: "")
				mentions.removeValue(forKey: getMentionRange(for: selectionStart)!)
			}else{
				super.deleteBackward()
			}
			let mentionsToBeChanged = getMentions(after: selectionStart)
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location - deletedLength
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
		}else{
			super.deleteBackward()
		}
		updatePersonSelectorState()
	}
	
	public override func closestPosition(to point: CGPoint) -> UITextPosition? {
		self.isMentionSelected=false
		guard let textRange = self.characterRange(at: point) else {
			return super.closestPosition(to: point)
		}
		let locationStart = self.offset(from: beginningOfDocument, to: textRange.end)
		if let mentionRange = getMentionRange(for: locationStart) {
			self.isMentionSelected=true
			return self.position(from: self.beginningOfDocument, offset: mentionRange.upperBound)
		}
		return super.closestPosition(to: point)
	}
	
	@objc public func addMention(MentionKit: String, mentionDisplayName: String) {
		//		TODO remove selected text(if selected) before mention someone
		//		let locationStart = self.offset(from: beginningOfDocument, to: textRange.start)
		//		let locationEnd = self.offset(from: beginningOfDocument, to: textRange.end)
		
		if let range = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: range.start)
			var mentionDisplayName = replaceSpacesWithNonBreakingSpace(mentionDisplayName)
			if (self.keepTrigger){
				mentionDisplayName=String(trigger)+mentionDisplayName
			}
			let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
			let mentionLength = mentionDisplayName.count + 2
			var mentionsToBeChanged = getMentions(after: selectionStart)
			mentionsToBeChanged.sort { (mention1, mention2) -> Bool in
				return mention1.location > mention2.location
			}
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location + mentionLength
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
			let mentionRange = NSRange(location: selectionStart, length: mentionLength)
			mentions[mentionRange] = (MentionKit, mentionDisplayName)
			let attributedStringNew = NSMutableAttributedString()
			attributedStringNew.append(NSAttributedString(string: "\u{2000}", attributes: [.foregroundColor: self.textColor]))
			attributedStringNew.append(NSAttributedString(string: mentionDisplayName, attributes: [.foregroundColor: self.mentionColor]))
			attributedStringNew.append(NSAttributedString(string: "\u{2000}", attributes: [.foregroundColor: self.textColor]))
			attributedString.insert(attributedStringNew, at: selectionStart)
			self.attributedText = attributedString
		}
	}
	
	public override func insertText(_ text: String) {
		if let selectedRange = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: selectedRange.start)
			let mentionsToBeChanged = getMentions(after: selectionStart)
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location + text.count
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
			if let mentionRange = mentionAtIndex(at: selectionStart+1) {
				self.textStorage.replaceCharacters(in: mentionRange, with: "")
				mentions.removeValue(forKey: mentionAtIndex(at: selectionStart+1)!)
				return
			}
		}
		super.insertText(text)
		updatePersonSelectorState()
	}
	
	@objc public func sendMessage() -> String {
		let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
		let mentions = mentions.sorted { $0.key.location > $1.key.location }
		for (mentionRange, mentionInfo) in mentions {
			let MentionKit = mentionInfo.MentionKit
			var mentionReplacement:String = ""
			mentionReplacement = String(trigger)+"\(MentionKit) "
			attributedString.replaceCharacters(in: mentionRange, with: mentionReplacement)
		}
		return attributedString.string
	}
	
	
	
	// MARK: - Helper Functions
	
	private func replaceSpacesWithNonBreakingSpace(_ input: String) -> String {
		let nonBreakingSpace = "\u{2000}"
		let result = input.replacingOccurrences(of: " ", with: nonBreakingSpace)
		return result
	}
	
	private func mentionAtIndex(at index: Int) -> NSRange? {
		for (mentionRange, _) in mentions {
			if mentionRange.location == index-1 {
				return mentionRange
			}
		}
		return nil
	}
	
	private func removeMention(from range: NSRange) {
		mentions.removeValue(forKey: range)
	}
	
	private func getMentionRange(for location: Int) -> NSRange? {
		for (mentionRange, _) in mentions {
			if location > mentionRange.location && location <= mentionRange.upperBound {
				return mentionRange
			}
		}
		return nil
	}
	
	private func getMentions(after index: Int) -> [NSRange] {
		var mentionsAfterIndex: [NSRange] = []
		for (mentionRange, _) in mentions {
			if mentionRange.location >= index {
				mentionsAfterIndex.append(mentionRange)
			}
		}
		return mentionsAfterIndex
	}
	
}
