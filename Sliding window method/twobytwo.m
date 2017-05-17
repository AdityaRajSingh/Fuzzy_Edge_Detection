clc
clear all
close all
% reads colored image
I = imread('lena512.png');
% converts gray scale level
Igray = rgb2gray(I);
[m, n] = size(Igray); % size of the image
% converts uint8 to double presicion to make operation on pixel values
Idouble=double(Igray);
% to create zeros matrix in the size of resized image
Iout = zeros(size(Idouble));

% Mamdani FIS will be used to make decision on set edge or background
fis = newfis('2x2window');
% 2x2 sliding window has 4 pixel elemets
% first input
fis = addvar(fis, 'input', 'p1', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 1, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 1, 'white', 'trimf', [0 255 255]);
% second input
fis = addvar(fis, 'input', 'p2', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 2, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 2, 'white', 'trimf', [0 255 255]);
% third input
fis = addvar(fis, 'input', 'p3', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 3, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 3, 'white', 'trimf', [0 255 255]);
% fourth input
fis = addvar(fis, 'input', 'p4', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 4, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 4, 'white', 'trimf', [0 255 255]);
% output
fis = addvar(fis, 'output', 'pout', [0 255]); % for gray level 0 to 1
fis = addmf(fis, 'output', 1, 'black', 'trimf', [0 0 70]);
fis = addmf(fis, 'output', 1, 'edge', 'trimf', [90 130 170]);
fis = addmf(fis, 'output', 1, 'white', 'trimf', [200 255 255]);
% shows input output reliations of the system
figure
subplot(321);plotmf(fis,'input',1)
subplot(322);plotmf(fis,'input',2)
subplot(323);plotmf(fis,'input',3)
subplot(324);plotmf(fis,'input',4)
subplot(3,2,[5 6]);plotmf(fis,'output',1)
% if there is 3B and 1W in the window or vice versa, set the output as edge
% 3B(3W) and 1W(1B) set the output as E
% if there is 2W and 2B in the window, set the output as edge
rules = [1 1 1 1 1 1 1; % B B B B -> B 
         1 1 1 2 2 1 1; % B B B W -> E 
         1 1 2 1 2 1 1; % B B W B -> E
         1 1 2 2 2 1 1; % B B W W -> E 
         1 2 1 1 2 1 1; % B W B B -> E 
         1 2 1 2 2 1 1; % B W B W -> E 
         1 2 2 1 2 1 1; % B W W B -> E 
         1 2 2 2 3 1 1; % B W W W -> W 
         2 1 1 1 1 1 1; % W B B B -> E 
         2 1 1 2 2 1 1; % W B B W -> E 
         2 1 2 1 2 1 1; % W B W B -> E
         2 1 2 2 2 1 1; % W B W W -> E 
         2 2 1 1 2 1 1; % W W B B -> E 
         2 2 1 2 2 1 1; % W W B W -> E 
         2 2 2 1 2 1 1; % W W W B -> E 
         2 2 2 2 3 1 1];% W W W W -> W 
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
Iout = zeros(m-1,n-1);
for i=1: m-1
     for j=1: n-1
         sub_window=Idouble(i:i+1,j:j+1);
         p1=sub_window(1,1);
         p2=sub_window(1,2);
         p3=sub_window(2,1);
         p4=sub_window(2,2);
         Iout(i,j) = evalfis([p1 p2 p3 p4],fis);
     end
end
% First derivative of the image
[Gmag, Gdir] = imgradient(Iout);
Gmag = 255*(Gmag/max(Gmag(:))); % scaling between 0 to 255
thresh = 30; % threshold value for output of the 'evalfis'
% threshold value can be changed for the best reult
figure 
subplot(121);imshow(I)
title('Input image')
subplot(122);imshow(Gmag<thresh) % if Gmag's every pixel value is less than 30 set 1
title(strcat('Fuzzy edge detection with',num2str(thresh),' threshold value'))
