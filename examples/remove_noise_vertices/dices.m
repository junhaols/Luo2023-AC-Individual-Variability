function dice = dices(vect1, vect2)

ind1 = find(vect1>0);
ind2 = find(vect2>0);

vect = intersect(ind1, ind2);

dice = 2*(length(vect)) / (length(ind1) + length(ind2));



