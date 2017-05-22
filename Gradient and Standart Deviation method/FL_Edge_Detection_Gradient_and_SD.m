clc
clear all
close all

% reads an image and converts it into gray scale and double presicion
I = imread('peppers.png'); 
Igray = rgb2gray(I);
Idouble = im2double(Igray);
[m, n] = size(Idouble);
%% First step:
% Gradient of an image and mapping into 0 to 100

[Gx,Gy] = imgradientxy(Idouble,'Sobel'); % directional gradient of the image
% Calculate the gradient magnitude and direction using the directional gradients
[Gmag, Gdir] = imgradient(Gx, Gy);
%%%
% mapping Gmag into the 0 to 100
Gmag = Gmag - min(Gmag(:));
Gmag = Gmag ./ max(Gmag(:));
Gmag = 100*Gmag;
%%%
figure
subplot(121);imshow(Gmag,[])
%% Second step:
% SD of each pixel and mapping into 0 to 100
SD = stdfilt(Igray);
% Brighter pixels in the filtered image correspond to neighborhoods in the 
% original image with larger standard deviations.
%%%
% mapping Isd into the 0 to 100
SD = SD - min(SD(:));
SD = SD ./ max(SD(:));
SD = 100*SD;
%%%
subplot(122); imshow(SD,[])
%% Third step
% Create a fuzzy inference system (FIS)using two inputs
% There will two inputs and each of them will have three fuzzy sets that
% describe the edginess

fis = newfis('EdgeDetection');
% interval mapping
% First Input
% Specify the image magnitude of the gradient
fis = addvar(fis,'input','Gmag',[0 100]);
fis = addmf(fis,'input',1,'low','trapmf',[0 0 20 40]);
fis = addmf(fis,'input',1,'medium','trapmf',[20 40 60 80]);
fis = addmf(fis,'input',1,'high','trapmf',[60 80 100 100]);

figure
grid on
subplot(221);plotmf(fis,'input',1)
title('using gradient magnitude to create first input variable')
% Standart Deviation of each pixel
fis = addvar(fis,'input','SD',[0 100]);
fis = addmf(fis,'input',2,'low','trapmf',[0 0 20 40]);
fis = addmf(fis,'input',2,'medium','trapmf',[20 40 60 80]);
fis = addmf(fis,'input',2,'high','trapmf',[60 80 100 100]);
subplot(222);plotmf(fis,'input',2)
title('using Standart Deviatione to create second input variable')
% output of the FIS
fis = addvar(fis,'output','edginess',[0 1]);
fis = addmf(fis,'output',1,'black','trapmf',[0 0 .25 .5]);
fis = addmf(fis,'output',1,'gray','trimf',[.25 .5 .75]);
fis = addmf(fis,'output',1,'white','trapmf',[.5 .75 1 1]);
subplot(2, 2, [3 4]);plotmf(fis,'output',1)

%% Fourth step:
% Specify and apply rules to the system
rules = [1 1 1 1 1; % L L -> L  
         1 2 1 1 1; % L M -> L
         1 3 2 1 1; % L H -> M
         2 1 1 1 1; % M L -> L
         2 2 3 1 1; % M M -> M
         2 3 3 1 1; % M H -> H
         3 1 2 1 1; % H L -> M  
         3 2 3 1 1; % H M -> H
         3 3 3 1 1];% L H -> H

fis = addrule(fis, rules);
% Evaluate the output of the edge detector for each row of pixels in I using 
% corresponding rows of Gmag and SD as inputs.
Ieval = zeros(m, n);
% for i = 1:m
%     for j = 1:n
%         Ieval(i,j) = evalfis([(Gmag(i,j)) (SD(i,j))],fis);
%     end
% end
    for i = 1:m
         Ieval(i,:) = evalfis([(Gmag(i,:)); (SD(i,:));]',fis);
    end   

figure 
Ithre = Ieval > 0.20; 
imshow(Ithre,[])