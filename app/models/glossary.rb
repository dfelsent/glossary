class Glossary < ActiveRecord::Base

  require 'nokogiri'
  #require 'mechanize'
  require 'open-uri'
  require 'rubygems'

  BOM = "\377\376"
  
  attr_accessible :definition, :name, :number


 def self.to_csv(all_products)
    CSV.generate do |csv|
      csv << column_names
      all_products.each do |glossary|
        csv << glossary.attributes.values_at(*column_names)
      end
    end
  end
  

  def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    glossary = find_by_id(row["id"]) || new
    glossary.attributes = row.to_hash.slice(*accessible_attributes)
    glossary.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

def uploadTerms
  agent = Mechanize.new

  page = agent.get('http://hwmaint.jco.ascopubs.org/cgi/gls-maint?view=lookup')

  myform = page.form_with(:action => '/cgi/gls-maint')

    myuserid_field = myform.field_with(:name => "username")
    myuserid_field.value = 'prodcms2'  
    mypass_field = myform.field_with(:name => "password")
    mypass_field.value = 'Yellow25@!' 

 page = agent.submit(myform, myform.buttons.first)

 page.css('table tbody tr td b a href').each do |cat|
  Mechanize::Page::Link.new(cat, agent, page).click
    page.css('p table tbody tr').each do |term|
      puts page.css('td[0]').text + ','
      puts page.css('td[1]').text  + ','
      page.link_with(:text => ' Edit ').click
      puts page.css('form table tbody tr[3] td textarea').text
      #ul.search('li').each{|li| li.after "\n"}
      puts '\n'     
    end
  end
end

def updateTerms
    agent = Mechanize.new
    agent.open_timeout   = 20000
    agent.read_timeout   = 20000
    agent.max_history = 1

    page = agent.get('http://hwmaint.jco.ascopubs.org/cgi/gls-maint?view=lookup')

    myform = page.form_with(:action => '/cgi/gls-maint')

    myuserid_field = myform.field_with(:id => "username")
    myuserid_field.value = 'prodcms2'  
    mypass_field = myform.field_with(:id => "password")
    mypass_field.value = 'Yellow25@!'

    page = agent.submit(myform, myform.buttons.first)

  glossary.each do |glossary|
    finalurl = 'http://hwmaint.jco.ascopubs.org/cgi/gls-maint?view=edit&id=jco_glossary;'+ glossary.number.gsub(/.*;/, '') + ''
    page = agent.get('finalurl')
    page.encoding = 'windows-1252'
    glossform = page.form_with(:name => "glossarysubmit")
    defform = glossform.field_with(:name => "definition")
    defform.value = glossary.definition
    page = agent.submit(glossform, glossform.buttons.first)
    puts "Update of #{glossary.name} was successful!"
    sleep 10.1
  end
end

def resetDatabase
  self.destroy_all
end

end
