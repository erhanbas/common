function indsout = sub2ind_withnan(dims,subs)
% return nan for out of bound
validinds = dims(1) >= subs(:,1) & 0 < subs(:,1) & ...
    dims(2) >= subs(:,2) & 0 < subs(:,2) & ...
    dims(3) >= subs(:,3) & 0 < subs(:,3);

indsout = nan(size(subs,1),1);
indsout(validinds) = sub2ind(dims,subs(validinds,1),subs(validinds,2),subs(validinds,3));
