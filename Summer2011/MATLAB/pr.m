aa=[finalScores;target]';
sorted=sortrows(aa);
sortedLabels=sorted(1:1:end,2);
%sortedLabels=sorted(end:-1:1,2);
re=cumsum(sortedLabels)/sum(sortedLabels);
pre=cumsum(sortedLabels)./(1:length(sortedLabels))';

%figure
if plotColor==1
subplot(1,1,1),plot(re,pre,'r')
elseif plotColor==2
subplot(1,1,1),plot(re,pre,'g')
elseif plotColor==3
subplot(1,1,1),plot(re,pre,'y')
elseif plotColor==4
subplot(1,1,1),plot(re,pre,'c')
elseif plotColor==5
subplot(1,1,1),plot(re,pre,'m')
elseif plotColor==6
subplot(1,1,1),plot(re,pre,'b')
end
