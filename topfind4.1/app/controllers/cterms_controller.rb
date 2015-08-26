class CtermsController < ApplicationController
  def index
     @cterm = Cterm.all.paginate(:page => params[:page], :per_page => 20)
     puts "sequence search: [#{params[:seq]}]"
     puts "position search: [#{params[:pos]}]"
          puts "mod search: [#{params[:modifications]}]"
     #filtering
    if (params.keys&['seq','pos']).present?
      #search sequence. Fix this later to start a chromosome position
      if params[:seq].present?
         @cterm = Cterm.joins(:protein).where("proteins.sequence REGEXP ?", "^#{params[:seq]}").paginate(:page => params[:page], :per_page => 20).uniq
      end
       #terminus position finder
       if params[:pos].present?
         if params[:loc] == "at"
           @cterm = @cterm.where("cterms.pos = ?", (params[:pos].to_i - 1))
	 
         elsif params[:loc] == "before"
           @cterm = @cterm.where("cterms.pos < ?", (params[:pos].to_i - 1))
         
         elsif params[:loc] == "after"
           @cterm = @cterm.where("cterms.pos > ?", (params[:pos].to_i - 1))
	 
         else
          @cterm = @cterm.where("cterms.pos = ?", (params[:pos].to_i - 1))
         end
      end
       if params[:modifications].present?
         #find the terminus id
         ter = Terminusmodification.find_by_name(params[:modifications]).id
         #then put it in the where
         @cterm = @cterm.where(terminusmodification_id: ter)
      end
            #species
       if params[:species].present?
         @cterm = @cterm.joins(:protein).where("proteins.species_id = ?", params[:species])
       end
       
       if params[:ac].present?
         @cterm = @cterm.joins(:protein).where("proteins.ac = ?", params[:ac])
       end
    else
      @cterm
    end
    
  end
  
  def show
    #protein table id is given. It will find it
    @cterm = Cterm.find(params[:id])

  end
end
