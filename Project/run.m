function run(choice)
    % Note: You need the function myResize() to run the code

    % choice < 0, run all files
    % choice >= 0, run only test files 
    pwd = './ClassificationAttempt/';

    if choice <0 % run all files from begining to end
        % resize all images in Images folder
        folder = './ClassificationAttempt/Images/';
        myResize(folder);

        % resize all Images in GroundTruth folder
        folder = './ClassificationAttempt/GroundTruth/';
        myResize(folder);

        % delete all the files in TextonizedImages, & its subflder View
        folder = './ClassificationAttempt/TextonizedImages/';
        delete_file = strcat(folder,'*.bmp');
        delete(delete_file);
        folder2 = './ClassificationAttempt/TextonizedImages/View/';
        delete_file = strcat(folder2,'*.bmp');
        delete(delete_file);
        delete_file = strcat(folder2,'*.fig');
        delete(delete_file);

        % delete all files in Model folder
        folder = './ClassificationAttempt/Model/';
        delete_file = strcat(folder,'*.mat');
        delete(delete_file);



        % delete all files in Model folder



        imagesTextonization;
        calcModelFeatures;
        trainModel;
        testModel;
    else % else we are only testing, Note if you are testing make sure
        % you change the name of the input image to test on, located in
        % testModel.m
        testModel;

    end

    fprintf('run done \n')