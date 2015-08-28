class TerminusmodificationsController < ApplicationController

  def index
    @term = Terminusmodification.all.paginate(:page => params[:page], :per_page => 20)
    
    puts "mod search: [#{params[:modifications]}]"
    puts "type search: [#{params[:type]}]"
  end
  
  def show
    #protein table id is given. It will find it
    @ter = Terminusmodification.find(params[:id])
  end
end
