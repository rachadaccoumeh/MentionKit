//
//  PersonCell.swift
//  MentionKit
//
//  Created by rachadaccoumeh on 21/07/2023.
//

import Foundation
import UIKit

class PersonCell: UITableViewCell {
	static let identifier = "PERSON_CELL"
	let imgUser = UIImageView()
	let labUserName = UILabel()
	var imageWidth :NSLayoutConstraint = NSLayoutConstraint()
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: "TagGroupMember")
		if #available(iOS 13.0, *) {
			self.backgroundColor = .secondarySystemBackground
			self.labUserName.textColor=UIColor.label
		}
		self.imgUser.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.imgUser)
		imgUser.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true;
		imageWidth=imgUser.widthAnchor.constraint(equalToConstant: 0)
		imageWidth.isActive=true
		imgUser.heightAnchor.constraint(equalToConstant: 40).isActive = true;
		imgUser.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
		imgUser.layer.cornerRadius = 20;
		imgUser.clipsToBounds = true
		self.labUserName.translatesAutoresizingMaskIntoConstraints = false
		self.labUserName.font = .systemFont(ofSize: 14)
		self.separatorInset = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
		self.contentView.addSubview(self.labUserName)
		self.labUserName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
		labUserName.leadingAnchor.constraint(equalTo: self.imgUser.trailingAnchor, constant: 10).isActive = true;
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
