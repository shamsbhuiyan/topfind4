class ProteinsController < ApplicationController
# TopFINDer
  require 'listTools/topFINDer'
  require 'listTools/emailer'
  
  # PathFINDer
  require 'graph/pathFinding'
  require 'graph/graph'
  require 'graph/mapMouseHuman'
  
  include ActionView::Helpers::NumberHelper
#Did I do the associations correctly? Show Nik the Protein.find(1).gn.name issue
  def index
    

    #@protein = Array.new
    puts "species: [#{params[:species]}]"
    puts "chromosome: [#{params[:chr]}]"
    puts "position on chromosome: [#{params[:pos]}]"
    puts "modification: [#{params[:modifications]}]"
    puts "function: [#{params[:fun]}]"
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
    if (params.keys&['query', 'species']).present? && !@protein.present?
       #match to proteinname, gene name, alternate names, merops family or codey
      #so search through search name. Return a list. Now link it to the protein table
      @protein = Protein.joins(:searchnames).where("searchnames.name LIKE ?", "%#{params[:query]}%").paginate(:page => params[:page], :per_page => 20).uniq
      
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

      #check position on modifications
      if params[:modifications].present?
          ## Currently params[:modifications] can either be set to kws.id or kws.name, I need to use one of these on nterms?
	@protein = @protein.joins(:nterms => {:terminusmodification => :kw}, :cterms => {:terminusmodification => :kw}).where("kws.name = ?", params[:modifications])

	
      end
      if params[:fun] == "Protease"
         @protein = @protein.joins(:substrates)
      elsif params[:fun] == "Inhibitor"
         @protein = @protein.joins(:inhibited_proteases)
      end
    
    #if there is no search criteria present
    else
      @protein = Protein.all.paginate(:page => params[:page], :per_page => 20)
    end


end



  
  def show
    #protein table id is given. It will find it
    @protein = Protein.find(params[:id])
    
    @annotations_main = @protein.ccs.main
    @annotations_additional = @protein.ccs.additional
    @documentations = Documentation.all.group_by(&:name)
    @ppi = false
    
    #For the neighborhoodd stuff
    @cleavages = @protein.cleavages
    @cleavages = @cleavages.map {|x| x if x.substrate_id}.compact
    
    @cleavagesites = @protein.cleavages.collect{|t| t.cleavagesite} 
    @cleavagesites.delete(nil)
    
    @inverse_cleavages = @protein.inverse_cleavages
      
    @inhibitions = @protein.inhibitions

    @inverse_inhibitions = @protein.inverse_inhibitions
      
    @cterms = @protein.cterms
      
    @nterms = @protein.nterms
    
    analysis = Analysis.new(@protein,
    @cleavages,
    @cleavagesites,
    @inverse_cleavages,
    @inhibitions,
    @inverse_inhibitions,
    @cterms,
    @nterms,
    false,
    [],
    @ppi)
    @network = analysis.graph
  end
  



end
