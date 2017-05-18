%%%%%%
% Below code is mostly generated from: 
% Abdallah A. Alshennawy, and Ayman A. Aly, 
% ?Edge Detection in Digital Images Using Fuzzy Logic Technique?,
% World Academy of Science, Engineering and Technology 53 2009, 
%%%%%%
clc
clear all
close all

%%% 
% reads colored image
I = imread('peppers.png');
% I = imread('lena512.png');
% converts gray scale level
Igray = rgb2gray(I);
[m, n] = size(Igray); % size of the image
% converts uint8 to double presicion to make operation on pixel values
Idouble=double(Igray);
% to create zeros matrix in the size of resized image
Iout = zeros(m, n);
%%%
fis = readfis('3x3slidingwindow.fis');
% there can be 2^9 possible rules and hard to solve so 50 rules are
% selceted
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
% OTSU threshold and morphologic operators are applied
level = graythresh(uint8(Iout));
bw = im2bw(uint8(Iout),level);
bw = bwareaopen(bw, 4);
figure
imshow(bw,[])