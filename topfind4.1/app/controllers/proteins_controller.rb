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
        #match to proteinname, gene name, alternate names, merops family or code
      if params[:query].present?
        #orconditions << "searchnames.name IN ('#{namevariants}')"
        orconditions << "searchnames.name LIKE ?"
        orqueries << "#{params[:query]}%"
        joins << :searchnames
      end

      
      querystring = Array.new
      querystring << andconditions if andconditions.present?
      querystring << "(#{orconditions.join(' OR ')})" if orconditions.present?
      querystring.compact!
      conditions << querystring.join(' AND ')
      conditions << andqueries
      conditions << orqueries
      conditions = conditions.flatten.compact
      File.open("log.txt", "w") { |file| file.write(conditions)}
      
      
      #res = Protein.all.scoped( :joins => joins, :select => select.join(','), :conditions => conditions, :order => 'proteins.name' )

      #@protein =  res
      
      #so search through search name. Return a list. Now link it to the protein table
      @protein = Searchname.where("name LIKE ? " , "%#{params[:query]}%").paginate(:page => params[:page], :per_page => 20)
      
      

    
    
    else
      @protein = Protein.all.paginate(:page => params[:page], :per_page => 20)
    end


end



  
  def show
    @protein = Protein.find(params[:id])
  end
  



end
