% authors: Mahdiyeh Alimohammadi, Javad Pourdeilami and Ali A. Pouyan
% paper name: 'Edge Detection Using Fuzzy Inference Rules and First Order Derivation'
% 2013 13th Iranian Conference on Fuzzy Systems (IFSC)

%%% usefel description about proposed work
% -> Six inputs and eleven rules
% -> Inputs are fuzzified using triangular and trapezoidal MFs because of performance
clc
clear 
close all

current_dir = pwd;
test_folder = sprintf('%s%s', current_dir, '\BSR\BSDS500\data');
img_folder = sprintf('%s%s', test_folder, '\images\test');
groundTruth_folder = sprintf('%s%s', test_folder, '\groundTruth\test');

% read an image
I_test = imread(sprintf('%s%s', img_folder, '\2018.jpg'));
I_groundTruth = load(sprintf('%s%s', groundTruth_folder, '\2018.mat'));
% if image is colored then convert grayscale 
figure 
subplot(121); imshow (I_test); title('Test image');
subplot(122); imshow (I_groundTruth.groundTruth{1}.Boundaries); title('groundTruth image');
if size(I_test,3)==3
    I_test = rgb2gray(I_test);
end
%     I is grayscale
% double presicion
I_double = double(I_test);
% apply different edge detection method
I_prewitt = edge(I_double,'Prewitt',18);
I_canny= edge(I_double,'Canny',0.1);
I_sobel= edge(I_double,'Sobel',18);
figure
subplot(131);  imshow(I_prewitt); title('Prewitt method');
subplot(132); imshow(I_sobel); title('Sobel method');
subplot(133); imshow(I_canny); title('Canny method');

% first order derivatives of the image in a 2x2 window
% there will 6 directions to get from 2x2 window and that will be used as
% inputs of the system.
% new fis is created
fis = newfis('FISandFirstOrder');
% MFs of the input variables

fis = addvar(fis,'input','D1',[0, 255]);
fis = addmf(fis,'input',1,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',1,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',1,'white','trapmf',[40 90 255 255]);

fis = addvar(fis,'input','D2',[0, 255]);
fis = addmf(fis,'input',2,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',2,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',2,'white','trapmf',[40 90 255 255]);

fis = addvar(fis,'input','D3',[0, 255]);
fis = addmf(fis,'input',3,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',3,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',3,'white','trapmf',[40 90 255 255]);

fis = addvar(fis,'input','D4',[0, 255]);
fis = addmf(fis,'input',4,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',4,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',4,'white','trapmf',[40 90 255 255]);

fis = addvar(fis,'input','D5',[0, 255]);
fis = addmf(fis,'input',5,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',5,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',5,'white','trapmf',[40 90 255 255]);

fis = addvar(fis,'input','D6',[0, 255]);
fis = addmf(fis,'input',6,'black','trapmf',[0 0 10 30]);
fis = addmf(fis,'input',6,'mid','trimf',[20 40 60]);
fis = addmf(fis,'input',6,'white','trapmf',[40 90 255 255]);

% output of the FIS
fis = addvar(fis,'output','Iout',[0, 255]);
fis = addmf(fis,'output',1,'edge','trimf',[0 10 20]);
figure
subplot(121); plotmf(fis,'input',1); title('Input MFs of the FIS');
subplot(122); plotmf(fis,'output',1); title('Ouput MF of the FIS');

% rules of the FIS
rules =[1 3 0 0 0 0 1 1 1;
        0 0 1 3 0 0 1 1 1;
        -1 -1 0 0 0 0 1 1 1;
        0 3 0 0 0 3 1 1 1;
        0 0 -1 -1 0 0 1 1 1;
        3 1 0 0 0 0 1 1 1;
        0 0 3 1 0 0 1 1 1;
        3 0 0 0 3 0 1 1 1;
        0 0 0 0 3 1 1 1 1;
        0 0 0 0 1 3 1 1 1];
fis = addrule(fis, rules);
% rules of the system
showrule(fis)
for i=2:size(I_double,1)
    for j=2:size(I_double,2)
        % 2x2 window elements
        P1 = I_double(i-1,j-1);
        P2 = I_double(i-1,j);
        P3 = I_double(i,j-1);
        P4 = I_double(i,j);
        % inputs of the FIS
        % 6 direction derivatives
        D1(i,j) = abs(P1-P2); 
        D2(i,j) = abs(P3-P4);
        D3(i,j) = abs(P1-P3);
        D4(i,j) = abs(P2-P4);
        D5(i,j) = abs(P2-P3);
        D6(i,j) = abs(P1-P4);
%         Iout(i,j) = evalfis([D1 D2 D3 D4 D5 D6], fis);
    end
end
% evaluate output using inputs and rules
for i = 1: size(D1,1)
        Iout(i,:) = evalfis([D1(i,:);D2(i,:);D3(i,:);D4(i,:);D5(i,:);D6(i,:)], fis);
end
% convert gray levels to black and white image
Iout_BW = Iout < 15;
% Morphological thinning
se = strel('square',2);
I_erosion = imerode(Iout_BW,se);
figure
imshow(I_erosion,[])

% assessment metrics

% Shannon's Entropy
H_prewitt = ShannonEntropy(I_prewitt);
H_sobel = ShannonEntropy(I_sobel);
H_canny = ShannonEntropy(I_canny);
H_erosion = ShannonEntropy(I_erosion);

% Figure of Merit

% PSNR

