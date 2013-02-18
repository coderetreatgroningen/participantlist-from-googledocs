require "rubygems"
require "google_drive"
require 'gravatar-ultimate'

username = ARGV[0]
password = ARGV[1]


name_column = 'B'.ord - 65 + 1
email_column = 'H'.ord - 65 + 1


# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(username, password)

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("0AsxYGKsq3C89dC1velY1SFpWbl9uRUZ6Q05jVjRJZEE").worksheets[0]

# Dumps all cells.
for row in 2..ws.num_rows
  name = ws[row, name_column]
  encoded_name = name.gsub /[^a-zA-Z0-9' ]/, ''

  email = ws[row, email_column]
  gravatar = Gravatar.new(email).image_url(default: :monsterid, size: 150)

  puts "<li><img src=\"#{gravatar}\" alt=\"#{encoded_name}\" title=\"#{encoded_name}\"></li>"
end


