require 'csv'
class ApiController < ApplicationController
  def init
    respond_to do |format|
      format.json
      format.csv
    end
  end
  def policies
    @polisies = Policy.all
    respond_to do |format|
      format.json  {render :json => @polisies.to_json(except: [:created_at,  :updated_at ])}
      format.csv  { send_data  @polisies.to_csv  }
    end
  end
  def policy
    @policy = Policy.find(params[:policy_id])
    respond_to do |format|
      format.json  {render :json => @policy.as_json(except: [:created_at,  :updated_at ],
                                                    :include  => {
                                                            policy_person_distances: {except: [:id, :policy_id, :distance, :created_at,  :updated_at ], :methods => [:agreement, :voted]} ,
                                                                  policy_divisions: {except: [:id, :policy_id, :created_at,  :updated_at ]}
                                                    }

      ).tap{|hash| hash["people_comparison"] = hash.delete "policy_person_distances"}}
      #format.csv  { send_data  @polisies.to_csv  }
    end
  end
  def divisions
    @divisions = Division.all.order(date: :desc)
    div =  @divisions.page(params[:page])
    current = div.current_page
    total = div.total_pages
    per_page =  div.first_page?
    respond_to do |format|
      format.json  {

          render :json =>

                      [ { current:   current,
                          previous: (current > 1 ? (current - 1) : nil),
                           next:     (current == total ? nil : (current + 1)),
                           per_page: per_page,
                           pages:    total,
                           count_page:    div.count,
                           count: @divisions.size
                           }] +
               div, :except => [ :created_at,  :updated_at ]
            }

      format.csv  { send_data  @divisions.to_csv}
    end
  end
  def division
    @division = Division.find(params[:division])
    respond_to do |format|
      format.json  {render :json => @division.to_json(except: [ :created_at,  :updated_at ],
      :include  => { division_info: {except: [ :created_at,  :updated_at ]},
                     votes: {except: [ :id, :division_id, :created_at,  :updated_at ]},
                     whips: {except: [ :id, :division_id, :created_at,  :updated_at ]}
          })
      }
      if params[:filter] == "info"
        format.csv {send_data @division.division_infos.to_csv}
      elsif params[:filter] == "whips"
        format.csv {send_data @division.whips.to_csv}
      else
        format.csv {send_data @division.votes.to_csv}
      end
    end
  end
  def mps
    @mps = Mp.all
    respond_to do |format|
      format.json  {render :json => @mps.to_json(except: [:created_at,  :updated_at ])}
      format.csv  { send_data @mps.to_csv  }
    end
  end
  def mp
    deputy_id = params[:deputy_id].to_i
    @mp = Mp.find_by_id(deputy_id)
    unless @mp.blank?
      respond_to do |format|
        format.json  {render :json => @mp.to_json(except: [:created_at,  :updated_at ],
                                                  :include => {
                                                      mp_infos: {
                                                          only: [:rebellions,
                                                                 :not_voted,
                                                                 :absent,
                                                                 :against ,
                                                                 :aye_voted,
                                                                 :abstain,
                                                                 :votes_possible,
                                                                 :votes_attended,
                                                                 :date_mp_infodist_a
                                                                  ]
                                                          },
                                                      mp_friends: {except: [
                                                          :deputy_id,
                                                          :created_at,
                                                          :updated_at
                                                          ]
                                                        }
                                                      }

                                                  )
        }

        format.csv  { send_data  @mp.mp_infos.mp_to_csv , :filename =>  @mp.full_name + '.csv' }
      end
    else
      respond_to do |format|
        format.json {render :json => "Not Found Deputy id: #{deputy_id}"}
      end
    end
  end
end

