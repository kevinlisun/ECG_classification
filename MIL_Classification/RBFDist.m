function [distance] = RBFDist(inst_1,inst_2,param)

    distance = exp(-1*param*Dist(inst_1,inst_2));