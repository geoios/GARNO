function [X] = SeafloorPolCusPoints(MP,h)

 X  = [SeafloorPolygonPoints(MP{1},h);SeafloorCustomizePoints(MP{2},h)];

end

