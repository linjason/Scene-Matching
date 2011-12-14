function [score score2 score3 score4 b2]=compareTwoSimpVoxelsUnionIntersect(a,b)
    score=0;
    score2=0;
    score3=0;
    score4=0;
    b2=zeros(size(b));
    b3=zeros(size(b));
    b4=zeros(size(b));
    union=0;
    union2=0;
    union3=0;
    union4=0;
    intersection=0;
    intersection2=0;
    intersection3=0;
    intersection4=0;
    for i=1:size(a,3)
        b2(:,:,i)=rot90(b(:,:,i),1);
        b3(:,:,i)=rot90(b(:,:,i),2);
        b4(:,:,i)=rot90(b(:,:,i),3);
    end
    for k=1:size(a,1);
        for j=1:size(a,2);
            for i=1:size(a,3);
                if a(i,j,k)==1 && b(i,j,k)==1
                    intersection=intersection+1;
                end
                if a(i,j,k)==1 || b(i,j,k)==1
                    union=union+1;
                end
                if a(i,j,k)==1 && b2(i,j,k)==1
                    intersection2=intersection2+1;
                end
                if a(i,j,k)==1 || b2(i,j,k)==1
                    union2=union2+1;
                end
                if a(i,j,k)==1 && b3(i,j,k)==1
                    intersection3=intersection3+1;
                end
                if a(i,j,k)==1 || b3(i,j,k)==1
                    union3=union3+1;
                end
                if a(i,j,k)==1 && b4(i,j,k)==1
                    intersection4=intersection4+1;
                end
                if a(i,j,k)==1 || b4(i,j,k)==1
                    union4=union4+1;
                end
            end
        end
k;
union2;
intersection2;
    end
    score=intersection/union;
    score2=intersection2/union2;
    score3=intersection3/union3;
    score4=intersection4/union4;
