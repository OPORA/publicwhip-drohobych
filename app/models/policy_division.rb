require 'distance'
class PolicyDivision < ApplicationRecord
  belongs_to :policy
  belongs_to :division
  has_paper_trail(
      meta: {
          policy_id: :policy_id,
          division_id: :division_id
      }
  )
  validates :division_id, presence: { message: "Поле політика є обовязуове" }, uniqueness:  { scope: :policy_id, message: ->(object, data) do "Голосування вже було добавлене до цієї політики!" end}
  after_create :create_person_distanse
  before_destroy :destroy_person_distanse
  before_update :destroy_person_distanse
  after_update :create_person_distanse
  def destroy_person_distanse
    not_agre = ["absent","abstain", "not_voted"]
    if self.changed?
      support = self.changed_attributes[:support]
    else
      support = self.support
    end
     #p "destroy"
     #p support
    self.division.votes.each do |v|
      policy_person_distanse = PolicyPersonDistance.where(deputy_id: v.mp.deputy_id, policy_id: self.policy_id).first
      case  support
        when  "aye_strong"
          if v.vote == "aye"
            policy_person_distanse.decrement!(:same_strong)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.decrement!(:absent_strong)
          else
            policy_person_distanse.decrement!(:diff_strong)
          end
        when "against_strong"
          if v.vote == "against"
            policy_person_distanse.decrement!(:same_strong)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.decrement!(:absent_strong)
          else
            policy_person_distanse.decrement!(:diff_strong)
          end
        else
          if v.vote == support
            policy_person_distanse.decrement!(:same)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.decrement!(:absent)
          else
            policy_person_distanse.decrement!(:diff)
          end
      end
      policy_person_distanse.distance = Distance.distance_a(policy_person_distanse.same, policy_person_distanse.diff , policy_person_distanse.absent, policy_person_distanse.same_strong, policy_person_distanse.diff_strong, policy_person_distanse.absent_strong )
      policy_person_distanse.save
    end
  end
  def create_person_distanse
    not_agre = ["absent","abstain", "not_voted"]
    #p "create"
    # p self.support

    self.division.votes.each do |v|
      policy_person_distanse = PolicyPersonDistance.where(deputy_id: v.mp.deputy_id, policy_id: self.policy_id).first_or_create
      case  self.support
        when "aye_strong"
          if v.vote == "aye"
            policy_person_distanse.increment!(:same_strong)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.increment!(:absent_strong)
          else
            policy_person_distanse.increment!(:diff_strong)
          end
        when "against_strong"
          if v.vote == "against"
            policy_person_distanse.increment!(:same_strong)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.increment!(:absent_strong)
          else
            policy_person_distanse.increment!(:diff_strong)
          end
        else
          if v.vote == self.support
            policy_person_distanse.increment!(:same)
          elsif not_agre.include?(v.vote)
            policy_person_distanse.increment!(:absent)
          else
            policy_person_distanse.increment!(:diff)
          end
      end
      policy_person_distanse.distance = Distance.distance_a(policy_person_distanse.same, policy_person_distanse.diff , policy_person_distanse.absent, policy_person_distanse.same_strong, policy_person_distanse.diff_strong, policy_person_distanse.absent_strong )
      policy_person_distanse.save
    end
  end
end
