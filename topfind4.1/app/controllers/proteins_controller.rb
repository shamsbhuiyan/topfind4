class ProteinsController < ApplicationController
# TopFINDer
  require 'listTools/topFINDer'
  require 'listTools/emailer'
  
  # PathFINDer
  require 'graph/pathFinding'
  require 'graph/graph'
  require 'graph/mapMouseHuman'
  
  include ActionView::Helpers::NumberHelper
  
  def index
    
    #arrays required for searching
    joins = Array.new
    includes = Array.new
    conditions = Array.new
    select = ['DISTINCT proteins.*']
    having = Array.new
    andconditions = Array.new
    andqueries = Array.new
    orconditions = Array.new
    orqueries = Array.new
    conditionvars = Hash.new
    #@protein = Array.new
    puts "species: [#{params[:species]}]"
    puts "chromosome: [#{params[:chr]}]"
    puts "position on chromosome: [#{params[:pos]}]"
    #checking filter paramters
    if params[:query].present?
    
      # if it matches the accession number schema
      match = params[:query].match(/^[A-Za-z]\w{5}(-\d)?$/).present?   
      @protein = Protein.find_by_ac(params[:query]) if match
      
      #if there is one protein that matches directly to the ac,
      #go directly to that protein
      if @protein.present?
        redirect_to :action => "show", :id => @protein.id
      end 
      
    end
    
    #the normal search when you can't find just one protein
    if (params.keys&['query']).present? && !@protein.present?
       #match to proteinname, gene name, alternate names, merops family or codey
      #so search through search name. Return a list. Now link it to the protein table
      @protein = Protein.joins(:searchnames).where("searchnames.name LIKE ?", "%#{params[:query]}%").paginate(:page => params[:page], :per_page => 20)
      
      #check for species
      if params[:species].present?
          #can add this where to above. Just need to figure out what to do about the blank option
	#perhaps I can get the Model.where feature to go over an array?
          @protein = @protein.where(species_id: params[:species])
      end
      
      #check chromosome
      if params[:chr].present?
          @protein = @protein.where(chromosome: params[:chr])
      end
      
       #check position on chromsome
      if params[:pos].present?
          @protein = @protein.where("band LIKE ?", "%#{params[:pos]}%")
      end

    else
      @protein = Protein.all.paginate(:page => params[:page], :per_page => 20)
    end


end



  
  def show
    @protein = Protein.find(params[:id])
  end
  



end
