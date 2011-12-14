function [score score2 score3 score4]=compareTwoSimpVoxels(a,b)
    score=0;
    score2=0;
    score3=0;
    score4=0;
    b2=zeros(size(b));
    for i=1:size(a,3)
        b2(:,:,i)=rot90(b(:,:,i),1);
        b3(:,:,i)=rot90(b(:,:,i),2);
        b4(:,:,i)=rot90(b(:,:,i),3);
    end
    for i=1:size(a,1);
        for j=1:size(a,2);
            for k=1:size(a,3);
                score=score+(a(i,j,k)-b(i,j,k))^2;
                score2=score2+(a(i,j,k)-b2(i,j,k))^2;
                score3=score3+(a(i,j,k)-b3(i,j,k))^2;
                score4=score4+(a(i,j,k)-b4(i,j,k))^2;
            end
        end
    end