function [all_ob_heights, all_ob_heights3, all_ob_heights2, all_ob_heights4] = make_obj_height_map3(results_mat_name, obj_indices)
load(strcat(strcat('../../results_bedroom_2_mat/', results_mat_name), ''));

if (obj_indices==0)
    obj_nums = 1:length(A)-1;
else
    obj_nums=obj_indices;
end

for obj_num=obj_nums
    
    disp(['computing heights obj ' num2str(obj_num) ' of ' num2str(length(obj_nums))])
    
    ob_bounds_min = floor(min(cell2mat(A{obj_num}(1:2:end-1)')));
    ob_bounds_max = ceil(max(cell2mat(A{obj_num}(1:2:end-1)')));
    
    this_obj_voxels = logical(zeros(ob_bounds_max-ob_bounds_min+1,'uint8'));
    
    for compInd = 2:2:length(A{obj_num})
        points = A{obj_num}{compInd-1};
        tris = A{obj_num}{compInd};
        for tri_num = 1:size(tris,2)
            this_tri = abs(tris(:,tri_num));
            vertices_coords = points(this_tri,:);
            [tri_voxels vox_minX vox_minY vox_minZ] = triangle_voxelize3(vertices_coords(1,:), vertices_coords(2,:), vertices_coords(3,:));
            [vox_x, vox_y, vox_z] = ind2sub(size(tri_voxels), find(tri_voxels));
            vox_x = vox_x+vox_minX-ob_bounds_min(1);
            vox_y = vox_y+vox_minY-ob_bounds_min(2);
            vox_z = vox_z+vox_minZ-ob_bounds_min(3);
            this_obj_voxels(sub2ind(size(this_obj_voxels), vox_x, vox_y, vox_z)) = 1;
        end
    end
    
    this_simplified_voxels = zeros(size(this_obj_voxels));
    this_obj_heights = zeros(size(this_simplified_voxels,1), size(this_simplified_voxels,3));
    this_obj_heights2 = zeros(size(this_simplified_voxels,1), size(this_simplified_voxels,3));
    this_obj_heights3 = zeros(size(this_simplified_voxels,2), size(this_simplified_voxels,3));
    this_obj_heights4 = zeros(size(this_simplified_voxels,2), size(this_simplified_voxels,3));
    
    for xx = 1:size(this_simplified_voxels,1)
        for yy = 1:size(this_simplified_voxels,3)
            ind = find(this_obj_voxels(xx,:,yy),1, 'first');
            ind2 = find(this_obj_voxels(xx,:,yy),1, 'last');
            if(length(ind)==1)
                this_obj_heights(xx,yy) = size(this_simplified_voxels,2) - ind;
            end
            if(length(ind2)==1)
                this_obj_heights2(xx,yy) = ind2;
            end
            
        end
    end
    
    for zz = 1:size(this_simplified_voxels,2)
        for yy = 1:size(this_simplified_voxels,3)
            ind3 = find(this_obj_voxels(:,zz,yy),1, 'first');
            ind4 = find(this_obj_voxels(:,zz,yy),1, 'last');
            if(length(ind3)==1)
                this_obj_heights3(zz,yy) = size(this_simplified_voxels,1) - ind3;
            end
            if(length(ind4)==1)
                this_obj_heights4(zz,yy) = ind4;
            end
        end
    end
    
    
    
    %this_obj_voxels = this_simplified_voxels;
    %			figure
    %			subplot(2,2,1)
    %			imagesc(squeeze(sum(this_obj_voxels,1)));
    %			axis image;
    %			subplot(2,2,2)
    %			imagesc(squeeze(sum(this_obj_voxels,3)));
    %			axis image;
    %			subplot(2,2,3)
    %			imagesc(squeeze(sum(this_obj_voxels,2)));
    %			axis image;
    %			subplot(2,2,4)
    %			imagesc(this_obj_heights>0);
    %			axis image;
    all_ob_heights{obj_num} = this_obj_heights;
    all_ob_heights2{obj_num} = flipud(this_obj_heights2);
    all_ob_heights3{obj_num} = flipud(this_obj_heights3);
    all_ob_heights4{obj_num} = this_obj_heights4;
    all_ob_bounds{obj_num} = [ob_bounds_min ob_bounds_max];
    %			pause
end
