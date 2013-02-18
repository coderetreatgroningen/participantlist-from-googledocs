require "rubygems"
require "google_drive"

username = ARGV[0]
password = ARGV[1]

# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(username, password)

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("0AsxYGKsq3C89dC1velY1SFpWbl9uRUZ6Q05jVjRJZEE").worksheets[0]

# Dumps all cells.
for row in 2..ws.num_rows
  for col in [2]
    p ws[row, col]
  end
end


