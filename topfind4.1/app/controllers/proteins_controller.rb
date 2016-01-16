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
    
    @protein = @protein.includes(:gn, :proteinnames)
    
end



  
  def show
    #protein AC is given from the table. This will find it
    @protein = Protein.find_by_ac(params[:id])
    
    
    # EVIDENCES FOR WHAT'S DISPLAYED
    #
    #
    @evidence = Evidence.all    
    @evidence = @evidence.where(directness: params[:directness]) if params[:directness].present?
    @evidence = @evidence.where(phys_relevance: params[:phys_rel]) if params[:phys_rel].present?
    @evidence = @evidence.joins(:evidencecodes).where(evidencecodes: { name: params[:evidencecodes]}) if params[:evidencecodes].present?    
    @evidence = @evidence.where(methodology: params[:methodology]) if params[:methodology].present?
    @evidence = @evidence.where(method_perturbation: params[:perturbations]) if params[:perturbations].present?
    @evidence = @evidence.where(method_system: params[:methodsystems]) if params[:methodsystems].present?
    @evidence = @evidence.where(proteaseassignment_confidence: params[:proteaseassignmentconfidences]) if params[:proteaseassignmentconfidences].present?
    @evidence = @evidence.where(name: params[:evidences]) if params[:evidences].present?                    
    @evidence = @evidence.where(repository: params[:repository]) if params[:repository].present?
    @evidence = @evidence.where(lab: params[:labs]) if params[:labs].present?                  
    
    @evidence = @evidence.includes(:evidencecodes, :evidencesource) # these are the ones for display
    
    @evidence = @evidence.joins(:nterms).where(nterms: { protein_id: @protein.id}) | 
    @evidence.joins(:cterms).where(cterms: { protein_id: @protein.id}) | 
    @evidence.joins(:cleavages).where("cleavages.protease_id =? OR cleavages.substrate_id =?", @protein.id, @protein.id)
    
    
    
    # THESE ARE THE EVIDENCES JUST FOR THE FILTER!
    #
    #
    @all_evidence = Evidence.joins(:nterms).where(nterms: { protein_id: @protein.id}).includes(:evidencecodes) | 
    Evidence.joins(:cterms).where(cterms: { protein_id: @protein.id}).includes(:evidencecodes) | 
    Evidence.joins(:cleavages).where("cleavages.protease_id =? OR cleavages.substrate_id =?", @protein.id, @protein.id).includes(:evidencecodes)
    
    # @nterms = @evidence.nterms
    # @cterms = @evidence.cterms
    # @cleavages = @evidence.cleavages
    
    
    # THE DATA TO DISPLAY
=begin
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
=end
  end
  
  
  
  def pathfinder
  end
    
  def pathfinder_output
    # if parameters are not well defined, return to input page
    if(params["start"] == "" ||  params["targets"] == "" || params["maxLength"] == "")
      render :action => 'pathfinder'
    elsif(Protein.find_by_ac(params["start"].strip).nil?)
      render :text => "The start protease '#{params["start"]}' could not be found, try again by clicking the BACK button."
    else
      # CLEAN UP INPUT
      start = params["start"].strip
      targets = params["targets"].split("\n").collect{|s| {:id => s.split("\s")[0], :pos => s.split("\s")[1].to_i}}
      @maxLength = params["maxLength"].to_i
      byPos = params["byPos"] == "yes"
      rangeLeft = params["rangeLeft"] == "" ? 0 : params["rangeLeft"].to_i
      rangeRight = params["rangeRight"] == "" ? 0 : params["rangeRight"].to_i
      # ORGANISMS
      nwOrg = params["network_org"]
      listOrg = params["list_org"]
      # FIND PATHS
      finder = PathFinding.new(Graph.new(nwOrg, []), @maxLength, byPos, rangeLeft, rangeRight, true)
      if(nwOrg == "mouse" && listOrg == "human") # nw is mouse and list is human
        finder.find_all_paths_map2mouse(start, targets)
      elsif(nwOrg == "human" && listOrg == "mouse")  # nw is human and list is mouse
        finder.find_all_paths_map2human(start, targets)
      else
        finder.find_all_paths(start, targets)
      end
      p finder.get_paths()
      finder.remove_direct_paths()
      p finder.get_paths()
      @allPaths = finder.get_paths()
      @gnames = finder.paths_gene_names()                                                     # GENE NAMES FOR PROTEINS
      #      domains_descriptions = ["%protease%inhibitor%", "%proteinase%inhibitor%", "%inhibitor%"]
      @domains_name_filter = {"SIGNAL" => "signalpeptide", "PROPEP" => "propeptide", "ACT_SITE" => "active site", "TRANSMEM" => "TM domain"}
      @allPaths =  finder.get_domain_info(@domains_name_filter.keys, nil)
      @sortet_subs = @allPaths.keys.sort{|x, y| @allPaths[y].size <=> @allPaths[x].size}      # SORT OUTPUT
      @pdfPath = finder.make_graphviz("#{Rails.root}/public/images/PathFINDer", @gnames)
    end 
  end

  
  def topfinder
  end
  
  def topfinder_output
    # LABEL
    date = Time.new.strftime("%Y_%m_%d")
    if params[:label].nil?
      label = "TopFINDer_analysis" 
    else
      label = params[:label].gsub(/[^\w\d\_]/, "") # removes anything that's not a word, number or "_"
      # label = params[:label].gsub(/\s/, '_').gsub(/\;/, '_').gsub(/\#/,"_")
    end
    label = label[0..30] # this is for long labels
    label = date + "_" + label

    # EMAIL TEST
    @email = params[:email]
    sent = false
    begin
      sent = Emailer.new().sendTopFINDerConfirmation(@email, label)
    rescue Exception => e
      p "emailing failed #{e}"
      sent = false
    end
    
    # RUN ANALYSIS
    if sent
      TopFINDer.new().analyze(params, label)
    else
      render :text => "Sending email to #{@email} failed. If it is not a valid email address, then please try again by clicking the BACK button. In case of other problems please email us at topfind.clip[at]gmail.com"
    end
  end


end
