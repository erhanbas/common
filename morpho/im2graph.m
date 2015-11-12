function [intree] = im2graph(IM,debug)
%IM2GRAPH Converts an image to an affinity graph
%
% [OUTPUTARGS] = IM2GRAPH(INPUTARGS) Explain usage here
%
% Inputs:
%
% Outputs:
%
% Examples:
%
% Provide sample usage code here
%
% See also: List related files here

% $Author: base $	$Date: 2015/10/20 10:11:33 $	$Revision: 0.1 $
% Copyright: HHMI 2015
if nargin<2
    debug = 0;
end
IM = IM>0;
% pad zeros
IM = padarray(IM,[1 1 1],0,'both');
dims = size(IM);
nout = length(dims);

%Compute linear indices
k = [1 cumprod(dims(1:end-1))];
x = [-1:1];
out = zeros(nout^nout,nout);
siz = nout*ones(1,nout);
for i=1:nout
    s = ones(1,nout);
    s(i) = numel(x);
    x = reshape(x,s);
    s = siz;
    s(i) = 1;
    dum = repmat(x,s);
    out(:,i) = dum(:);
end
idxneig = out*k';
idxneig((numel(idxneig)+1)/2)=[];
%%
%Create affinity matrix
idx = find(IM);
if numel(IM)/2<length(idx)
    warning('dense image, might take sime time to build graph. Consider to make input IM sparse')
end

%%
clear E
it = 1;

for i=idx(:)'
    if debug
        if ~rem(it,max(1,round(numel(idx)/10)))
            sprintf('Building graph: %%%d',round(100*it/numel(idx)))
        end
    end
    id = i+idxneig;
    neigs = find(IM(id));
    
    E{it} = [[i*ones(length(neigs),1) id(neigs)] ]';%-(sum(k)+1)
    it = it+1;
end
edges = [E{:}]';
[keepthese,ia,ic] = unique(edges(:));
[subs(:,2),subs(:,1),subs(:,3)] = ind2sub(dims,keepthese);
edges_ = reshape(ic,[],2);

%%
% permute edges
A = sparse(edges_(:,1),edges_(:,2),1,max(edges_(:)),max(edges_(:)));
A = max(A',A);
A(find(speye(size(A)))) = 0;

[S,C] = graphconncomp(A);
Y = histcounts(C,1:S+1);
A_ = A;
A_(find(triu(A_,0)))=0;

%%
% %%
% idpar = A_*(1:size(A_,1))'; % simple graph theory: feature of adjacency matrix
% 
% %%
ly = 1:length(Y);%find(Y>1);
% iC = randperm(length(ly));
% Io = zeros(dims);
clear Eout
for ii=1:length(ly)
    %%
    subidx = find(C==ly(ii));
    Asub = A_(subidx,subidx);
    leafs = find(sum(Asub,2)==0);%find(sum(max(Asub,Asub'))==1,1);
    [dist,path,pred] = graphshortestpath(Asub,leafs,'directed','false');
    % create an affinity map
    eout = [([1:size(Asub,1)]') (pred(:))];
    eout(eout(:,2)==0,:) = [];
%     Eout{ii} =subidx(sort(eout,2,'descend'))';
    Eout{ii} =subidx(eout)';
end
edgesout = [Eout{:}]';
% Io = Io(2:end-1,2:end-1,2:end-1);
%
Aout = sparse(edgesout(:,1),edgesout(:,2),1,max(edgesout(:)),max(edgesout(:)));
% [S,C] = graphconncomp(Aout,'directed','false');

intree.dA = Aout;
intree.R = ones(size(A_,1),1);
intree.D = ones(size(A_,1),1);
intree.X = subs(:,1)-1; % subtract padsize
intree.Y = subs(:,2)-1; % subtract padsize
intree.Z = subs(:,3)-1; % subtract padsize
























