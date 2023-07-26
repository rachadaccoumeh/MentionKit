//
//  PersonSelector.swift
//  MentionKit
//
//  Created by rachadaccoumeh on 21/07/2023.
//


import Foundation
import SDWebImage
class PersonSelector:UIView{
	private var tableView: UITableView!
	private var persons : [MentionRow] = []
	private var originalPersons: [MentionRow] = []
	private var trigger:Character = " "
	private var placeHolderImage:UIImage? = UIImage()
	@objc var personSelectorDelegate:PersonSelectorDelegate?
	
	override func awakeFromNib() {
		if #available(iOS 13.0, *) {
			self.backgroundColor = UIColor(white: 1, alpha: 0.0)
			self.tableView.backgroundColor = UIColor(white: 1, alpha: 0.0)
		}
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.identifier)
		self.tableView.reloadData()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
		// Create the UITableView
		tableView = UITableView(frame: bounds, style: .plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.identifier)
		addSubview(tableView)
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}

	
	
	func initialize(originalPersons:[MentionRow],trigger:Character,imagePlaceHolder:UIImage?) {
		self.persons=originalPersons
		self.originalPersons=originalPersons
		self.trigger=trigger
		self.placeHolderImage=imagePlaceHolder
	}
	
	@objc public func updateName(text:String){
		if (text.last == trigger) {
			persons = originalPersons
			tableView.reloadData()
		}
		let regexPattern =  "(?<="+String(trigger)+")\\w+"
		if let regex = try? NSRegularExpression(pattern: regexPattern),
		   let match = regex.firstMatch(in: text.lowercased(), range: NSRange(text.startIndex..., in: text)),
		   let range = Range(match.range, in: text) {
			let username = text[range]
			let filteredPersons = originalPersons.filter { $0.mentionName.lowercased().contains(username) }
			persons = filteredPersons
			tableView.reloadData()
		} else {
			print("No match found.")
		}
		
	}
	
	
	func getPersonName(for accountId: String) -> String {
		if let person = persons.first(where: { $0.MentionKit == accountId }) {
			return person.mentionName
		} else {
			return accountId
		}
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		personSelectorDelegate?.add(id: persons[indexPath.row].MentionKit)
		removeFromSuperview()
		personSelectorDelegate?.killMe()
	}
}
@objc protocol PersonSelectorDelegate {
	@objc func add(id:String)
	@objc func killMe()
}

extension PersonSelector:UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let Cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
		let accRow = self.persons[indexPath.row]
		if(persons[indexPath.row].pictureURL != nil || placeHolderImage != nil){
			Cell.imgUser.sd_setImage(with:persons[indexPath.row].pictureURL, placeholderImage: placeHolderImage)
			Cell.imageWidth.constant=40;
		}
		Cell.labUserName.text = accRow.mentionName
		
		return Cell;
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 54
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.persons.count
	}
}
