module PolicyPepoleHelper
    def for_policy(policy_distance)
        if policy_distance.same == 0 and policy_distance.same_strong == 0 and policy_distance.diff == 0 and policy_distance.diff_strong == 0
           return "Ніколи не голосує" #"never_voted"
        elsif policy_distance.distance >= 0.00 and policy_distance.distance < 0.05
            return "Максимально голосує за" #very_strongly_for" 
        elsif policy_distance.distance >= 0.05 and policy_distance.distance < 0.15    
            return "Послідовно голосує за" #"strongly_for"
        elsif policy_distance.distance >= 0.15 and policy_distance.distance < 0.40
            return "Переважно голосує за" #"moderately_for"  
        elsif policy_distance.distance >= 0.40 and policy_distance.distance < 0.60
            return "Суміш за та проти"#"for_and_against" 
        elsif policy_distance.distance >= 0.60 and policy_distance.distance < 0.85
            return "Переважно голосує проти" #"moderately_against"
        elsif policy_distance.distance >= 0.85 and policy_distance.distance < 0.95
            return "Послідовно голосує проти" #"strongly_against"
        elsif policy_distance.distance >= 0.95 and policy_distance.distance < 1.0            
            return "Максимально голосує проти" #"very_strongly_against"
        end    
    end    
end
