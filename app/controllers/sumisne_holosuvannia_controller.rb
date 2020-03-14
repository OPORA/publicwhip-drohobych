class SumisneHolosuvanniaController < ApplicationController
  def init
    unless params[:party].nil? or params[:party].blank?
      part_ser = PartyFriend.joins(:mps,:mpss).where(party: params[:party])
      if part_ser.blank?
        redirect_to sumisne_holosuvannia_path, :notice => "Нажаль партії не було знайдено, спробуйте виконати інший пошуковий запит"
      end
    end
     if params[:month].nil? or params[:month].blank?
       params[:month] = "full"
     end
    if params[:party].nil? or params[:party].blank?
      params[:party] =  PartyFriend.joins(:mps,  :mpss).order("RANDOM()").pluck(:party).first
      params[:example_party] = 1
    end
     @party = PartyFriend.joins(:mps, :mpss).pluck(:party).uniq
     @month = PartyFriend.joins(:mps,:mpss).order(date_party_friend: :desc).pluck(:date_party_friend).uniq
  end
  def api
    party = PartyFriend.joins(:mps, :mpss).pluck(:party).uniq
    if params[:month] == "full"
       vote =  Division.all.size
       @vote =  [{faction: params[:party], date: "full", vote_aye: vote}]
       @vote += PartyFriend.joins(:mpss).where(party: params[:party]).order(count: :desc).map{|v| {faction: v.friend_party, date: v.date_party_friend.strftime('%Y-%m'), vote_aye: v.count}}
       p @vote
    else
      date = Date.strptime(params[:month],'%Y-%m')
      year_month = date.strftime('%Y-%m')
      date_min = year_month + "-01"
      date_max = date + 1.month
      vote = Division.where("date >= ? AND date < ?", date_min, date_max).size
      @vote =  [{faction: params[:party], date: params[:month], vote_aye: vote}]
      @vote += PartyFriend.joins(:mpss).where(party: params[:party], date_party_friend: Date.strptime(params[:month], '%Y-%m')).order(count: :desc).map{|v| {faction: v.friend_party, date: v.date_party_friend.strftime('%Y-%m'), vote_aye: v.count}}
    end
    vote_party = @vote.map{|p| p[:faction]}
    party_not_voted = party.find_all{|v| vote_party.include?(v) == false }
    unless party_not_voted.blank?
    @vote =  @vote + party_not_voted.map{|p| {faction: p, date: @vote.last[:date], vote_aye: 0} }
    end
    render :json => @vote
  end
end
