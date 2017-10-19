%% Get list of all JPG files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   %images{ii} = currentimage;
   images{ii}=imresize(currentimage,1);
   %############# additional code
   BW=images{ii};
   %BW=rgb2hsv(BW);
   BW=imbinarize(BW);
   %BW=imgaussfilt(BW,4);
   BW=unit24(255*);
   images{ii}=BW;
   %#############
   
   str=strcat('C:\Users\mpelang\Desktop\',currentfilename);
   imwrite(images{ii},str);
end


%%
%% read each channel separately and show

img = a;
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
back_to_original_img = cat(3, red, green, blue);
figure, imshow(img), title('Original image')
figure, imshow(just_red), title('Red channel')
figure, imshow(just_green), title('Green channel')
figure, imshow(just_blue), title('Blue channel')
%figure, imshow(back_to_original_img), title('Back to original image')


%% record video
v=VideoReader('mobile.mp4');
num_Frames = v.NumberOfFrames;
w = VideoWriter('output3.avi','Uncompressed AVI');
w.FrameRate=10;
open(w);
for frame = 2:2:num_Frames
		% Extract the frame from the movie structure.
		thisFrame = read(v, frame);
        C,data_gray]=fuzzy_C_means_Ycbcr(thisFrame,2);
        %image(data_gray);
        %writeVideo(w,data_gray);
        disp(frame);
        imshow(thisFrame)
      
        pause(.05)
end
close(w)