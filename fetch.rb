require "rubygems"
require "google_drive"
require 'gravatar-ultimate'

$username = ARGV[0]
password = ARGV[1]
$gravatar_password = password + '123'
file_name = ARGV[2]


name_column = 'B'.ord - 65 + 1
email_column = 'H'.ord - 65 + 1


def has_gravatar(email)
	api = Gravatar.new($username, password: $gravatar_password)
	api.exists?(email)
end

# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login($username, password)

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("0AsxYGKsq3C89dHlPa2JQX2VGU3hnLTNwSnQ0Q2szU3c").worksheets[0]

pictures = ''
names = []
# Dumps all cells.
for row in 2..ws.num_rows
  name = ws[row, name_column]
  encoded_name = name.gsub /[^a-zA-Z0-9' ]/, ''

  email = ws[row, email_column]

  if has_gravatar(email)
  	gravatar = Gravatar.new(email).image_url(default: :monsterid, size: 150)
  	pictures << "<li><img src=\"#{gravatar}\" alt=\"#{encoded_name}\" title=\"#{encoded_name}\"></li>"
  else
  	names << encoded_name
  end
end


text = File.read(file_name)
text.gsub! /(<!--HOOFDEN-->).*(<!--END HOOFDEN-->)/, '\1' + pictures + '\2'
text.gsub! /(<!--NAMEN-->).*(<!--END NAMEN-->)/, '\1' + names.join(', ') + '\2'
File.open(file_name, "w") { |file| file.puts text }
