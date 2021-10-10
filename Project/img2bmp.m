% 

pwd = '/Users/joemogannam/Desktop/cs385/cs385Project/Matlab_code/Project/ClassificationAttempt/GroundTruth/';

pwd = '/Users/joemogannam/Desktop/cs385/cs385Project/Matlab_code/Project/ClassificationAttempt/Images/';
my_dir = dir(pwd);
file_2_remove = zeros(size(my_dir,2), size(my_dir,1),'logical');

% get only image files, remove others like '.', '..', '.DS_Store'
for i = 1 : size(file_2_remove,2)
   if (my_dir(i).isdir == 1) 
       file_2_remove(i) = 1; 
   end
    
   if strcmp(char(my_dir(i).name) , '.DS_Store') == 1
       file_2_remove(i) = 1; 
   end
   
end
index_remove = find(file_2_remove == 1);

my_dir(index_remove) = [];


% read in files & convert to bmp
for i=1 : length(my_dir)
    img_char = strcat(pwd, char(my_dir(i).name));
    img = imread(img_char);
    
    outname = char(my_dir(i).name);
    outname = regexprep(outname,'\.([A-Za-z]*)','.bmp');
    
   img = imresize(img, [57 37]);
   
   outname = strcat(pwd,outname );
   imwrite(img,outname,'bmp');
    
    
end
