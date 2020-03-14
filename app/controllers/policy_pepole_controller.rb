class PolicyPepoleController < ApplicationController
  def index
    mp_find = params[:mp].split("_")
    @mp = Mp.where(last_name: mp_find[0], first_name: mp_find[1], middle_name: mp_find[2]).where('end_date = ?', "9999-12-31" ).first
    @policy = Policy.find(params[:id])
  end
end
