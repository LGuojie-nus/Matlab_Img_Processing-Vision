%BW=imread('led.png');
BW=imread('DSC00174.jpg');
BW=imresize(BW,0.1);
BW=rgb2gray(BW);
BW=imbinarize(BW);
%%
[B,L,N,A] = bwboundaries(BW); 
%%
imshow(BW); hold on;
for k=1:length(B)
   boundary = B{k};
   if(k > N)
     plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
   else
     plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
   end
end


%%
BW=imread('DSC00174.jpg');
BW=imresize(BW,0.1);
R = BW(:,:,1);
G = BW(:,:,2);
B = BW(:,:,3);
imshow(R);
figure
imshow(G)
figure
imshow(B)

%%
[a,b]=imgradientxy(BW);
%%
imshowpair(a,b,'montage');


%%

img = imread('DSC00174.jpg'); % Read image
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2));
%
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
%back_to_original_img = cat(3, red, green, blue);
figure, imshow(img), title('Original image')
figure, imshow(just_red), title('Red channel')
figure, imshow(just_green), title('Green channel')
figure, imshow(just_blue), title('Blue channel')
%figure, imshow(back_to_original_img), title('Back to original image')