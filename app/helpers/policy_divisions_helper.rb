module PolicyDivisionsHelper
  def most_recent_version(item_type, item_id)
    PaperTrail::Version.where.not(event: "destroy" ).order(created_at: :desc).find_by(item_type: item_type, item_id: item_id)
  end
  def policy_name(policy_id)
    Policy.find(policy_id).name
  end
  def divisions_name(division_id)
    Division.find(division_id).name
  end
  def div_path(division_id)
    div = Division.find(division_id)
    {date: div.date, id: div.number }
  end
  def display_support(item)
    case item
      when "aye_strong"
        "ТВЕРДО ЗА"
      when "against_strong"
        "СУВОРО ПРОТИ"
      when "aye"
        "ЗА"
      when "against"
        "ПРОТИ"
    end
  end
end
