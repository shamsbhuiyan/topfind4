class EvidencesController < ApplicationController
  def show
    @evidence = Evidence.find(params[:id])
  end
end
