function img = myResize(pwd)

all_files = dir(pwd);
mysize = length(all_files);


% minHeight = 0;
% minWidth = 0;

maxHeight = 0;
maxWidth = 0;


first  = true();

for i=1:mysize
    
    
    
    if  (all_files(i).isdir == 0) && (strcmp(all_files(i).name,'.DS_Store') == 0) ...
            && length(strfind(all_files(i).name,'.bmp')) > 0 
        
        filename = strcat(pwd,char(all_files(i).name));
        info = imfinfo(filename);
        temp_w = info.Width;
        temp_h = info.Height;
        
        %fprintf('w: %d h: %d \n',temp_w,temp_h );
        
        if first == 1
            minHeight = temp_h ;
            minWidth = temp_w ;
            first = 0;
        end
       
        
       if temp_w <  minWidth
           minWidth = temp_w;           
       end
       
        if temp_h <  minHeight
           minHeight = temp_h;
           
       end
       
       
       if temp_w >  maxWidth
           maxWidth = temp_w;       
       end
       
       if temp_h >  maxHeight
            maxHeight = temp_h;
       end
       
          
    end
       
    
end
 fprintf('min w: %d  min h: %d \n', minWidth, minHeight);
 fprintf('max w: %d  max h: %d \n', maxWidth, maxHeight);

 
 for i = 1: mysize
           
        if  (all_files(i).isdir == 0) && (strcmp(all_files(i).name,'.DS_Store') == 0) ...
            && length(strfind(all_files(i).name,'.bmp')) > 0 
        
            filename = strcat(pwd,char(all_files(i).name));
        
            img = imread(filename);
            img = imcrop(img, [0,0,minWidth, minHeight]);
      
           imwrite(img,filename, 'bmp'); 
        end
 end
% 
% minWidth
% minHeight
% maxWidth
% maxHeight

% % 
% % for i=1:mysize
% %    
% %     if  (all_files(i).isdir == 0) && (strcmp(all_files(i).name,'.DS_Store') == 0) ...
% %             && length(strfind(all_files(i).name,'.bmp')) > 0 
% %        
% %          
% %          filename = strcat(pwd,char(all_files(i).name));
% %          img = imread(filename);
% %          img = imresize(img, [width,height]);
% %          imwrite(img,filename, 'bmp');
% %         
% %     end
% %     
% % end

fprintf('** myResize done **\n ')





