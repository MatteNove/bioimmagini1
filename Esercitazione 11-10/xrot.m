function Rx=xrot(teta)
        
        Rx=[1, 0, 0;
            0, cos(teta), -sin(teta);
            0, sin(teta), cos(teta)];
end
