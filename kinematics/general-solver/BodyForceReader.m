function BodyForceReader(q,A,p)
% Takes equilibrium matrix and cable force densities, prints out forces and
% moments from cables on bodies  

bodies = size(A,1)/6;

cableOuts = A*q;
disp(' ')
for a = 1:7
    indices = a:bodies:a+5*bodies;
    bodyOuts = cableOuts(indices);
    disp(['For body ' num2str(a) ' cable forces produce'])
    disp(['X Force:' num2str(-bodyOuts(1)) ' criteria:' num2str(p(indices(1)))])
    disp(['Y Force:' num2str(-bodyOuts(2)) ' criteria:' num2str(p(indices(2)))])
    disp(['Z Force:' num2str(-bodyOuts(3)) ' criteria:' num2str(p(indices(3)))])
    disp(['X Moment:' num2str(bodyOuts(4)) ' criteria:' num2str(p(indices(4)))])
    disp(['Y Moment:' num2str(bodyOuts(5)) ' criteria:' num2str(p(indices(5)))])
    disp(['Z Moment:' num2str(bodyOuts(6)) ' criteria:' num2str(p(indices(6)))])
    disp(' ')
end



end