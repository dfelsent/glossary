
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
    #redirect_to glossaries_path
  end


end


