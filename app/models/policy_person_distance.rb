class PolicyPersonDistance < ApplicationRecord
  belongs_to :policy
  belongs_to :mp, primary_key: :deputy_id, foreign_key: :deputy_id, class_name: 'Mp'
  scope :very_strongly_for,     -> { where(distance: (0.00...0.05)) }
  scope :strongly_for,          -> { where(distance: (0.05...0.15)) }
  scope :moderately_for,        -> { where(distance: (0.15...0.40)) }
  scope :for_and_against,       -> { where(distance: (0.40...0.60)).where("( same + same_strong + diff + diff_strong ) > 0") }
  scope :moderately_against,    -> { where(distance: (0.60...0.85)) }
  scope :strongly_against,      -> { where(distance: (0.85...0.95)) }
  scope :very_strongly_against, -> { where(distance: (0.95..1.0)) }
  scope :never_voted,           -> { where(same: 0, same_strong: 0, diff: 0, diff_strong: 0) }
  def agreement
    (1 - self.distance) * 100.to_f
  end
  def voted
    if same == 0 and same_strong == 0 and diff == 0 and diff_strong == 0
      return false
    else
      return true
    end
  end
  def self.filter_polices(param)
    if param=="1"
      very_strongly_for
    elsif param =="2"
      strongly_for
    elsif  param =="3"
      moderately_for
    elsif  param =="4"
      for_and_against
    elsif  param =="5"
      moderately_against
    elsif param =="6"
      strongly_against
    elsif param =="7"
      very_strongly_against
    elsif param =="8"
      never_voted
    end
  end
end
