class AuthenticationViewController < UIViewController
  attr_accessor :tableView
  attr_accessor :usernameField, :passwordField
  attr_accessor :usernameCell, :passwordCell
  attr_accessor :signingInCell, :signedInCell, :signedInAsLabel
  attr_accessor :doneButton, :helpBannerButton, :cancelButton
  attr_accessor :signingIn, :signedIn

  def viewWillAppear(animated)
    signingIn = false
    signedIn = user_cache['username'] != nil

    self.usernameField.text = user_cache['username']
    textDidChange = false
    true
  end

  def numberOfSectionsInTableView(tableView)
    signingIn || signedIn ? 2 : 1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if ((signingIn || signedIn) && section == 0)
      1
    else
      2
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if signingIn && indexPath.section == 0
      return self.signingInCell
    elsif signedIn && indexPath.section == 0
      self.signedInAsLabel.text = "Signed in as #{user_cache['username']}"
      return self.signedInCell
    else
      if indexPath.row == 0
        self.usernameCell
      else
        self.passwordCell
      end
    end
  end

  def dismissDialog(sender)
    self.dismissModalViewControllerAnimated(true)
  end

  def textDidChange(sender)
    self.doneButton.enabled = true #self.usernameField.text.length > 0 && self.passwordField.text.length > 0;
  end

  def saveCredentials(sender)
    self.usernameField.resignFirstResponder
    self.passwordField.resignFirstResponder

    self.doneButton.enabled = false
    self.usernameField.enabled = false
    self.passwordField.enabled = false
    self.signingIn = true

    user_cache['username'] = self.usernameField.text
    user_cache['password'] = self.passwordField.text

    # Happy crashtime begins here
    # Its something in the trakt::auth
    authentication = Trakt::Authentication.new
    authentication.validate do |valid|
      if valid == true
        self.dismissDialog(sender)
      else
        self.signingIn = false
        self.doneButton.enabled = true
        self.usernameField.enabled = true
        self.passwordField.enabled = true
      end
    end
  end

  def selectPasswordField(sender)
    self.passwordField.becomeFirstResponder
  end

end
