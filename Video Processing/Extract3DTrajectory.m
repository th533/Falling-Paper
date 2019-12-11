init;

file_1='Circle_Exp_1_Radius_30_Vertical_Cam_1.mp4';
file_2='Circle_Exp_1_Radius_30_Vertical_Cam_2.mp4';

temp=strsplit(file_1,'_');
shape=char(temp(1));
experiment=num2str(char(temp(3)));
radius=num2str(char(temp(5)));

if strcmp(shape,'Cross')
    initialCondition=char(temp(8));
    width=char(temp(7));
else
    initialCondition=char(temp(6));
end


%Create video reader object
v1 = VideoReader(file_1);
v2 = VideoReader(file_2);


%Select correct mask for initial condition
if contains(initialCondition,'Horizontal')
    mask_1=MH1;
    mask_2=MH2;
else
    mask_1=MV1;
    mask_2=MV2;
end

%% Apply mask to each video
background_1 = readFrame(v1);
r=background_1(:,:,1);
g=background_1(:,:,2);
b=background_1(:,:,3);
r(~mask_1)=0;
g(~mask_1)=0;
b(~mask_1)=0;
background_1(:,:,1)=r;
background_1(:,:,2)=g;
background_1(:,:,3)=b;

background_2 = readFrame(v2);
r=background_2(:,:,1);
g=background_2(:,:,2);
b=background_2(:,:,3);
r(~mask_2)=0;
g(~mask_2)=0;
b(~mask_2)=0;
background_2(:,:,1)=r;
background_2(:,:,2)=g;
background_2(:,:,3)=b;

%% Initialize blob detection
BlobAnalysis = vision.BlobAnalysis('MinimumBlobArea',25,'LabelMatrixOutputPort',1,'ExcludeBorderBlobs',1,'MaximumCount',1);

%% Initialize trajectory, observable area and trace (for time-lapse) variables
trajectory_1=[];
trajectory_2=[];

area1=[];
area2=[];

trace_1=double(rgb2gray(background_1*0));
trace_2=double(rgb2gray(background_2*0));

%Cycle through frames
i=0;
while hasFrame(v1) %Read frame
    
    i=i+1;
    
    %% Apply mask
    frame_1 = readFrame(v1);
    r=frame_1(:,:,1);
    g=frame_1(:,:,2);
    b=frame_1(:,:,3);
    r(~mask_1)=0;
    g(~mask_1)=0;
    b(~mask_1)=0;
    frame_1(:,:,1)=r;
    frame_1(:,:,2)=g;
    frame_1(:,:,3)=b;
    
    
    frame_2 = readFrame(v2);
    r=frame_2(:,:,1);
    g=frame_2(:,:,2);
    b=frame_2(:,:,3);
    r(~mask_2)=0;
    g(~mask_2)=0;
    b(~mask_2)=0;
    frame_2(:,:,1)=r;
    frame_2(:,:,2)=g;
    frame_2(:,:,3)=b;
    
    %% Background subtraction
    diff_1 = (frame_1-background_1);
    diff_2 = (frame_2-background_2);
    
    bw_1 = im2bw(diff_1,0.3);
    bw_2 = im2bw(diff_2,0.3);
    
    %% Blob detection and centroid logging
    [area,centroid,bbox] = step(BlobAnalysis,bw_1); %Camera 1
    
    if ~isempty(centroid)
        trajectory_1(i,:) = centroid(1,:);
        area1(i)=area(1,:);
        trace_1 =trace_1+ bw_1;
    else
        trajectory_1(i,:)=[ NaN,NaN];
        area1(i)=NaN;
    end
    
    [area,centroid,bbox] = step(BlobAnalysis,bw_2); %Camera 2
    if ~isempty(centroid)
        trajectory_2(i,:) = centroid(1,:);
        area2(i)= area(1,:);
        trace_2=trace_2+  bw_2;
    else
        trajectory_2(i,:)= [NaN,NaN];
        area2(i) = NaN;
    end
end


if sum(isempty(trajectory_1))+sum(isempty(trajectory_1))==0 %Ignore empty trajectories (failed experiment, no paper detected) 
    
    stnm=1; %Remove initial NaN values before paper falls
    while isnan(trajectory_1(1,1)) || isnan(trajectory_1(1,2)) ||...
            isnan(trajectory_2(1,1)) || isnan(trajectory_2(1,2))
        trajectory_1(1,:)=[];
        trajectory_2(1,:)=[];
        area1(1)=[];
        area2(1)=[];
        stnm=stnm+1;
    end
    
    %Fill missing data points, smooth output
    trajectory_1(:,1)=smooth(fillmissing(trajectory_1(:,1),'linear'));
    trajectory_1(:,2)=smooth(fillmissing(trajectory_1(:,2),'linear'));
    trajectory_2(:,1)=smooth(fillmissing(trajectory_2(:,1),'linear'));
    trajectory_2(:,2)=smooth(fillmissing(trajectory_2(:,2),'linear'));
    area1=smooth(fillmissing(area1,'spline'));
    area2=smooth(fillmissing(area2,'spline'));
    
    %% Undistort image points
    trajectory_1=undistortPoints(trajectory_1,cameraParams);
    trajectory_2=undistortPoints(trajectory_2,cameraParams);
    
    %% Convert to world points
    worldPoints = triangulate(trajectory_1(1:end,:),trajectory_2(1:end,:),stereoParams);
    worldPoints= (worldPoints-translationVector)*pinv(rotationMatrix);
    
    %% Center in x-y- plane
    worldPoints(:,1:2)=worldPoints(:,1:2)-worldPoints(1,1:2);
    
    %% Trim trajectory to positive
    [kk ll]=min(abs(worldPoints(:,3)));
    worldPoints=worldPoints(1:ll,:);
    worldPoints(:,3)=-worldPoints(:,3);
    for w=1:length(worldPoints(:,3))
        if worldPoints(w,3)<0
            break
        end
    end
    
    worldPoints=worldPoints(1:w,:);
    area1=area1(1:w);
    area2=area2(1:w);
    trajectory_1=trajectory_1(1:w,:);
    trajectory_2=trajectory_2(1:w,:);
    
    %% Store results
    Results.points=worldPoints;
    Results.r=radius;
    Results.area1=area1;
    Results.area2=area2;
        
end

figure(1)
subplot(1,2,1)
plot(Results.points(:,1),Results.points(:,3))
xlabel('x (mm)')
ylabel('z (mm)')
xlim([-1000 1000])
ylim([0 1200])
subplot(1,2,2)
plot(Results.points(:,2),Results.points(:,3))
xlabel('y (mm)')
ylabel('z (mm)')
xlim([-1000 1000])
ylim([0 1200])

