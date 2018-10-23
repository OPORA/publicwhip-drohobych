class Policy < ApplicationRecord
  has_many :policy_divisions
  has_many :policy_person_distances

  validates :name, presence: true
  validates :description, presence: true
  has_paper_trail(meta: {policy_id: :id})
  scope :very_strongly_for,     -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.00, 0.05) }
  scope :strongly_for,          -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.05, 0.15) }
  scope :moderately_for,        -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.15, 0.40) }
  scope :for_and_against,       -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.40, 0.60).where("( same + same_strong + diff + diff_strong ) > 0") }
  scope :moderately_against,    -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.60, 0.85) }
  scope :strongly_against,      -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.85, 0.95) }
  scope :very_strongly_against, -> { where("policy_person_distances.distance >= ? AND policy_person_distances.distance < ?", 0.95, 1.0) }
  scope :never_voted,           -> { where("same = 0 and same_strong = 0 and diff = 0 and diff_strong = 0") }

  def self.filter_polices(param)
    if param.nil?
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

  def self.find_by_search_query(query)
    where("UPPER(name) like :query_name ", { query_name: "%#{query.upcase}%" })
  end
  def self.to_csv
    CSV.generate do |csv|
      csv << ['id', 'name', 'description', 'provisional']
      all.each do |mp|
        csv << [mp.id, mp.name, mp.description, mp.provisional]
      end
    end
  end
end
