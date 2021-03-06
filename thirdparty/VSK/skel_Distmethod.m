function skel_Distmethod(voxel, show, rows, cols, slices, XX, YY, ZZ, AZ, EL, rev)
%
% Compute skeleton of input volume data by using Distance Matrix Method. 
%
%
% input:
% voxel: a binary 3D matrix thresholded from original data
% show:  a copy of original voxel. Sometimes voxel has been morphologically 
%        processed or filtered and cannot display as its initial stage
% rows, cols, slices are 3 dimensions of voxel
% XX, YY, ZZ are coordinates of a 3D rectangular grid with the same size of
% AZ and EL  are both view angles of which AZ is the azimuth or horizontal
% rotation and EL is the vertical elevation (both in degrees).
% rev:   a boolean value indicating if the view need to be reversed
%
% ---------------------------
% written by Li Liu in 01/01/2013 
% l.liu6819@gmail.com
%

foldername='Skeleton_results';

%%
[object_pos, boundary_pos, object, boundary] = segmentation(voxel, rows, cols, slices);
num_object=size(object_pos,1);
num_boundary=size(boundary_pos,1);

%%
DisMatrix = skel_computeDisMatrix(voxel, boundary_pos, object_pos, num_boundary, num_object);

th = input('Please set a distance value threshold to the selected skeleton points.([]=default: 1): ');

if isempty(th)
    th = 1;
end

disp('Please choose a method to find the skeleton points from the following:');
disp(' ');
disp('******************************************************');
disp('1     filtering with 6-adjacent neighbors');
disp('2     filtering with 18-adjacent neighbors');
disp('3     filtering with 26-adjacent neighbors');
disp('4     filtering with 124-adjacent neighbors');
disp('5     filtering with 342-adjacent neighbors');
disp('******************************************************');
disp(' ');

method = input('Please choose a method (1~4): ');

switch method
    case 1,
        [num_ridge, ridge, ridge_pos] = skel_findpoint_filter6(voxel, DisMatrix, rows, cols, slices, th);
    case 2,
        [num_ridge, ridge, ridge_pos] = skel_findpoint_filter18(voxel, DisMatrix, rows, cols, slices, th);
    case 3,
        [num_ridge, ridge, ridge_pos] = skel_findpoint_filter26(voxel, DisMatrix, rows, cols, slices, th);
    case 4,
        [num_ridge, ridge, ridge_pos] = skel_findpoint_filter124(voxel, DisMatrix, rows, cols, slices, th);
    case 5,
        [num_ridge, ridge, ridge_pos] = skel_findpoint_filter342(voxel, DisMatrix, rows, cols, slices, th);   
end

skel_show3D(XX,YY,ZZ,show,0.5,6,AZ,EL,0.1);
hold on
point_x=ridge_pos(1:num_ridge(1),2);
point_y=ridge_pos(1:num_ridge(1),1);
point_z=ridge_pos(1:num_ridge(1),3);

plot3(point_x, point_y, point_z, 'r*');
hold off
title('data with skeleton points');
view(AZ,EL); 
axis tight
grid on 

if rev==1
    set(gca, 'ZDir','reverse');
end
str='skeleton points';
filename = fullfile(foldername, [str '.' 'fig']);  
saveas(gcf, filename);
filename = fullfile(foldername, [str '.' 'jpg']);  
print(gcf, '-djpeg', filename); 

%%
T=connection(voxel, num_ridge, ridge_pos, rows, cols, slices);
[m,n]=size(T);

skel_show3D(XX,YY,ZZ,show,0.5,7,AZ,EL,0.1);
hold on

for i=1:m
    for j=i:n
       
        if T(i,j)==1
            start_x=ridge_pos(i,2);
            start_y=ridge_pos(i,1);
            start_z=ridge_pos(i,3);
            end_x=ridge_pos(j,2);
            end_y=ridge_pos(j,1);
            end_z=ridge_pos(j,3);
            
            plot3([start_x,end_x],[start_y,end_y],[start_z,end_z], '-rs','LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','y',  'MarkerSize',3);
            hold on
        end       
        
    end
end

hold off
title('skeleton of the data');
view(AZ, EL); 
axis tight
% grid on 
if rev==1
    set(gca, 'ZDir','reverse');
end
str='skeleton of the data';
filename = fullfile(foldername, [str '.' 'fig']);  
saveas(gcf, filename);
filename = fullfile(foldername, [str '.' 'jpg']);  
print(gcf, '-djpeg', filename); 


connect_num=sum(sum(T))/2;
[sk_X,sk_Y,sk_Z]=GetSkel(voxel,T,ridge_pos,connect_num,rows,cols,slices,50);
skel_X=reshape(sk_X, [50, connect_num]);
skel_Y=reshape(sk_Y, [50, connect_num]);
skel_Z=reshape(sk_Z, [50, connect_num]);
skeleton_X=skel_X';
skeleton_Y=skel_Y';
skeleton_Z=skel_Z';

s=struct('Name','data','X',skeleton_X,'Y',skeleton_Y,'Z',skeleton_Z,'AZ',AZ,'EL',EL,'Reverse',rev);
save('Skeleton_results\skeleton', '-struct', 's');
disp(' ');
disp('All work has been finished!');
disp(' ');


