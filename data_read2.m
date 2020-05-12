%%
clear all
close all

%% 被験者の特徴
h1 = 1.82;
h2 = 1.84;
h3 = 1.78;
h4 = 1.71;
h5 = 1.73;
h6 = 1.78;
h7 = 1.65;
h8 = 1.79;

%% 被験者の特徴
sub.num = 15;

sub1 = 1;
sub2 = 2;
sub3 = 3;
sub4 = 4;
sub5 = 5;
sub6 = 6;
sub7 = 7;
sub8 = 8;
sub9 = 9;
sub10 = 10;
sub11 = 11;
sub12 = 12;
sub13 = 13;
sub14 = 14;
sub15 = 15;

%% データの読み込み
drive_org       = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    fname           = sprintf('result%s%d%ctrial_%d','\sub.',i,'\',j);
    folder          = dir(fname);
    folder_vicon1    = folder(3,1).name;
    folder_vicon2    = folder(4,1).name;
    folder_vicon3    = folder(5,1).name;
    fname_vicon1     = sprintf('result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon1);
    fname_vicon2     = sprintf('result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon2);
    fname_vicon3     = sprintf('result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon3);
    data1 = csvread(fname_vicon1);
    data2 = csvread(fname_vicon2);
    data3 = csvread(fname_vicon3);
      for k = 1 : 3
          drive_org{i,1}{j,1}   = data2;
          drive_org{i,1}{j,2}   = data3;
          drive_org{i,1}{j,3}   = data1;
      end
    end
end

%% 状態の選定（右足、左足のそれぞれ離れるタイミング
time_se = csvread('time_se.csv');
time_se1 = zeros(4,sub.num*3);
time_se2 = zeros(4,sub.num*3);
time_decision = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
        for m = time_se(1,j+(i-1)*3) : time_se(2,j+(i-1)*3)
             time_decision{i,1}{j,1}(m-time_se(1,j+(i-1)*3)+1,1) = drive_org{i,1}{j,2}(m+1,117)-drive_org{i,1}{j,2}(m,117);
             time_decision{i,1}{j,2}(m-time_se(1,j+(i-1)*3)+1,1) = drive_org{i,1}{j,2}(m+1,118)-drive_org{i,1}{j,2}(m,118);
        end
    
        if  max(time_decision{i,1}{j,1}) > 1.5
           L1 = find(1.5 < time_decision{i,1}{j,1});
           [a,R1] = min(L1);
        elseif max(time_decision{i,1}{j,1}) < 1.5
           [R1,a] = max(time_decision{i,1}{j,1});
        end
        if  max(time_decision{i,1}{j,2}) > 1.5
           L2 = find(1.5 < time_decision{i,1}{j,2});
           [b,R2] = min(L2);
        elseif max(time_decision{i,1}{j,2}) < 1.5
           [R2,b] = max(time_decision{i,1}{j,2});    
        end
    
    for l = time_se(2,j+(i-1)*3) : time_se(3,j+(i-1)*3)
       time_decision{i,1}{j,7}(l-time_se(2,j+(i-1)*3)+1 ,1) = drive_org{i,1}{j,2}(l+1,99)-drive_org{i,1}{j,2}(l,99);
    end
    L3 = find(5 < time_decision{i,1}{j,7});
    [c,R3] = min(L3);
    
    [d1,L21] = min(drive_org{i,1}{j,2}(time_se(3,j+(i-1)*3):time_se(4,j+(i-1)*3),98));
    [d2,L22] = min(drive_org{i,1}{j,2}(time_se(3,j+(i-1)*3):time_se(4,j+(i-1)*3),101));
    
    time_se1(1,j+(i-1)*3) = min(a,b) + time_se(1,j+(i-1)*3)-1;
    time_se1(3,j+(i-1)*3) = c + time_se(2,j+(i-1)*3)-1;
    time_se1(4,j+(i-1)*3) = min(L21,L22) + time_se(3,j+(i-1)*3)-1;
    end
end

%%
for i = 1: sub.num
    for j = 1 : 3
        for k = time_se(2,j+(i-1)*3) : time_se(3,j+(i-1)*3)
            time_decision{i,1}{j,3}(k-time_se(2,j+(i-1)*3)+1 ,1) = drive_org{i,1}{j,2}(k+1,114)-drive_org{i,1}{j,2}(k,114);
            time_decision{i,1}{j,4}(k-time_se(2,j+(i-1)*3)+1 ,1) = drive_org{i,1}{j,2}(k+1,116)-drive_org{i,1}{j,2}(k,116);
        end
    
        for k = time_se(2,j+(i-1)*3) : time_se(3,j+(i-1)*3)
           time_decision{i,1}{j,5}(k-time_se(2,j+(i-1)*3)+1 ,1) = drive_org{i,1}{j,2}(k+1,117)-drive_org{i,1}{j,2}(k,117);
           time_decision{i,1}{j,6}(k-time_se(2,j+(i-1)*3)+1 ,1) = drive_org{i,1}{j,2}(k+1,119)-drive_org{i,1}{j,2}(k,119);
        end
                
    end
end
%%
for i = 1 :sub.num
    for j = 1 : 3
    num1 = sum(time_decision{i,1}{j,4}(1:15,1));
    num2 = sum(time_decision{i,1}{j,6}(1:15,1));
    if  num1 < num2
     K1 = find(1.5 > time_decision{i,1}{j,3} );
    [b1,L3] = min(K1);
    
    elseif num1 > num2 
     K1 = find(1.5 > time_decision{i,1}{j,5});
    [b1,L3] = min(K1);
    end
    
    time_se1(2,j+(i-1)*3) = b1 + time_se(2,j+(i-1)*3)-1;
    end
end

for i = 1 : sub.num*3
    time_se2(1:4,i) = time_se1(:,i) - time_se1(1,i);
end

%% データの読み込み(グラフのプロット）
drive = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    drive{i,1}{j,1} = drive_org{i,1}{j,1}(time_se1(1,j+(i-1)*3):time_se1(4,j+(i-1)*3),3:1154)/1000;
    end
end

%% 重心のデータ
centerofmass = cell(sub.num,1);
 
for i = 1 : sub.num
    for j = 1 : 3
    centerofmass{i,1}{j,1} = drive{i,1}{j,1}(:,1:3);
    end
end

%% 足のデータ
foot = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    foot{i,1}{j,1} = drive{i,1}{j,1}(:,70:72);
    foot{i,1}{j,2} = drive{i,1}{j,1}(:,280:282);
    foot{i,1}{j,3} = (foot{i,1}{j,1} + foot{i,1}{j,2})/2;
    foot{i,1}{j,4} = foot{i,1}{j,2}(:,1:3) - foot{i,1}{j,1}(:,1:3);
    foot{i,1}{j,5} = foot{i,1}{j,2}(:,1:3) - foot{i,1}{j,2}(1,1:3);
       for k = 1 : length(foot{i,1}{j,4}) 
       foot{i,1}{j,6}(k,1) = atand(foot{i,1}{j,4}(k,2)/foot{i,1}{j,4}(k,1));
       end
       
       for k = 1 : length(foot{i,1}{j,5})
%            foot{i,1}{j,7}(k,1) = atand(foot{i,1}{j,5}(k,2)/foot{i,1}{j,5}(k,1));
           if norm(foot{i,1}{j,5}(k,:)) < 0.1
               foot{i,1}{j,7}(k,1) = 0;
           elseif norm(foot{i,1}{j,5}(k,:)) > 0.1
               foot{i,1}{j,7}(k,1) = atand(foot{i,1}{j,5}(k,2)/foot{i,1}{j,5}(k,1));
           end
       end
    end
end

%% 手のデータ
hand = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    hand{i,1}{j,1} = drive{i,1}{j,1}(:,85:87);
    hand{i,1}{j,2} = drive{i,1}{j,1}(:,295:297);
    hand{i,1}{j,3} = (hand{i,1}{j,1}+hand{i,1}{j,2})/2;
    hand{i,1}{j,4} = hand{i,1}{j,2}(:,1:3) - hand{i,1}{j,2}(1,1:3);
       for k = 1 : length(hand{i,1}{j,4})
       hand{i,1}{j,5}(k,1) = atand(hand{i,1}{j,4}(k,2)/hand{i,1}{j,4}(k,1));
       hand{i,1}{j,6}(k,1) = norm(hand{i,1}{j,4}(k,1:2));
       end
    end
end

%% 肩のデータ
shoulder = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
       shoulder{i,1}{j,1} = drive{i,1}{j,1}(:,154:156);
       shoulder{i,1}{j,2} = drive{i,1}{j,1}(:,364:366);
       shoulder{i,1}{j,3} = shoulder{i,1}{j,2}(:,1:3) - shoulder{i,1}{j,1}(:,1:3);
       for k = 1 : length(shoulder{i,1}{j,3})
       shoulder{i,1}{j,4}(k,1) = -atand(shoulder{i,1}{j,3}(k,2)/shoulder{i,1}{j,3}(k,1));
       shoulder{i,1}{j,4}(k,2) = shoulder{i,1}{j,4}(k,1) - min(shoulder{i,1}{j,4}(:,1));
       end
       shoulder{i,1}{j,5}(:,1:3) = shoulder{i,1}{j,1}(:,1:3)-shoulder{i,1}{j,1}(1,1:3);
       for k = 1 : length(shoulder{i,1}{j,5})
       shoulder{i,1}{j,6}(k,1) = atand(shoulder{i,1}{j,5}(k,2)/shoulder{i,1}{j,5}(k,1));
       end      
       shoulder{i,1}{j,7} = (shoulder{i,1}{j,1}+shoulder{i,1}{j,2})/2;
       shoulder{i,1}{j,8}(:,1:3) = shoulder{i,1}{j,2}(:,1:3)-shoulder{i,1}{j,2}(1,1:3);
       for k = 1 : length(shoulder{i,1}{j,8})
       shoulder{i,1}{j,9}(k,1) = atand(shoulder{i,1}{j,8}(k,2)/shoulder{i,1}{j,8}(k,1));
       end 
    end
end

%% 股関節の角度
hip = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
       hip{i,1}{j,1} = 180 - drive{i,1}{j,1}(:,103:105)*1000;
       hip{i,1}{j,2} = 180 - drive{i,1}{j,1}(:,313:315)*1000;
    end
end
%% 頭のデータ
head = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
       head{i,1}{j,1} = (drive_org{i,1}{j,2}(time_se1(1,j+3*(i-1)):time_se1(4,j+3*(i-1)),3:5) + drive_org{i,1}{j,2}(time_se1(1,j+3*(i-1)):time_se1(4,j+3*(i-1)),6:8))/2000;
    end
end
%% コーンの位置
cone = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
       cone{i,1}{j,1}(1,:) = [-0.40 -1.1450 0];
       cone{i,1}{j,1}(2,:) = [0.40 -1.1450 0];
    end
end

%% 距離のデータ
distance = cell(sub.num,1);
%%手と肩の関係
for i = 1 : sub.num 
    for j = 1 : 3
        distance_s_h_x = zeros(100,1);
        distance_s_h_y = zeros(100,1);
        distance_s_h_z = zeros(100,1);
        for k = 1 : time_se2(4,j+(i-1)*3)
            distance_s_h_x(k,1) = hand{i,1}{j,2}(k,1) - shoulder{i,1}{j,2}(k,1);
            distance_s_h_y(k,1) = hand{i,1}{j,2}(k,2) - shoulder{i,1}{j,2}(k,2);
            distance_s_h_z(k,1) = hand{i,1}{j,2}(k,3) - shoulder{i,1}{j,2}(k,3);
            distance{i,1}{j,1}(k,1) = sqrt(distance_s_h_x(k,1)^2 + distance_s_h_y(k,1)^2 + distance_s_h_z(k,1)^2);
            distance{i,1}{j,1}(k,2) = sqrt(distance_s_h_x(k,1)^2 + distance_s_h_y(k,1)^2);
            distance{i,1}{j,1}(k,3) = distance_s_h_x(k,1);
            distance{i,1}{j,1}(k,4) = distance_s_h_y(k,1);
            distance{i,1}{j,1}(k,5) = distance_s_h_z(k,1);
        end
    end     
end
%%手と重心の関係
for i = 1 : sub.num
    for j = 1 : 3
        distance_c_h_x = zeros(100,1);
        distance_c_h_y = zeros(100,1);
        distance_c_h_z = zeros(100,1);
        for k = 1 : time_se2(4,j+(i-1)*3)
            distance_c_h_x(k,1) = centerofmass{i,1}{j,1}(k,1) - hand{i,1}{j,1}(k,1);
            distance_c_h_y(k,1) = centerofmass{i,1}{j,1}(k,2) - hand{i,1}{j,1}(k,2);
            distance_c_h_z(k,1) = centerofmass{i,1}{j,1}(k,3) - hand{i,1}{j,1}(k,3);
            distance{i,1}{j,2}(k,1) = sqrt(distance_c_h_x(k,1)^2 + distance_c_h_y(k,1)^2 + distance_c_h_z(k,1)^2);
            distance{i,1}{j,2}(k,2) = sqrt(distance_c_h_x(k,1)^2 + distance_c_h_y(k,1)^2);
            distance{i,1}{j,2}(k,3) = distance_c_h_x(k,1);
            distance{i,1}{j,2}(k,4) = distance_c_h_y(k,1);
            distance{i,1}{j,2}(k,5) = distance_c_h_z(k,1);
        end
    end     
end
%%手の関係
for i = 1 : sub.num
    for j = 1 : 3
        distance_h_h_x = zeros(100,1);
        distance_h_h_y = zeros(100,1);
        distance_h_h_z = zeros(100,1);
        for k = 1 : time_se2(4,j+(i-1)*3)
            distance_h_h_x(k,1) = hand{i,1}{j,2}(k,1) - hand{i,1}{j,1}(k,1);
            distance_h_h_y(k,1) = hand{i,1}{j,2}(k,2) - hand{i,1}{j,1}(k,2);
            distance_h_h_z(k,1) = hand{i,1}{j,2}(k,3) - hand{i,1}{j,1}(k,3);
            distance{i,1}{j,3}(k,1) = sqrt(distance_h_h_x(k,1)^2 + distance_h_h_y(k,1)^2 + distance_h_h_z(k,1)^2);
            distance{i,1}{j,3}(k,2) = sqrt(distance_h_h_x(k,1)^2 + distance_h_h_z(k,1)^2);
            distance{i,1}{j,3}(k,3) = distance_h_h_x(k,1);
            distance{i,1}{j,3}(k,4) = distance_h_h_y(k,1);
            distance{i,1}{j,3}(k,5) = distance_h_h_z(k,1);
        end
    end     
end

for i = 1 : sub.num
    for j = 1 : 3
        distance_l_h_h_x = zeros(100,1);
        distance_l_h_h_y = zeros(100,1);
        distance_l_h_h_z = zeros(100,1);
        distance_r_h_h_x = zeros(100,1);
        distance_r_h_h_y = zeros(100,1);
        distance_r_h_h_z = zeros(100,1);        
        for k = 1 : time_se2(4,j+(i-1)*3)
            distance_l_h_h_x(k,1) = hand{i,1}{j,1}(k+1,1) - hand{i,1}{j,1}(k,1);
            distance_l_h_h_y(k,1) = hand{i,1}{j,1}(k+1,2) - hand{i,1}{j,1}(k,2);
            distance_l_h_h_z(k,1) = hand{i,1}{j,1}(k+1,3) - hand{i,1}{j,1}(k,3);
            distance_r_h_h_x(k,1) = hand{i,1}{j,2}(k+1,1) - hand{i,1}{j,2}(k,1);
            distance_r_h_h_y(k,1) = hand{i,1}{j,2}(k+1,2) - hand{i,1}{j,2}(k,2);
            distance_r_h_h_z(k,1) = hand{i,1}{j,2}(k+1,3) - hand{i,1}{j,2}(k,3);
            distance{i,1}{j,4}(k,1) = distance_l_h_h_x(k,1);
            distance{i,1}{j,4}(k,2) = distance_l_h_h_y(k,1);
            distance{i,1}{j,4}(k,3) = distance_l_h_h_z(k,1);            
            distance{i,1}{j,5}(k,1) = distance_r_h_h_x(k,1);
            distance{i,1}{j,5}(k,2) = distance_r_h_h_y(k,1);
            distance{i,1}{j,5}(k,3) = distance_r_h_h_z(k,1);
        end
    end     
end

%% 速度
speed = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
       speed{i,1}{j,1} = drive{i,1}{j,1}(:,505:507); %左足
       speed{i,1}{j,2} = drive{i,1}{j,1}(:,715:717); %右足
       speed{i,1}{j,3} = drive{i,1}{j,1}(:,436:438); %重心
       speed{i,1}{j,4} = drive{i,1}{j,1}(:,589:591); %左肩
       speed{i,1}{j,5} = drive{i,1}{j,1}(:,730:732); %右手
        for k = 1 : time_se2(4,j+(i-1)*3)
            speed{i,1}{j,1}(k,4) = sqrt(speed{i,1}{j,1}(k,1)^2 + speed{i,1}{j,1}(k,2)^2);
            speed{i,1}{j,1}(k,5) = sqrt(speed{i,1}{j,1}(k,1)^2 + speed{i,1}{j,1}(k,2)^2+speed{i,1}{j,1}(k,3)^2);
            speed{i,1}{j,2}(k,4) = sqrt(speed{i,1}{j,2}(k,1)^2 + speed{i,1}{j,2}(k,2)^2);
            
            speed{i,1}{j,3}(k,4) = sqrt(speed{i,1}{j,3}(k,1)^2 + speed{i,1}{j,3}(k,2)^2);
            speed{i,1}{j,3}(k,5) = sqrt(speed{i,1}{j,3}(k,1)^2 + speed{i,1}{j,3}(k,2)^2+speed{i,1}{j,3}(k,3)^2);
            speed{i,1}{j,4}(k,4) = sqrt(speed{i,1}{j,4}(k,1)^2 + speed{i,1}{j,4}(k,2)^2);
            speed{i,1}{j,4}(k,5) = sqrt(speed{i,1}{j,4}(k,1)^2 + speed{i,1}{j,4}(k,2)^2+speed{i,1}{j,4}(k,3)^2);    
            
            speed{i,1}{j,5}(k,4) = sqrt(speed{i,1}{j,5}(k,1)^2 + speed{i,1}{j,5}(k,2)^2);
            speed{i,1}{j,5}(k,5) = sqrt(speed{i,1}{j,5}(k,1)^2 + speed{i,1}{j,5}(k,2)^2+speed{i,1}{j,5}(k,3)^2);
        end
    end
end
%% 加速度
accelration = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3 
       accelration{i,1}{j,1} = drive{i,1}{j,1}(:,940:942);
       accelration{i,1}{j,2} = drive{i,1}{j,1}(:,1150:1152);
       accelration{i,1}{j,3} = drive{i,1}{j,1}(:,871:873);
        for k = 1 : time_se2(4,j+(i-1)*3)
            accelration{i,1}{j,1}(k,4) = sqrt(accelration{i,1}{j,1}(k,1)^2 + accelration{i,1}{j,1}(k,2)^2);
            accelration{i,1}{j,1}(k,5) = sqrt(accelration{i,1}{j,1}(k,1)^2 + accelration{i,1}{j,1}(k,2)^2+accelration{i,1}{j,1}(k,3)^2);
            accelration{i,1}{j,3}(k,4) = sqrt(accelration{i,1}{j,3}(k,1)^2 + accelration{i,1}{j,3}(k,2)^2);
            accelration{i,1}{j,3}(k,5) = sqrt(accelration{i,1}{j,3}(k,1)^2 + accelration{i,1}{j,3}(k,2)^2+accelration{i,1}{j,3}(k,3)^2); 
        end
    end
end


%% ドリブルの瞬間の指定
%開始
time_dribble = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    for m = 1 : time_se2(4,j+(i-1)*3)
       time_dribble{i,1}{j,1}(m-time_se2(1,j+(i-1)*3)+1,1) = distance{i,1}{j,3}(m,1)-distance{i,1}{j,3}(1,1);
    end
    L1 = find(0.06 < time_dribble{i,1}{j,1});
    [a1,R1] = min(L1);
    L2 = find(0 > distance{i,1}{j,4}(:,1) & 0.1 < hand{i,1}{j,2}(1:time_se2(4,j+(i-1)*3),1));
    [a2,R2] = min(L2);
    L3 = find(-0.0036 > distance{i,1}{j,5}(5:time_se2(4,j+(i-1)*3),3) & 0 > distance{i,1}{j,2}(5:time_se2(4,j+(i-1)*3),3));
    [a3,R3] = min(L3);
    a3 = 4 + a3;
    A = [a1 a2 a3];
    time_se2(5,j+(i-1)*3) = min(A) + time_se2(1,j+(i-1)*3)-1;
    end
end

%%終わり
for i = 1 : sub.num
    for j = 1 : 3
    [a4,R4] = min(distance{i,1}{j,1}(time_se2(5,j+(i-1)*3):time_se2(4,j+(i-1)*3),5));
    
    time_se2(6,j+(i-1)*3) = R4 + time_se2(5,j+(i-1)*3)-1;
    end
end

%%コーンの横を通った時間
for i = 1 : sub.num
    for j = 1 : 3
     L4 = find(-1.1450 < foot{i,1}{j,1}(:,2));
    [a5,R5] = min(L4);
    
    time_se2(7,j+(i-1)*3) = a5 + time_se2(1,j+(i-1)*3)-1;
    end
end

%% IMUとの同期
imu = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
    fname           = sprintf('imu_result%s%d%ctrial_%d','\sub.',i,'\',j);
    folder          = dir(fname);
    folder_vicon1    = folder(3,1).name;
    folder_vicon2    = folder(4,1).name;
    folder_vicon3    = folder(5,1).name;
    folder_vicon4    = folder(6,1).name;
    folder_vicon5    = folder(7,1).name;
    folder_vicon6    = folder(8,1).name;
    folder_vicon7    = folder(9,1).name;

    fname_vicon1     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon1);
    fname_vicon2     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon2);
    fname_vicon3     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon3);
    fname_vicon4     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon4);
    fname_vicon5     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon5);
    fname_vicon6     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon6);
    fname_vicon7     = sprintf('imu_result%s%d%ctrial_%d%c%s','\sub.',i,'\',j,'\',folder_vicon7);
    
    data1 = csvread(fname_vicon1,1,1);
    data2 = csvread(fname_vicon2,1,1);
    data3 = csvread(fname_vicon3,1,1);
    data4 = csvread(fname_vicon4,1,1);
    data5 = csvread(fname_vicon5,1,1);
    data6 = csvread(fname_vicon6,1,1);
    data7 = csvread(fname_vicon7,1,1);
    
    imu{i,1}{j,1}{1,1}   = data1;
    imu{i,1}{j,1}{2,1}   = data2;
    imu{i,1}{j,1}{3,1}   = data3;
    imu{i,1}{j,1}{4,1}   = data4;
    imu{i,1}{j,1}{5,1}   = data5;
    imu{i,1}{j,1}{6,1}   = data6;
    imu{i,1}{j,1}{7,1}   = data7;

    end
end
%% IMUの同期

start_time_imu = zeros(4,sub.num*3);
imu_time = zeros(4,sub.num*3);

for i = 1 : sub.num
    for j = 1 : 3
    I1 = find(3 < drive_org{i,1}{j,3}(:,3));
    [st1,en1] = min(I1);
    start_time_imu(1,j+(i-1)*3) = drive_org{i,1}{j,3}(st1,1);
    I2 = find(28000 < imu{i,1}{j,1}{7,1}(:,2));
    [st2,en2] = min(I2);
    start_time_imu(2,j+(i-1)*3) = imu{i,1}{j,1}{7,1}(st2,1);
    imu_time(1,j+(i-1)*3) = start_time_imu(2,j+(i-1)*3)+(time_se1(1,j+(i-1)*3)-start_time_imu(1,j+(i-1)*3))*10;
    imu_time(2,j+(i-1)*3) = start_time_imu(2,j+(i-1)*3)+(time_se1(2,j+(i-1)*3)-start_time_imu(1,j+(i-1)*3))*10;
    imu_time(3,j+(i-1)*3) = start_time_imu(2,j+(i-1)*3)+(time_se1(3,j+(i-1)*3)-start_time_imu(1,j+(i-1)*3))*10;
    imu_time(4,j+(i-1)*3) = start_time_imu(2,j+(i-1)*3)+(time_se1(4,j+(i-1)*3)-start_time_imu(1,j+(i-1)*3))*10;
    end
end

for i = 1 : sub.num*3
    imu_time(5:8,i) = imu_time(1:4,i) - imu_time(1,i)+1;
end
    
%% IMUのデータの読み込み
imu_time2 = zeros(4,sub.num*3);
for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : 6
            time1 = find(imu_time(1,j+(i-1)*3)+1 > imu{i,1}{j,1}{k,1}(:,1));
            time2 = find(imu_time(2,j+(i-1)*3)-1 < imu{i,1}{j,1}{k,1}(:,1));
            time3 = find(imu_time(3,j+(i-1)*3)+1 < imu{i,1}{j,1}{k,1}(:,1));
            time4 = find(imu_time(4,j+(i-1)*3)-1 < imu{i,1}{j,1}{k,1}(:,1));
            [start1,a] = max(time1);
            [start2,b] = min(time2);
            [start3,c] = min(time3);
            [start4,d] = min(time4);
            imu_time2(1,j+(i-1)*3) = start1;
            imu_time2(2,j+(i-1)*3) = start2;
            imu_time2(3,j+(i-1)*3) = start3;
            imu_time2(4,j+(i-1)*3) = start4;
            imu{i,1}{j,1}{k,1} = imu{i,1}{j,1}{k,1}(imu_time2(1,j+(i-1)*3):imu_time2(4,j+(i-1)*3),:);
        end      
    end
end
    
%% データの整理

for i = 1 : sub.num
    for j = 1 : 3
        for l = 1 : 6
            for k = 1 : length(imu{i,1}{j,1}{l,1}(:,1))
                imu{i,1}{j,1}{l,1}(k,2:7) = imu{i,1}{j,1}{l,1}(k,2:7)*9.8/10000;
                imu{i,1}{j,1}{l,1}(length(imu{i,1}{j,1}{l,1}(:,1))-k+1,1) = imu{i,1}{j,1}{l,1}(length(imu{i,1}{j,1}{l,1}(:,1))-k+1,1) - imu{i,1}{j,1}{l,1}(1,1)+1;
            end
        end
    end
end

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{1,1}(:,1))
            imu{i,1}{j,1}{1,1}(k,4) = imu{i,1}{j,1}{1,1}(k,4)-9.8;
        end
    end
end

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{2,1}(:,1))
            imu{i,1}{j,1}{2,1}(k,2) = imu{i,1}{j,1}{2,1}(k,2)-9.8;
        end
    end
end

%% 加速度の計算
for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{1,1})
            imu{i,1}{j,1}{1,1}(k,8) = sqrt(imu{i,1}{j,1}{1,1}(k,2)^2+imu{i,1}{j,1}{1,1}(k,3)^2+imu{i,1}{j,1}{1,1}(k,4)^2);
        end
    end
end

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{1,1})
            imu{i,1}{j,1}{1,1}(k,9) = sqrt(imu{i,1}{j,1}{1,1}(k,2)^2+imu{i,1}{j,1}{1,1}(k,3)^2);
        end
    end
end

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{2,1})
            imu{i,1}{j,1}{2,1}(k,8) = sqrt(imu{i,1}{j,1}{2,1}(k,2)^2+imu{i,1}{j,1}{2,1}(k,3)^2+imu{i,1}{j,1}{2,1}(k,4)^2);
        end
    end
end

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(imu{i,1}{j,1}{2,1})
            imu{i,1}{j,1}{2,1}(k,9) = sqrt(imu{i,1}{j,1}{2,1}(k,2)^2+imu{i,1}{j,1}{2,1}(k,3)^2+imu{i,1}{j,1}{2,1}(k,4)^2);
        end
    end
end

%% データの格納
redata = cell(sub.num,1);

for i = 1 : sub.num
    for j = 1 : 3
        for k = 1 : length(foot{i,1}{j,4})
            redata{i,1}{j,1}(k,1) = dot(foot{i,1}{j,4}(k,1:2),shoulder{i,1}{j,5}(k,1:2));
            redata{i,1}{j,1}(k,2) = norm(foot{i,1}{j,4}(k,1:2));
            redata{i,1}{j,1}(k,3) = norm(shoulder{i,1}{j,5}(k,1:2));
            redata{i,1}{j,1}(k,4) = acosd(redata{i,1}{j,1}(k,1)/(redata{i,1}{j,1}(k,2)*redata{i,1}{j,1}(k,3)));
        end
        for k = 1 : length(foot{i,1}{j,5})
            redata{i,1}{j,2}(k,1) = dot(foot{i,1}{j,5}(k,1:2),shoulder{i,1}{j,5}(k,1:2));
            redata{i,1}{j,2}(k,2) = norm(foot{i,1}{j,5}(k,1:2));
            redata{i,1}{j,2}(k,3) = norm(shoulder{i,1}{j,8}(k,1:2));
            redata{i,1}{j,2}(k,4) = acosd(redata{i,1}{j,2}(k,1)/(redata{i,1}{j,2}(k,2)*redata{i,1}{j,2}(k,3)));            
        end
    end
end

%%
drive_tanaka   = cell(8,1);
drive_nakaoka  = cell(8,1);
drive_eguchi   = cell(8,1); 
drive_akada    = cell(8,1);
drive_yosihara = cell(8,1);
drive_matuo    = cell(8,1); 
drive_horita   = cell(8,1);
drive_ko       = cell(8,1);
drive_fukui    = cell(8,1);
drive_kisibata = cell(8,1);
drive_koyuji   = cell(8,1); 
drive_sirai    = cell(8,1);
drive_ogi      = cell(8,1);
drive_sakaki   = cell(8,1);
drive_koide    = cell(8,1);

drive_all      = cell(sub.num+1,1);

for i = 1 : sub.num
    if i == 1
    drive_nakaoka{1,1} = centerofmass{i,1};
    drive_nakaoka{2,1} = foot{i,1};
    drive_nakaoka{3,1} = hand{i,1};
    drive_nakaoka{4,1} = shoulder{i,1};
    drive_nakaoka{5,1} = hip{i,1};
    drive_nakaoka{6,1} = head{i,1};
    drive_nakaoka{7,1} = distance{i,1};
    drive_nakaoka{8,1} = speed{i,1};
    drive_nakaoka{9,1} = accelration{i,1};
    drive_nakaoka{10,1} = imu{i,1};
    drive_nakaoka{11,1} = redata{i,1};
    drive_all{i,1} = drive_nakaoka;
    elseif i == 2
    drive_eguchi{1,1} = centerofmass{i,1};
    drive_eguchi{2,1} = foot{i,1};
    drive_eguchi{3,1} = hand{i,1};
    drive_eguchi{4,1} = shoulder{i,1};
    drive_eguchi{5,1} = hip{i,1};
    drive_eguchi{6,1} = head{i,1};
    drive_eguchi{7,1} = distance{i,1};
    drive_eguchi{8,1} = speed{i,1};
    drive_eguchi{9,1} = accelration{i,1};
    drive_eguchi{10,1} = imu{i,1};
    drive_eguchi{11,1} = redata{i,1};
    drive_all{i,1} = drive_eguchi;
    elseif i == 3
    drive_yosihara{1,1} = centerofmass{i,1};
    drive_yosihara{2,1} = foot{i,1};
    drive_yosihara{3,1} = hand{i,1};
    drive_yosihara{4,1} = shoulder{i,1};
    drive_yosihara{5,1} = hip{i,1};
    drive_yosihara{6,1} = head{i,1};
    drive_yosihara{7,1} = distance{i,1};
    drive_yosihara{8,1} = speed{i,1};
    drive_yosihara{9,1} = accelration{i,1};
    drive_yosihara{10,1} = imu{i,1};
    drive_yosihara{11,1} = redata{i,1};
    drive_all{i,1} = drive_yosihara;
    elseif i == 4
    drive_kisibata{1,1} = centerofmass{i,1};
    drive_kisibata{2,1} = foot{i,1};
    drive_kisibata{3,1} = hand{i,1};
    drive_kisibata{4,1} = shoulder{i,1};
    drive_kisibata{5,1} = hip{i,1};
    drive_kisibata{6,1} = head{i,1};
    drive_kisibata{7,1} = distance{i,1};
    drive_kisibata{8,1} = speed{i,1};
    drive_kisibata{9,1} = accelration{i,1};
    drive_kisibata{10,1} = imu{i,1};
    drive_kisibata{11,1} = redata{i,1};
    drive_all{i,1} = drive_kisibata;
    elseif i == 5
    drive_koide{1,1} = centerofmass{i,1};
    drive_koide{2,1} = foot{i,1};
    drive_koide{3,1} = hand{i,1};
    drive_koide{4,1} = shoulder{i,1};
    drive_koide{5,1} = hip{i,1};
    drive_koide{6,1} = head{i,1};
    drive_koide{7,1} = distance{i,1};
    drive_koide{8,1} = speed{i,1};
    drive_koide{9,1} = accelration{i,1};
    drive_koide{10,1} = imu{i,1};
    drive_koide{11,1} = redata{i,1};
    drive_all{i,1} = drive_koide;
    elseif i == 6
    drive_fukui{1,1} = centerofmass{i,1};
    drive_fukui{2,1} = foot{i,1};
    drive_fukui{3,1} = hand{i,1};
    drive_fukui{4,1} = shoulder{i,1};
    drive_fukui{5,1} = hip{i,1};
    drive_fukui{6,1} = head{i,1};
    drive_fukui{7,1} = distance{i,1};
    drive_fukui{8,1} = speed{i,1};
    drive_fukui{9,1} = accelration{i,1};
    drive_fukui{10,1} = imu{i,1};
    drive_fukui{11,1} = redata{i,1};
    drive_all{i,1} = drive_fukui;
    elseif i == 7
    drive_ogi{1,1} = centerofmass{i,1};
    drive_ogi{2,1} = foot{i,1};
    drive_ogi{3,1} = hand{i,1};
    drive_ogi{4,1} = shoulder{i,1};
    drive_ogi{5,1} = hip{i,1};
    drive_ogi{6,1} = head{i,1};
    drive_ogi{7,1} = distance{i,1};
    drive_ogi{8,1} = speed{i,1};
    drive_ogi{9,1} = accelration{i,1};
    drive_ogi{10,1} = imu{i,1};
    drive_ogi{11,1} = redata{i,1};
    drive_all{i,1} = drive_ogi;    
    elseif i == 8
    drive_sakaki{1,1} = centerofmass{i,1};
    drive_sakaki{2,1} = foot{i,1};
    drive_sakaki{3,1} = hand{i,1};
    drive_sakaki{4,1} = shoulder{i,1};
    drive_sakaki{5,1} = hip{i,1};
    drive_sakaki{6,1} = head{i,1};
    drive_sakaki{7,1} = distance{i,1};
    drive_sakaki{8,1} = speed{i,1};
    drive_sakaki{9,1} = accelration{i,1};
    drive_sakaki{10,1} = imu{i,1};
    drive_sakaki{11,1} = redata{i,1};
    drive_all{i,1} = drive_sakaki;
    elseif i == 9
    drive_sirai{1,1} = centerofmass{i,1};
    drive_sirai{2,1} = foot{i,1};
    drive_sirai{3,1} = hand{i,1};
    drive_sirai{4,1} = shoulder{i,1};
    drive_sirai{5,1} = hip{i,1};
    drive_sirai{6,1} = head{i,1};
    drive_sirai{7,1} = distance{i,1};
    drive_sirai{8,1} = speed{i,1};
    drive_sirai{9,1} = accelration{i,1};
    drive_sirai{10,1} = imu{i,1};
    drive_sirai{11,1} = redata{i,1};
    drive_all{i,1} = drive_sirai;
    elseif i == 10
    drive_horita{1,1} = centerofmass{i,1};
    drive_horita{2,1} = foot{i,1};
    drive_horita{3,1} = hand{i,1};
    drive_horita{4,1} = shoulder{i,1};
    drive_horita{5,1} = hip{i,1};
    drive_horita{6,1} = head{i,1};
    drive_horita{7,1} = distance{i,1};
    drive_horita{8,1} = speed{i,1};
    drive_horita{9,1} = accelration{i,1};
    drive_horita{10,1} = imu{i,1};
    drive_horita{11,1} = redata{i,1};
    drive_all{i,1} = drive_horita;
    elseif i == 11
    drive_koyuji{1,1} = centerofmass{i,1};
    drive_koyuji{2,1} = foot{i,1};
    drive_koyuji{3,1} = hand{i,1};
    drive_koyuji{4,1} = shoulder{i,1};
    drive_koyuji{5,1} = hip{i,1};
    drive_koyuji{6,1} = head{i,1};
    drive_koyuji{7,1} = distance{i,1};
    drive_koyuji{8,1} = speed{i,1};
    drive_koyuji{9,1} = accelration{i,1};
    drive_koyuji{10,1} = imu{i,1};
    drive_koyuji{11,1} = redata{i,1};
    drive_all{i,1} = drive_koyuji;
    elseif i == 12
    drive_tanaka{1,1} = centerofmass{i,1};
    drive_tanaka{2,1} = foot{i,1};
    drive_tanaka{3,1} = hand{i,1};
    drive_tanaka{4,1} = shoulder{i,1};
    drive_tanaka{5,1} = hip{i,1};
    drive_tanaka{6,1} = head{i,1};
    drive_tanaka{7,1} = distance{i,1};
    drive_tanaka{8,1} = speed{i,1};
    drive_tanaka{9,1} = accelration{i,1};
    drive_tanaka{10,1} = imu{i,1};
    drive_tanaka{11,1} = redata{i,1};
    drive_all{i,1} = drive_tanaka;
    elseif i == 13
    drive_akada{1,1} = centerofmass{i,1};
    drive_akada{2,1} = foot{i,1};
    drive_akada{3,1} = hand{i,1};
    drive_akada{4,1} = shoulder{i,1};
    drive_akada{5,1} = hip{i,1};
    drive_akada{6,1} = head{i,1};
    drive_akada{7,1} = distance{i,1};
    drive_akada{8,1} = speed{i,1};
    drive_akada{9,1} = accelration{i,1};
    drive_akada{10,1} = imu{i,1};
    drive_akada{11,1} = redata{i,1};
    drive_all{i,1} = drive_akada;
    elseif i == 14
    drive_ko{1,1} = centerofmass{i,1};
    drive_ko{2,1} = foot{i,1};
    drive_ko{3,1} = hand{i,1};
    drive_ko{4,1} = shoulder{i,1};
    drive_ko{5,1} = hip{i,1};
    drive_ko{6,1} = head{i,1};
    drive_ko{7,1} = distance{i,1};
    drive_ko{8,1} = speed{i,1};
    drive_ko{9,1} = accelration{i,1};
    drive_ko{10,1} = imu{i,1};
    drive_ko{11,1} = redata{i,1};
    drive_all{i,1} = drive_ko;
    elseif i == 15
    drive_matuo{1,1} = centerofmass{i,1};
    drive_matuo{2,1} = foot{i,1};
    drive_matuo{3,1} = hand{i,1};
    drive_matuo{4,1} = shoulder{i,1};
    drive_matuo{5,1} = hip{i,1};
    drive_matuo{6,1} = head{i,1};
    drive_matuo{7,1} = distance{i,1};
    drive_matuo{8,1} = speed{i,1};
    drive_matuo{9,1} = accelration{i,1};
    drive_matuo{10,1} = imu{i,1};
    drive_matuo{11,1} = redata{i,1};
    drive_all{i,1} = drive_matuo;       
    end 
    drive_all{sub.num+1,1} = cone;
end

%% 最終的なデータの保存
save drive_all  
