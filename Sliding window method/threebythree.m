%%%%%%
% Below code is mostly generated from: 
% Abdallah A. Alshennawy, and Ayman A. Aly, 
% “Edge Detection in Digital Images Using Fuzzy Logic Technique”,
% World Academy of Science, Engineering and Technology 53 2009, 
%%%%%%
clc
clear all
close all

%%% 
% reads colored image
I = imread('test.ppm');
% I = imread('lena512.png');
% converts gray scale level
Igray = rgb2gray(I);
[m, n] = size(Igray); % size of the image
% converts uint8 to double presicion to make operation on pixel values
Idouble=double(Igray);
% to create zeros matrix in the size of resized image
Iout = zeros(m, n);
%%%

% Mamdani FIS will be used to make decision on set edge or background
fis = newfis('3x3window');
% 3x3 sliding window has 9 pixel elemets
% first input
fis = addvar(fis, 'input', 'p1', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 1, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 1, 'white', 'trapmf', [80 180 255 255]);
% second input
fis = addvar(fis, 'input', 'p2', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 2, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 2, 'white', 'trapmf', [80 180 255 255]);
% third input
fis = addvar(fis, 'input', 'p3', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 3, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 3, 'white', 'trapmf', [80 180 255 255]);
% fourth input
fis = addvar(fis, 'input', 'p4', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 4, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 4, 'white', 'trapmf', [80 180 255 255]);
% fifth input
fis = addvar(fis, 'input', 'p5', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 5, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 5, 'white', 'trapmf', [80 180 255 255]);
% sixth input
fis = addvar(fis, 'input', 'p6', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 6, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 6, 'white', 'trapmf', [80 180 255 255]);
% seventh input
fis = addvar(fis, 'input', 'p7', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 7, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 7, 'white', 'trapmf', [80 180 255 255]);
% eight input
fis = addvar(fis, 'input', 'p8', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 8, 'black', 'trapmf', [0 0 60 90]);
fis = addmf(fis, 'input', 8, 'white', 'trapmf', [80 180 255 255]);
% ninth input
fis = addvar(fis, 'input', 'p9', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 9, 'black', 'trapmf', [0 0 60 80]);
fis = addmf(fis, 'input', 9, 'white', 'trapmf', [80 180 255 255]);
% output
fis = addvar(fis, 'output', 'pout', [0 255]); % for gray level 0 to 1
fis = addmf(fis, 'output', 1, 'black', 'trapmf', [0 0 5 7]);
fis = addmf(fis, 'output', 1, 'edge', 'trapmf', [123 125 135 137]);
fis = addmf(fis, 'output', 1, 'white', 'trapmf', [248 250 255 255]);
% shows input output reliations of the system
figure
subplot(431);plotmf(fis,'input',1)
subplot(432);plotmf(fis,'input',2)
subplot(433);plotmf(fis,'input',3)
subplot(434);plotmf(fis,'input',4)
subplot(435);plotmf(fis,'input',5)
subplot(436);plotmf(fis,'input',6)
subplot(437);plotmf(fis,'input',7)
subplot(438);plotmf(fis,'input',8)
subplot(439);plotmf(fis,'input',9)
subplot(4,3,[10:12]);plotmf(fis,'output',1)
%%%
% Rules:

% The firstfour rules are dealing with the vertical and horizontal direction
% lines gray level values around the checked or centered pixel of
% the mask, if the grays represented in one line are black and the
% remains grays are white then the checked pixel is edge 
rules1 = [2 2 2 2 2 2 1 1 1 2 1 1; % W W W W W W B B B -> E
          1 1 1 2 2 2 2 2 2 2 1 1; % B B B W W W W W W -> E  
          1 2 2 1 2 2 1 2 2 2 1 1; % B W W B W W B W W -> E 
          2 2 1 2 2 1 2 2 1 2 1 1]; % W W B W W B W W B -> E
%  The second four rules are dealing with the eight neighbors
% also depending on the values of the gray level weights, if the
% weights of the four sequential pixels are degree of blacks and
% the weights of the remain fours neighbors are the degree of
% whites, then the center pixel represents the edge
rules2 = [1 1 2 1 2 2 1 2 2 2 1 1; % B B W B W W B W W -> E 
          2 2 1 2 2 1 2 1 1 2 1 1; % B B B W W W W W W -> E  
          1 2 2 1 2 2 1 1 2 2 1 1; % B W W B W W B B W -> E 
          2 1 1 2 2 1 2 2 1 2 1 1]; % W B B W W B W W B -> E

rules=[rules1;rules2];
fis = addrule(fis, rules);
% % optional
% % rules of the system
% showrule(fis) 
% figure
% plotfis(fis)
% %  Open Rule Viewer
% ruleview(fis)
% %  Open Surface Viewer
% surfview(fis) 
Iout = zeros(size(m-2,n-2));
for i=2:m-1;
    for j=2:n-1;
        sub_window=Idouble(i-1:i+1,j-1:j+1);
        p1=sub_window(1,1);
        p2=sub_window(1,2);
        p3=sub_window(1,3);
        p4=sub_window(2,1);
        p5=sub_window(2,2);
        p6=sub_window(2,3);
        p7=sub_window(3,1);
        p8=sub_window(3,2);
        p9=sub_window(3,3);
        Iout(i-1,j-1)=evalfis([p1 p2 p3 p4 p5 p6 p7 p8 p9],fis); 
    end
end
figure
imshow(Iout,[])