function [G,subs] = filtGcompdist(G,subs,argin)
%FILTGCOMPDIST filters isolated components
% $Author: base $	$Date: 2018/12/15 01:10:55 $
% Copyright: HHMI 2018

sizeThr = argin{1};
CompsC = conncomp(G,'OutputForm','cell');
% S = length(CompsC);
Y = cellfun(@length,CompsC);
deletethese = (Y<sizeThr);
cpl = [CompsC{deletethese}];
G = rmnode(G,cpl);
subs(cpl,:)=[];
end
