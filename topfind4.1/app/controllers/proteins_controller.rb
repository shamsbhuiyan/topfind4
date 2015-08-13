class ProteinsController < ApplicationController
# TopFINDer
  require 'listTools/topFINDer'
  require 'listTools/emailer'
  
  # PathFINDer
  require 'graph/pathFinding'
  require 'graph/graph'
  require 'graph/mapMouseHuman'
  
  def index
    
    @protein = Protein.all.paginate(:page => params[:page], :per_page => 30)
    

  end 
  
  def show
    @protein = Protein.find(params[:id])
  end
end
