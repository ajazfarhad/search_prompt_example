class HomeController < ApplicationController
  def index
    @results =  params[:query] ? PromptDatum.search(query: params[:query]) : PromptDatum.document_data
    respond_to do |format|
      format.html {}
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("results", partial: "home/results")
      }
    end
  end
end
