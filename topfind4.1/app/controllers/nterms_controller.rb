class NtermsController < ApplicationController

  def index
  
     #filtering
    #if (params.keys&['seq']).present? && !@nterm.present?  
    
   # else
    @nterm = Nterm.all.paginate(:page => params[:page], :per_page => 20)
    #end
    
  end
  
  def show
    #protein table id is given. It will find it
    @nterm = Nterm.find(params[:id])

  end

end
