class NtermsController < ApplicationController

  def index
     @nterm = Nterm.all.paginate(:page => params[:page], :per_page => 20)
     
     puts "sequence search: [#{params[:seq]}]"
     puts "position search: [#{params[:pos]}]"
     puts "mod search: [#{params[:modifications]}]"
     puts "mod search: [#{params[:species]}]"
     puts "ac search: [#{params[:ac]}]"
     #filtering
    if (params.keys&['seq','pos']).present?
      #search sequence. Fix this later to start a chromosome position
      if params[:seq].present?
         @nterm = Nterm.joins(:protein).where("proteins.sequence REGEXP ?", "^#{params[:seq]}").paginate(:page => params[:page], :per_page => 20).uniq
      end
      
       #terminus position finder
       if params[:pos].present?
         if params[:loc] == "at"
           @nterm = @nterm.where("nterms.pos = ?", (params[:pos].to_i - 1))
	 
         elsif params[:loc] == "before"
           @nterm = @nterm.where("nterms.pos < ?", (params[:pos].to_i - 1))
         
         elsif params[:loc] == "after"
           @nterm = @nterm.where("nterms.pos > ?", (params[:pos].to_i - 1))
         else
          @nterm = @nterm.where("nterms.pos = ?", (params[:pos].to_i - 1))
         end
      end
      
       #modification search
       if params[:modifications].present?
         #find the terminus id
         ter = Terminusmodification.find_by_name(params[:modifications]).id
         #then put it in the where
         @nterm = @nterm.where(terminusmodification_id: ter)
      end
      
      #species
       if params[:species].present?
         @nterm = @nterm.joins(:protein).where("proteins.species_id = ?", params[:species])
       end
       
       if params[:ac].present?
         @nterm = @nterm.joins(:protein).where("proteins.ac = ?", params[:ac])
       end
    else
      @nterm
    end
    
  end
  
  def show
     puts "id search: [#{params[:id]}]" 
     @output = Nterm.generate_csv(params[:id])
     respond_to do |format|
       format.html
       format.csv { send_data @output.as_csv }
     end
     p @output
  end

end
