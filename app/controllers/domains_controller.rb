class DomainsController < ApplicationController
  def available
    url = params["url"]
    available = Domain.available?(url)
    render json: {available: available}
  end
end
