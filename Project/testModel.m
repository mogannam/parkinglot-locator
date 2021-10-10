%{ 
testModel.m

Test Model

ML founndations - 2012A
Yaniv Bar

%}
clear;
close all;
DISPLAY_LEVEL=1;
DEBUG_FLAG=0;
RECOMPUTE_FLAG=1;
dbg_step =1 ;

% start: Should be the same as in imagesTextonization.m
filterSize=[5,5];
numClusters=3;

in_model_folder='ClassificationAttempt/Model';
in_model_folder_pwd=strcat(pwd(), '/', in_model_folder);
in_model_base_mat_file='model.mat';
in_processedClassColors_mat_file = 'pcc.mat';



%select one of the following

%{
% test real data (#1)
in_test_folder='ClassificationAttempt/Test';
in_test_folder_pwd=strcat(pwd(), '/', in_test_folder);
in_test_file_prefix='1_15_s';
in_test_file='1_15_s.bmp';
in_test_GT_file='1_15_s_GT.bmp';
in_test_GT_BM_file='1_15_s_GT_BM.bmp';
%}

% test real data (#2)
%{
in_test_folder='ClassificationAttempt/Test';
in_test_folder_pwd=strcat(pwd(), '/', in_test_folder);
in_test_file_prefix='3_29_s';
in_test_file='3_29_s.bmp';
in_test_GT_file='3_29_s_GT.bmp';
in_test_GT_BM_file='3_29_s_GT_BM.bmp';
%}

%{
% test real data (#3)
in_test_folder='ClassificationAttempt/Test';
in_test_folder_pwd=strcat(pwd(), '/', in_test_folder);
in_test_file_prefix='2_2_s';
in_test_file='2_1_s.bmp';
in_test_GT_file='2_1_s_GT.bmp';
in_test_GT_BM_file='2_1_s_GT_BM.bmp';
%}






% --- car test 
in_test_folder='ClassificationAttempt/Test';
in_test_folder_pwd=strcat(pwd(), '/', in_test_folder);
in_test_file_prefix='2_2_s';
in_test_file='2_2_s.bmp';
in_test_GT_file='2_2_s_GT.bmp';
in_test_GT_BM_file='2_2_s_GT_BM.bmp';
% -- end car test


% ---  test my car data ----
in_test_folder='ClassificationAttempt/Test';
in_test_folder_pwd=strcat(pwd(), '/', in_test_folder);
in_test_file_prefix='2012-09-28_07_41_01';
in_test_file='2012-09-28_07_41_01.bmp';
in_test_GT_file='2012-09-28_07_41_01_GT.bmp';
in_test_GT_BM_file='2012-09-28_07_41_01.bmp';
% --- end test my car data --- 



out_test_folder='ClassificationAttempt/Test';
out_test_folder_pwd=strcat(pwd(), '/', out_test_folder);
out_test_TM_file = sprintf('%s_TM.bmp', in_test_file(1:end-4));
out_test_GT_file = sprintf('%s_GT_COMP.bmp', in_test_file(1:end-4));

if(DISPLAY_LEVEL==1)
    display('* Init GT color classes...')
end

colorClasses=initGroundTruthColorClasses();
temp = load(strcat(in_model_folder_pwd,'/',in_processedClassColors_mat_file));
processedClassColors = temp.processedClassColors;

if(DISPLAY_LEVEL==1)
    display('* Performing test image textonization...')
end

test_Im_pathname=strcat(in_test_folder_pwd, '/', in_test_file);
test_Im = imread(test_Im_pathname);
temp_image = test_Im;
test_Im = im2double(test_Im);
[test_Im_n,test_Im_m,test_Im_d]=size(test_Im);


% end
if(RECOMPUTE_FLAG==1)
    filtrerBank=getFilterBank(filterSize);
    textonized_test_Im=uint8(imgTextonization(test_Im, filtrerBank, numClusters));
    textonized_test_Im=im2double(textonized_test_Im);
    textonized_test_Im=orderImgTextonization(textonized_test_Im);
    outImgFileName=strcat(out_test_folder_pwd, '/', out_test_TM_file);
    imwrite(textonized_test_Im, outImgFileName);     
    outImgFileNameForView = sprintf('%s_V.bmp', outImgFileName(1:end-4));
    textonized_test_Im_View=textonized_test_Im;
    textonized_test_Im_View=imadjust(textonized_test_Im_View,[min(textonized_test_Im_View(:)),max(textonized_test_Im_View(:))],[0,1]);
    imwrite(textonized_test_Im_View, outImgFileNameForView);

    Textons=unique(textonized_test_Im);
    maskSize = [5,5];
    if(maskSize(1)==1 && maskSize(2)==1)
        textonized_test_Im_SS = textonized_test_Im;
    else
        textonized_test_Im_SS = subSampleImg(textonized_test_Im,maskSize);
    end

    test_GT_Im_pathname=strcat(in_test_folder_pwd, '/', in_test_GT_file);
    test_GT_BM_Im_pathname=strcat(in_test_folder_pwd, '/', in_test_GT_BM_file);
    test_GT_Im = imread(test_GT_Im_pathname); 
    test_GT_Im = im2double(test_GT_Im);
    test_GT_BM_Im = subSampleImg(test_GT_Im,maskSize);
    imwrite(test_GT_BM_Im, test_GT_BM_Im_pathname);    

    if(DEBUG_FLAG == 1)
        figure;
        subplot(3,1,1); imshow(test_Im);
        subplot(3,1,2); imshow(textonized_test_Im);
        subplot(3,1,3); imshow(textonized_test_Im_SS);
    end

    if(DISPLAY_LEVEL==1)
        display('* Performing test image features extraction...')
    end

    [SS_n,SS_m]=size(textonized_test_Im_SS);
    out_classified_im=zeros(SS_n,SS_m,test_Im_d);
    textonized_test_Im_FeaturesCell = calcImgFeatures(Textons,textonized_test_Im_SS);

    if(DISPLAY_LEVEL==1)
        display('* Performing test image classification...')
    end

    for i=1:dbg_step:SS_n
        processedSoFar = (((i-1)*SS_m)/(SS_n*SS_m))*100;
        if(DISPLAY_LEVEL==1)
            fprintf('\n*--- So far processed = %3.2f perc.', processedSoFar);
        end  
        for j=1:SS_m
            classificationColors = [];
            classificationWeights = [];
            textonizedImgFeaturesCell = textonized_test_Im_FeaturesCell{i,j};
            for k=1:length(processedClassColors)
                processedColor=processedClassColors(k);
                in_model_mat_file = sprintf('%s_%d.mat', in_model_base_mat_file(1:end-4),processedColor);
                temp = load(strcat(in_model_folder_pwd,'/',in_model_mat_file));
                model = temp.model;
                [classifiedLabel, weight] = CLSgentleBoostC(textonizedImgFeaturesCell, model);
                if(DEBUG_FLAG==1)
                    fprintf('\n*--- (%i,%i) - Processed color=%i, Classified Label=%i, Weight=%f',j,i,processedColor,classifiedLabel,weight);
                end
                classificationColors = [classificationColors, processedColor];
                classificationWeights = [classificationWeights, weight];
                clear model;
            end

            classifiedWeight=max(classificationWeights);
            classifiedWeightInd=find(classificationWeights==classifiedWeight);
            classifiedColor = classificationColors(classifiedWeightInd);

            if(DEBUG_FLAG==1)
                fprintf('\n*--- (%i,%i) - Classified color=%i, Classified weight=%f',j,i,classifiedColor,classifiedWeight);
            end     

            classifiedColor_RGB=colorClasses{classifiedColor,2};
            out_classified_im(i,j,:)=classifiedColor_RGB;    
        end  
        if(DEBUG_FLAG==1)  
            figure(2);
            subplot(1,1,1); imshow(out_classified_im);
        end    
    end
    
    

    outImgFileName=strcat(out_test_folder_pwd, '/', out_test_GT_file);
    imwrite(out_classified_im, outImgFileName);
else   
    test_GT_BM_Im_pathname=strcat(in_test_folder_pwd, '/', in_test_GT_BM_file);
    test_GT_BM_Im = imread(test_GT_BM_Im_pathname); 
    test_GT_BM_Im = im2double(test_GT_BM_Im);
  
    outImgFileName=strcat(out_test_folder_pwd, '/', out_test_GT_file);
    out_classified_im = imread(outImgFileName); 
    out_classified_im = im2double(out_classified_im);
end

accuracy=0;
[n,m,dc]=size(out_classified_im);
for i=1:n
    for j=1:m
        comp=(test_GT_BM_Im(i,j,:)==out_classified_im(i,j,:));
        if(sum(comp)==3)
            comp=1;
        else
            comp=0;
        end
        accuracy=accuracy+comp;
    end
end
accuracy=accuracy/(n*m);
fprintf('\n*Acc= %f',accuracy);

resTitleStr = sprintf('Computed GT. Filter=%ix%i, #Textons=%i, Acc=%f', filterSize(1),filterSize(2),numClusters,accuracy);
colors=colorClasses(processedClassColors);
colors{1,length(colors)+1}='void(not defined)';




handle = figure;
subplot(1,4,1); imshow(test_Im);title(resTitleStr);
subplot(1,4,2); imshow(test_GT_BM_Im);title('Base GT');
subplot(1,4,3); imshow(out_classified_im);title(colors);
noisyRGB = out_classified_im;
% apply median filter to textonized image
% Extract the individual red, green, and blue color channels.
redChannel = noisyRGB(:, :, 1);
greenChannel = noisyRGB(:, :, 2);
blueChannel = noisyRGB(:, :, 3);
% Median Filter the channels:
redMF = medfilt2(redChannel, [3 3]);
greenMF = medfilt2(greenChannel, [3 3]);
blueMF = medfilt2(blueChannel, [3 3]);
% Find the noise in the red.
noiseImage = (redChannel == 0 | redChannel == 255);
% Get rid of the noise in the red by replacing with median.
noiseFreeRed = redChannel;
noiseFreeRed(noiseImage) = redMF(noiseImage);
% Find the noise in the green.
noiseImage = (greenChannel == 0 | greenChannel == 255);
% Get rid of the noise in the green by replacing with median.
noiseFreeGreen = greenChannel;
noiseFreeGreen(noiseImage) = greenMF(noiseImage);
% Find the noise in the blue.
noiseImage = (blueChannel == 0 | blueChannel == 255);
% Get rid of the noise in the blue by replacing with median.
noiseFreeBlue = blueChannel;
noiseFreeBlue(noiseImage) = blueMF(noiseImage);
% Reconstruct the noise free RGB image
rgbFixed = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);
subplot(1,4,4); imshow(rgbFixed);title('w/o noise');

fileNameStr = sprintf('%s_results_%ix%i_#T=%i_ACC=%f.fig', in_test_file_prefix,filterSize(1),filterSize(2),numClusters,accuracy);
out_fname_fig = fileNameStr;
out_pathname_fig=strcat(out_test_folder_pwd, '/', out_fname_fig);  
saveas(handle, out_pathname_fig);

groundTruthColorClasses=initGroundTruthColorClasses();
rateMat=zeros(length(colors)-1,2);
for colorInd=1:length(colors)-1
    processedClassColorCode=processedClassColors(colorInd);
    groundTruthColorRGB=groundTruthColorClasses(processedClassColorCode,2);
    groundTruthColorRGB=groundTruthColorRGB{1};
    gtCnt=0;
    outCnt=0;
    tpCnt=0;
    fpCnt=0;
    for i=1:n
        for j=1:m
            vec=test_GT_BM_Im(i,j,:);
            vec=[vec(1);vec(2);vec(3)];
            comp_gt=sum(vec==groundTruthColorRGB)/length(vec);
            if(comp_gt~=1)
                comp_gt=0;
            end
            vec=out_classified_im(i,j,:);
            vec=[vec(1);vec(2);vec(3)];
            comp_out=sum(vec==groundTruthColorRGB)/length(vec);
            if(comp_out~=1)
                comp_out=0;
            end
            if(comp_gt==1)
                gtCnt=gtCnt+1;
            end
            if(comp_out==1)
                outCnt=outCnt+1;
            end
            if(comp_gt==1 && comp_out==1)
                tpCnt=tpCnt+1;
            end
            if(comp_gt==0 && comp_out==1)
                fpCnt=fpCnt+1;
            end
        end
    end
    if(gtCnt==0)
         rateMat(colorInd,1)=0;
    else
         rateMat(colorInd,1)=tpCnt/gtCnt;
    end
    if(outCnt==0)
         rateMat(colorInd,2)=0;
    else
         rateMat(colorInd,2)=fpCnt/outCnt;
    end
end

fprintf('\n*Color classes');
colorClasses(processedClassColors)
fprintf('\n*Tp/Fn matrix [columns] for each of the color classes [rows]');
rateMat

% figure, imshow(out_classified_im);
imwrite(temp_image, test_Im_pathname);
fprintf('\n'); 
clear;

