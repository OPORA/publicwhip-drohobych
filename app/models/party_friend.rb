class PartyFriend < ApplicationRecord
    has_many :mps,->{where(mps:{end_date:"9999-12-31"})}, class_name: 'Mp', foreign_key: "faction", primary_key: "party"
    has_many :mpss, -> {where(mps:{end_date:"9999-12-31"})},  class_name: "Mp", foreign_key: "faction", primary_key: "friend_party"
end
