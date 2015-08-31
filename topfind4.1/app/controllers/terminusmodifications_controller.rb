class TerminusmodificationsController < ApplicationController

  def index
    @term = Terminusmodification.all.paginate(:page => params[:page], :per_page => 20)
    
    puts "mod search: [#{params[:modifications]}]"
    puts "type search: [#{params[:type]}]"
    
   if (params.keys&['modifications','type']).present?
      #
      if params[:modifications].present?
		  #going to do a bit of a hack
		  if params[:modifications] == "unknown"
         @term = Terminusmodification.where("kw_id = ?", 1172).paginate(:page => params[:page], :per_page => 20).uniq
		  
		  elsif params[:modifications] == "Hydroxylation"
         @term = Terminusmodification.where("kw_id = ?", 503).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "TPQ"
         @term = Terminusmodification.where("kw_id = ?", 1053).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Pyruvate"
         @term = Terminusmodification.where("kw_id = ?", 898).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Methylation"
         @term = Terminusmodification.where("kw_id = ?", 677).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Phosphoprotein"
         @term = Terminusmodification.where("kw_id = ?", 819).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Gamma-carboxyglutamic acid"
         @term = Terminusmodification.where("kw_id = ?", 819).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Isopeptide bond"
         @term = Terminusmodification.where("kw_id = ?", 587).paginate(:page => params[:page], :per_page => 20).uniq
		  elsif params[:modifications] == "Bromination"
         @term = Terminusmodification.where("kw_id = ?", 128).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "ADP-ribosylation"
         @term = Terminusmodification.where("kw_id = ?", 21).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Amidation"
         @term = Terminusmodification.where("kw_id = ?", 38).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Proteoglycan"
         @term = Terminusmodification.where("kw_id = ?", 882).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Citrullination"
         @term = Terminusmodification.where("kw_id = ?", 212).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Oxidation"
         @term = Terminusmodification.where("kw_id = ?", 779).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Iodination"
         @term = Terminusmodification.where("kw_id = ?", 576).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "FMN"
         @term = Terminusmodification.where("kw_id = ?", 370).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Nucleotide-binding"
         @term = Terminusmodification.where("kw_id = ?", 763).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Hypusine"
         @term = Terminusmodification.where("kw_id = ?", 510).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Acetylation"
         @term = Terminusmodification.where("kw_id = ?", 9).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Pyridoxal phosphate"
         @term = Terminusmodification.where("kw_id = ?", 891).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Retinal protein"
         @term = Terminusmodification.where("kw_id = ?", 912).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Biotin"
         @term = Terminusmodification.where("kw_id = ?", 116).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Formylation"
         @term = Terminusmodification.where("kw_id = ?", 373).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Formylation"
         @term = Terminusmodification.where("kw_id = ?", 638).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Peptidoglycan-anchor"
         @term = Terminusmodification.where("kw_id = ?", 794).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Glycoprotein"
         @term = Terminusmodification.where("kw_id = ?", 416).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Nitration"
         @term = Terminusmodification.where("kw_id = ?", 751).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Covalent protein-DNA linkage"
         @term = Terminusmodification.where("kw_id = ?", 249).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Covalent protein-RNA linkage"
         @term = Terminusmodification.where("kw_id = ?", 250).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Phosphopantetheine"
         @term = Terminusmodification.where("kw_id = ?", 818).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "FAD"
         @term = Terminusmodification.where("kw_id = ?", 353).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Pyrrolidone carboxylic acid"
         @term = Terminusmodification.where("kw_id = ?", 896).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Chromophore"
         @term = Terminusmodification.where("kw_id = ?", 201).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Glutathionylation"
         @term = Terminusmodification.where("kw_id = ?", 408).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "S-nitrosylation"
         @term = Terminusmodification.where("kw_id = ?", 938).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Selenium"
         @term = Terminusmodification.where("kw_id = ?", 946).paginate(:page => params[:page], :per_page => 20).uniq
		elsif params[:modifications] == "Sulfation"
         @term = Terminusmodification.where("kw_id = ?", 1000).paginate(:page => params[:page], :per_page => 20).uniq
		  end
      end
		if params[:species].present?
         if params[:species] == "N-termini"
			   @term = @term.where("nterm = ?", 1)
			elsif params[:species] == "C-termini"
			   @term = @term.where("cterm = ?", 1)
			end
      end
   end
  end
  
  def show
    #protein table id is given. It will find it
    @ter = Terminusmodification.find(params[:id])
  end
end
