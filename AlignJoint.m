function [data] = AlignJoint(segment, count)
lwristk = segment(62).PositionData;
rwristk = segment(63).PositionData;
lwrist = segment(38).PositionData;
rwrist = segment(59).PositionData;
lelbow = segment(6).PositionData;
relbow  = segment(7).PositionData;
lelb = segment(64).PositionData;
relb= segment(65).PositionData;

    for i = 1:(count)
        %Left%
        hk = -lwristk(:,i) + lelbow(:,i);
        hl = - lwrist(:,i) + lelb(:,i);
        R = vrrotvec(hl,hk);
        
        for j = 18:37
            segment(j).PositionData(:,i) =segment(j).PositionData(:,i)- lwrist(:,i);
            joint = segment(j).PositionData(:,i).' ;
            temp = rotVecAroundArbAxis(joint, R(1:3), R(4)*180/pi) + lwristk(:,i).';
            segment(j).PositionData(:,i) = temp.';
            
        end
        palm = (segment(26).PositionData(:,i) + segment(63).PositionData(:,i))/2;
        segment(60).PositionData = [segment(60).PositionData, palm];
        %end of Left%
        
        %Right%
        hk = -rwristk(:,i) + relbow(:,i);
        hl = - rwrist(:,i) + relb(:,i);
        R = vrrotvec(hl,hk);
        
        for j = 39:58
            segment(j).PositionData(:,i) =segment(j).PositionData(:,i)- rwrist(:,i);
            joint = segment(j).PositionData(:,i).' ;
            temp = rotVecAroundArbAxis(joint, R(1:3), R(4)*180/pi) + rwristk(:,i).';
            segment(j).PositionData(:,i) = temp.';
            
        end
        %end of Right%
        palm = (segment(47).PositionData(:,i) + segment(47).PositionData(:,i))/2;
        segment(61).PositionData = [segment(61).PositionData, palm];
    end
    
    data = segment;
end