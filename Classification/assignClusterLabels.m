%% Assign chaotic and tumbling labels to unsupervised cluster labels

%Large Scale Automated Investigation of Free-Falling Paper Shapes via
%Iterative Physical Experimentation
%Toby Howison, Josie Hughes & Fumiya Iida

%Create confusion matricies with original cluster labels
C1=confusionmat(behaviourAuto,behaviourHuman)/length(behaviourAuto);

%Reassign labels 1 & 2
temp=behaviourAuto;
temp(behaviourAuto==1)=2;
temp(behaviourAuto==2)=1;

%Create second confusion matrix
C2=confusionmat(temp,behaviourHuman)/length(behaviourAuto);

%Select configuration with largest correctly classified proportion
if sum(diag(C1))>sum(diag(C2))
      
else
    behaviourAuto=temp;   
end
