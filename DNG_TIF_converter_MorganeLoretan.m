
clear all;

FolderPosition = '\\onecopy\Science\Physics\Acuna_group\Morgane\SaveS22_Sm_correlation\New_2LS_20231129\046\046'; %start folder (where picture are)

% On Matlab folder position barre: where folder will be saved
Folder = dir(FolderPosition);

% for rawRed,rawGreen,rawBlue only because twice less pixel than original
% as not demosaicing

x1=130;  %imagJ correspond to y axis
x2=430;

y1=170;   %imagJ correspond to x axis
y2=530;

NumberFrames = length(Folder)-3;

for i=3:1:3%length(Folder)
   
warning('off')
    
fileIm = Folder(i).name;  %get name of picture in string    
Openfile = append(FolderPosition,'\', fileIm);    
info = imfinfo(Openfile); %to get picture info   

    
    if eq(info.BitDepth,16) == 1
       
        fileSave = append(fileIm(1:end-3),'tif');
        fileSaveCrop = append(fileIm(1:end-4),'_crop','.tif');
        
        testtestR = append(fileIm(1:end-4),'_Red','.tif');
        testtestG = append(fileIm(1:end-4),'_Green','.tif');
        testtestGR = append(fileIm(1:end-4),'_GreenRed','.tif');
        testtestB = append(fileIm(1:end-4),'_Blue','.tif');
        
        t = Tiff(Openfile, 'r');
       
        cfa = read(t);
        
        close(t);
 
        %cfaCrop = cfa(2235:3236,3147:4148); %need to begin at odd position otherwise need to change the used pattern rggb into bggr in demosaic function
       
        x_origin = info.ActiveArea(2)+1+info.DefaultCropOrigin(2); % +1 due to MATLAB indexing
        width = info.DefaultCropSize(1);
        y_origin = info.ActiveArea(1)+1+info.DefaultCropOrigin(1);
        height = info.DefaultCropSize(2);
        raw = double(cfa(y_origin:y_origin+height-1,x_origin:x_origin+width-1));
       
        
    
%y=y_origin+height-1;
%x=x_origin+width-1;


raw1=raw(1:2:end,1:2:end);
raw2=raw(1:2:end,2:2:end);
raw3=raw(2:2:end,1:2:end);
raw4=raw(2:2:end,2:2:end);

 
rawRed1=raw2;%raw2=red for S22ultra
rawBlue1=raw3;%raw3=blue for S22ultra
rawGreen1=((raw1+raw4))/2;

%Get the RGB normal value from 0 to 2^16
rawRed =uint16(rawRed1);
rawGreen =uint16(rawGreen1);
rawBlue =uint16(rawBlue1);
rgbImage =(cat(3, rawRed, rawGreen, rawBlue));


        %imwrite(rawRed(x1:1:x2,y1:1:y2), testtestR)%create a tiff picture of full
        %imwrite(rawRed, testtestR)%create a tiff picture of full
        %imwrite(rawGreen(x1:1:x2,y1:1:y2), testtestG)%create a tiff picture of full
         %imwrite(rawGreen(x1:1:x2,y1:1:y2)+rawRed(x1:1:x2,y1:1:y2), testtestGR)%create a tiff picture of full
        %imwrite(rawGreen, testtestG)%create a tiff picture of full
        %imwrite(rawBlue(x1:1:x2,y1:1:y2), testtestB)%create a tiff picture of full
        %imwrite(rawBlue, testtestB)%create a tiff picture of full
  
% %     figure (i)
% %         imagesc(uint8(G*2^8));
       
        disp(' ')
        disp(fileIm)
        disp('Done with succes over')
        disp(NumberFrames)
    else
            disp(' ')
            warning('on')
            warning(append (fileIm,' has a wrong value of BitDepth !' ) )
    end

i=i+1;

end