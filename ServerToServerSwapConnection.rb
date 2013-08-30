require 'rexml/document'
require 'csv'
include REXML

# Globals
@zip = "c:\\Program Files (x86)\\7-Zip\\7z.exe\" e -y -oc:\\tableauScripts\\Extract"
# tabcmd must be in PATH
@tabCmd = "\"c:\\Windows\System32\\curl.exe"
@tabPassword = "1LikeBetty!"
@tabServer = "http://public.tableausoftware.com"
@customerListFile = "workbooks.csv"
@dbUser = "sa"
@dbPassword = "foo"
@tabLogoff = @tabCmd + " logout"

=begin
	To get this script to run, you need:
	
	- tabcmd installed locally and added to your PATH statement
	- 7-zip installed with the @zip variable (above) pointing to it ("\"c:\\Program Files (x86)\\7-Zip\\7z.exe\"
	- 3 Folders on the file system: c:\tableauscripts\incoming, c:\tableauscripts\outgoing, c:\tableauscripts\extract
	- config.csv filled out and accessible via @customerListFile
	
	What do the folders do?
	- \incoming is used to temporarily host files which have been grabbed from Tableau Server via tabcmd get
	- \outgoing is used to temprarily host files that have been modified and about to be published back to a Server
	- \extracts holds NEW extracts you have been created which will be swapped in for old extracts in a twbx you pulled down
	- \extracts is also a temporary holding place for the .twb which will get unzipped out of a twbx before it is modified
	   and then placed in \outgoing

=end






def ChangeDB(url,name)


	GetTBWorkBook(url,name)


  
end





def GetTBWorkBook(url,name)

  # Strip white spaces from workbook name for the get
  cmd = @tabCmd + " -o c:\\" + name + ".twbx " + url + "?format=twb"

  #puts "Getting " + name + "..."
  puts cmd
  system(cmd)
  Process.waitall
end

def Main()
	#puts "Processing..."
	csv_contents = CSV.read(@customerListFile)
	csv_contents.shift
	csv_contents.each do |row|
	  # row[0] defines if data source is an extract or database
	  # Source Tableau Server
	  @workbookURL = row[0]
 	  @workbookName = row[1]
	  #puts @workbookURL
	  
	  #puts @workbookName
	  

	ChangeDB(@workbookURL,@workbookName )

	end

	system(@tabLogoff)
end

Main()
