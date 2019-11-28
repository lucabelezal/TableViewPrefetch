//
//  ButtonEnablingBehavior.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

final class ButtonEnablingBehavior: NSObject {
    
    private let textFields: [UITextField]
    private let onChange: (Bool) -> Void
    
    init(textFields: [UITextField], onChange: @escaping (Bool) -> Void) {
      self.textFields = textFields
      self.onChange = onChange
      super.init()
      setup()
    }
    
    private func setup() {
      textFields.forEach { textField in
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      }
      onChange(false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
      var enable = true
      for textField in textFields {
        guard let text = textField.text, !text.isEmpty else {
          enable = false
          break
        }
      }
      onChange(enable)
    }
}
