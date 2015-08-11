
class DocumentationsController < ApplicationController
 def index
  	Documentation.show_is(1).order_by(:position)
  end
 
  def admin

  end
  
  def about

  end
  
  def license

  end
  
  def download

  end
  
  
  def api

  end  
end
