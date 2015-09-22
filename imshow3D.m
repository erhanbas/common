function [outputArgs] = imshow3D(In,all,rangeIm)
%IMSHOW3D Summary of this function goes here
%
% [OUTPUTARGS] = IMSHOW3D(INPUTARGS) Explain usage here
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

% $Author: base $	$Date: 2015/09/03 14:52:20 $	$Revision: 0.1 $
% Copyright: HHMI 2015
if nargin<2
    all = 0;
    rangeIm = [min(In(:)) max(In(:))];
elseif nargin <3
    rangeIm = [min(In(:)) max(In(:))];
end

if all
%     figure(),
    subplot(221)
    I3 = squeeze(max(In,[],1));
    if max(I3(:))>2^8
        imshow(uint16(I3),rangeIm), 
    else
        imshow(I3,rangeIm),
    end
    title('1')

    subplot(222)
    I3 = squeeze(max(In,[],2));
    if max(I3(:))>2^8
        imshow(uint16(I3),rangeIm), 
    else
        imshow(I3,rangeIm),
    end
    title('2')

    subplot(223)
    I3 = squeeze(max(In,[],3));
    if max(I3(:))>2^8
        imshow(uint16(I3),rangeIm), 
    else
        imshow(I3,rangeIm),
    end
    title('3')
else
%     figure(),
    subplot(111)
    I3 = squeeze(max(In,[],3));
    if max(I3(:))>2^8
        imshow(uint16(I3),rangeIm), 
    else
        imshow(I3,rangeIm),
    end
    title('3')

end
