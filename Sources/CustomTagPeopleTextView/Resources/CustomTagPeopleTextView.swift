// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class CustomTagPeopleTextView: UIView {
    
    @IBOutlet weak var textViewPostDescription: UITextView!
    @IBOutlet weak var labelPlaceHolder: UILabel!
    @IBOutlet weak var viewTagPeople: UIView!
    @IBOutlet weak var tableViewTagPeople: UITableView! {
        didSet {
            tableViewTagPeople.register(UINib(nibName: "TagPeopleCell", bundle: .module), forCellReuseIdentifier: "TagPeopleCell")
        }
    }
    
    public class func initView(frame: CGRect) async -> CustomTagPeopleTextView {
        let view : CustomTagPeopleTextView = Bundle.module.loadNibNamed("CustomTagPeopleTextView", owner: self, options: nil)?.first as! CustomTagPeopleTextView
        view.frame = frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }

        
    public var arrayUsers: [String] = [] {
        didSet {
            tableViewTagPeople.reloadData()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configTagPeopleView() {
        viewTagPeople.layer.borderWidth = 0.5
        viewTagPeople.layer.borderColor = UIColor.lightGray.cgColor
        viewTagPeople.layer.shadowColor = UIColor.gray.cgColor
        viewTagPeople.layer.shadowOpacity = 1
        viewTagPeople.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewTagPeople.layer.shadowPath = UIBezierPath(rect: viewTagPeople.bounds).cgPath
        textViewPostDescription.delegate = self
        tableViewTagPeople.dataSource = self
        tableViewTagPeople.delegate = self
        tableViewTagPeople.showsVerticalScrollIndicator = false
    }
}

//MARK: - Helper Methods
extension CustomTagPeopleTextView {
    
    func showPeopleList() {
        tableViewTagPeople.reloadData()
        viewTagPeople.isHidden = false
    }
    
    func hidePeopleList() {
        viewTagPeople.isHidden = true
    }
    
    func replaceAndHighlightText(with taggedPerson: String) {
        
        if let lastCharacter = textViewPostDescription.text.last, lastCharacter == "@" {
            // Remove the "@" character
            textViewPostDescription.text.removeLast()
        }
        
        var tagString = "@\(taggedPerson)"
        
        if !tagString.hasSuffix(" ") {
            tagString += " "
        }

        let attributedString = NSAttributedString(string: tagString, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        
        // Append the attributed string to the existing text of the text view
        if let currentText = textViewPostDescription.attributedText.mutableCopy() as? NSMutableAttributedString {
            currentText.append(attributedString)
            textViewPostDescription.attributedText = currentText
        } else {
            textViewPostDescription.attributedText = attributedString
        }
        updateTextViewAttributedText()
    }
    
    func updateTextViewAttributedText() {
        
        guard let text = textViewPostDescription.text else { return }
        
        // Create an attributed string to hold the stylized text
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17)
        ])
        
        // Define the attributes for the username (e.g., semi-bold)
        let usernameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        // Define the range of the text to be styled as username
        let regex = try! NSRegularExpression(pattern: "@\\w+")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        
        // Apply the username attributes to the matched ranges
        for match in matches {
            attributedString.addAttributes(usernameAttributes, range: match.range)
        }
        
        // Update the textView's attributed text
        textViewPostDescription.attributedText = attributedString
    }
}
//MARK: - UITextViewDelegate
extension CustomTagPeopleTextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        labelPlaceHolder.isHidden = textView.text.count > 0
        
        if textView.text.hasSuffix("@") {
            showPeopleList()
        } else {
            hidePeopleList()
        }
        updateTextViewAttributedText()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text.count > 0) {
            labelPlaceHolder.isHidden = true
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty || textView.text.count == 0) {
            labelPlaceHolder.isHidden = false
        }
    }
}
//MARK: - Table view data source and delegate methods -
extension CustomTagPeopleTextView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagPeopleCell", for: indexPath) as? TagPeopleCell
        cell?.labelPersonName?.text = arrayUsers[indexPath.row]
        cell?.labelSeperator.isHidden = (indexPath.row == arrayUsers.count - 1) ? true : false
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taggedPerson = arrayUsers[indexPath.row]
        replaceAndHighlightText(with: taggedPerson)
        hidePeopleList()
    }
}
