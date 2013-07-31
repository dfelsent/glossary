
class GlossariesController < ApplicationController
  # GET /glossaries
  # GET /glossaries.json

  def index
    @glossaries = Glossary.all
    respond_to do |format|
      format.html # index.html.erb
      format.csv { send_data Glossary.to_csv(@glossaries) }
      format.xls #{ send_data @glossaries.to_csv(col_sep: "\t") }
    end
  end

  def import
    Glossary.import(params[:file])
    redirect_to root_url, notice: "Glossary imported."
  end

def create
    @glossary = Glossary.new(params[:glossary])
  
      if @glossary.save
        flash[:notice] = "Your term has been saved."
        redirect_to glossaries_path
      else
        render :action => 'index'
        format.html { render action: "index" }
      end
    end

 def edit
    @glossary = Glossary.find(params[:id])
  end

  def update
    @glossary = Glossary.find(params[:id])

    respond_to do |format|
      if @glossary.update_attributes(params[:glossary])
        format.html { redirect_to action: "index", notice: 'Your term was updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    Glossary.destroy_all
    redirect_to glossaries_path
  end

  def destroy_them_all
    Glossary.destroy_all
  end

  def show
     @glossary = Glossary.all
     agent = Mechanize.new
    agent.open_timeout   = 20000
    agent.read_timeout   = 20000
    agent.max_history = 1

    page = agent.get('http://hwmaint.jco.ascopubs.org/cgi/gls-maint?view=lookup')

    myform = page.form_with(:action => '/cgi/gls-maint')

    myuserid_field = myform.field_with(:id => "username")
    myuserid_field.value = 'NOTCORRECT'  
    mypass_field = myform.field_with(:id => "password")
    mypass_field.value = 'NOTCORRECT'

    page = agent.submit(myform, myform.buttons.first)

  @glossary.each do |glossary|
    finalurl = 'http://hwmaint.jco.ascopubs.org/cgi/gls-maint?view=edit&id=jco_glossary;'+ glossary.number.gsub(/.*;/, '') + ''
    page = agent.get("#{finalurl}")
    page.encoding = 'windows-1252'
    glossform = page.form_with(:name => "glossarysubmit")
    defform = glossform.field_with(:name => "definition")
    defform.value = glossary.definition
    page = agent.submit(glossform, glossform.buttons.first)
    puts "Update of #{glossary.name} was successful!"
    sleep 10.1
  end
  end

def update_terms
end

end


