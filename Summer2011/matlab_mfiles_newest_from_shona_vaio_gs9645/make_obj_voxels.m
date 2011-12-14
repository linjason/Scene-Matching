%load '../results_bedroom_mat/ffba4dff25ec63a6cb2317d37aefa9a.mat'
%load '../../results_bedroom_2_mat/1ccd0add1c25c51bb89c4365c731e755.mat'
%load
%'../results_bedroom_2_mat/5bac5158cd663f106cff9b44fdf0517e.mat'
function [all_simplified_voxels] = make_obj_voxels(results_mat_name, obj_indices)
    load(strcat(strcat('../../results_ALL/', results_mat_name), ''));
    if (obj_indices==0)
    obj_nums = 1:length(A)-1;
else
    obj_nums=obj_indices;
end
    for obj_num = obj_nums

        disp(['computing heights obj ' num2str(obj_num) ' of ' num2str(length(A)-1)])

        ob_bounds_min = floor(min(cell2mat(A{obj_num}(1:2:end-1)')));
        ob_bounds_max = ceil(max(cell2mat(A{obj_num}(1:2:end-1)')));

        this_obj_voxels = logical(zeros(ob_bounds_max-ob_bounds_min+1,'uint8'));

        for compInd = 2:2:length(A{obj_num})
            points = A{obj_num}{compInd-1};
            tris = A{obj_num}{compInd};
            for tri_num = 1:size(tris,2)
		this_tri = abs(tris(:,tri_num));
		vertices_coords = points(this_tri,:);
                [tri_voxels vox_minX vox_minY vox_minZ] = triangle_voxelize(vertices_coords(1,:), vertices_coords(2,:), vertices_coords(3,:));
                [vox_x, vox_y, vox_z] = ind2sub(size(tri_voxels), find(tri_voxels));
                vox_x = vox_x+vox_minX-ob_bounds_min(1);
                vox_y = vox_y+vox_minY-ob_bounds_min(2);
                vox_z = vox_z+vox_minZ-ob_bounds_min(3);
                this_obj_voxels(sub2ind(size(this_obj_voxels), vox_x, vox_y, vox_z)) = 1;
            end
        end

        this_simplified_voxels = ones(size(this_obj_voxels));
        for xx = 1:size(this_simplified_voxels,1)
            for zz = 1:size(this_simplified_voxels,2)
                ind = find(this_obj_voxels(xx,zz,:),1, 'last');
                if(length(ind)==1)
                    this_simplified_voxels(xx,zz,ind+1:end) = 0;
                else
                    this_simplified_voxels(xx,zz,:) = 0;
                end
            end
        end
        for xx = 1:size(this_simplified_voxels,1)
            for yy = 1:size(this_simplified_voxels,3)
                ind = find(this_obj_voxels(xx,:,yy) ,1, 'last');
                if(length(ind)==1)
                    this_simplified_voxels(xx,ind+1:end,yy) = 0;
                else
                    this_simplified_voxels(xx,:,yy) = 0;
                end
            end
        end
        for xx = 1:size(this_simplified_voxels,1)
            for yy = 1:size(this_simplified_voxels,3)
                ind = find(this_obj_voxels(xx,:,yy) ,1, 'first');
                if(length(ind)==1)
                    this_simplified_voxels(xx,1:ind-1,yy) = 0;
                end
            end
        end
        for zz = 1:size(this_simplified_voxels,2)
            for yy = 1:size(this_simplified_voxels,3)
                ind = find(this_obj_voxels(:,zz,yy),1, 'last');
                if(length(ind)==1)
                    this_simplified_voxels(ind+1:end,zz,yy) = 0;
                else
                    this_simplified_voxels(:,zz,yy) = 0;
                end
            end
        end
        for zz = 1:size(this_simplified_voxels,2)
            for yy = 1:size(this_simplified_voxels,3)
                ind = find(this_obj_voxels(:,zz,yy),1, 'first');
                if(length(ind)==1)
                    this_simplified_voxels(1:ind-1,zz,yy) = 0;
                end
            end
        end
        


	all_vox{obj_num} = this_obj_voxels;
        all_simplified_voxels{obj_num} = this_simplified_voxels;
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
        %	all_ob_heights{obj_num} = this_obj_heights;
	all_ob_bounds{obj_num} = [ob_bounds_min ob_bounds_max];
        %			pause
    end
