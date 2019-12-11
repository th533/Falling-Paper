%% Script for classifying behaviours into three groups

%Large Scale Automated Investigation of Free-Falling Paper Shapes via Iterative Physical Experimentation
%Toby Howison, Josie Hughes & Fumiya Iida

dataProcessed=[]; %Initialize empty results 


for i=1:length(data) %Cycle through data

    %Unpack experimental data
    trajectory=data{i}.trajectory;
    initialCondition=data{i}.initialCondition;
    areaCam1=data{i}.areaCam1;
    areaCam2=data{i}.areaCam2;
    radius=data{i}.radius;
    try
    width=data{i}.width;
    catch
    end
    
    %Trim lower end of trajectory
    while trajectory(end,3)<0.05
        trajectory(end,:)=[];
        areaCam1(end)=[];
        areaCam2(end)=[];
    end
    
    %% Segment steady and periodic behaviours from trajectories
    if initialCondition==0 %We only see steady and periodic from horizontal initial condition    
        tc=1;
        
        %Detect steady and periodic behaviours
        while sqrt(trajectory(tc,1).^2+trajectory(tc,2).^2)< 0.2*radius && tc<(length(trajectory(:,1)))
            tc=tc+1;
        end
        
        %Segment trajectory into steady and periodic / unknown
        if tc>2 %If more than 2 time-steps of steady and periodic
            
            dataProcessed{end+1}.radius=radius;
            dataProcessed{end}.initialCondition=initialCondition;
            dataProcessed{end}.trajectory=trajectory(1:tc,:);
            dataProcessed{end}.areaCam1=areaCam1(1:tc);
            dataProcessed{end}.areaCam2=areaCam2(1:tc);
            dataProcessed{end}.behaviourAuto=3;
            try
                dataProcessed{end}.width=width;
            catch
            end
            
            if length(trajectory(:,1))-tc>10
                dataProcessed{end+1}.radius=radius;
                dataProcessed{end}.initialCondition=initialCondition;
                dataProcessed{end}.trajectory=trajectory(tc:end,:);
                dataProcessed{end}.areaCam1=areaCam1(tc:end);
                dataProcessed{end}.areaCam2=areaCam2(tc:end);
                dataProcessed{end}.behaviourAuto=NaN;
                try
                    dataProcessed{end}.width=width;
                catch
                end
            end
            
        else %No segmentation

            dataProcessed{end+1}.radius=radius;
            dataProcessed{end}.initialCondition=initialCondition;
            dataProcessed{end}.trajectory=trajectory;
            dataProcessed{end}.areaCam1=areaCam1;
            dataProcessed{end}.areaCam2=areaCam2;
            dataProcessed{end}.behaviourAuto=NaN;
            try
                dataProcessed{end}.width=width;
            catch
            end 
        end
       
    else %Vertical initial condition, no steady and peridoic behaviour
         
        tc=1;
        while sqrt(trajectory(tc,1).^2+trajectory(tc,2).^2)< 0.01 && tc<(length(trajectory(:,1)))
            tc=tc+1;
        end
        if length(trajectory(:,1))-tc>10
            dataProcessed{end+1}.radius=radius;
            dataProcessed{end}.initialCondition=initialCondition;
            dataProcessed{end}.trajectory=trajectory(tc:end,:);
            dataProcessed{end}.areaCam1=areaCam1(tc:end);
            dataProcessed{end}.areaCam2=areaCam2(tc:end);
            dataProcessed{end}.behaviourAuto=NaN;
            try
                dataProcessed{end}.width=width;
            catch
            end
        end
    end
    
      
end

%% Calculate parameters from trajectories 

%Initialize empty parameter results 
dx=[];
dy=[];
dz=[];
pathLength=[];
time=[];
radius=[];
X=[];
width=[];
behaviourAuto=[];


for i=1:length(dataProcessed) %Cycle through processed data

        %% Calculate path length
        stop=0;
        d=0;
        for j=2:length(dataProcessed{i}.trajectory(:,1))
            if norm(dataProcessed{i}.trajectory(j,:)-dataProcessed{i}.trajectory(j-1,:))>0.1
                stop=1;
                break
            end
            d=d+norm(dataProcessed{i}.trajectory(j,:)-dataProcessed{i}.trajectory(j-1,:));
        end
        
        
        if stop==0
            
            %Calculate parameters
            pathLength(end+1,1)=d;
            z=dataProcessed{i}.trajectory(:,3);
            dz(end+1,1)= abs(dataProcessed{i}.trajectory(end,3)-dataProcessed{i}.trajectory(1,3));
            dx(end+1,1)=(dataProcessed{i}.trajectory(end,1)-dataProcessed{i}.trajectory(1,1));
            dy(end+1,1)=(dataProcessed{i}.trajectory(end,2)-dataProcessed{i}.trajectory(1,2));
            time(end+1,1)=length(dataProcessed{i}.trajectory(:,1))*1/98;
            radius(end+1,1)=dataProcessed{i}.radius;
            behaviourAuto(end+1)=dataProcessed{i}.behaviourAuto;
           
            try
                width(end+1,1)=dataProcessed{i}.width;
            catch
            end
            
          
            [pks1,locs1] = findpeaks(dataProcessed{i}.areaCam1);
            [pks2,locs2] = findpeaks(dataProcessed{i}.areaCam2);
            
            Osc= (length(locs1)+length(locs2))/(2*time(end));
            SpeedZ= sqrt(var(diff(z,1)));            
            X(end+1,:)=[Osc SpeedZ];
            
       
            
        end
end

%Cluster Behaviours into 2 groups, chaotic and tumbling, using K-Means
%algorithm
behaviourAuto(isnan(behaviourAuto))=kmeans(X(isnan(behaviourAuto),:),2,'Replicates',3);



