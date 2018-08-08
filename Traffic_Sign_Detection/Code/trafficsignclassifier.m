%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function []= trafficsignclassifier()
%% Traning the SVM
% |imageDatastore| recursively scans the directory tree containing the
%% images. Folder names are automatically used as labels for each image.
trainingSet = imageDatastore('../train_selected',   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
testSet     = imageDatastore('../test_selected', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');


%% Loop over the trainingSet and extract HOG features from each image. 

numImages = numel(trainingSet.Files);
% trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingSet, i);
    img = rgb2gray(img);
    img = medfilt2(img, [3 3]);
    img = imresize(img, [64 64]);    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    trainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', [4 4]);  
end
% Get labels for each image.
trainingLabels = trainingSet.Labels;
classifier = fitcecoc(trainingFeatures, trainingLabels);
%% Evaluating the Classifier
% % numImages = numel(testSet.Files);
% % % testFeatures = zeros(numImages, hogFeatureSize, 'single');
% % % testLabels = testingSet.Labels;
% % % 
% % for i = 1:numImages
% %     img = readimage(testSet, i);
% %     img = rgb2gray(img);
% %     img = medfilt2(img, [3 3]);
% %     img = imresize(img, [64 64]);
% %       % Apply pre-processing steps
% %     img = imbinarize(img);
% %     testFeatures(i, :) = extractHOGFeatures(img, 'CellSize', [4 4]);  
% % end
% % % Get labels for each image.
% % testLabels = testSet.Labels;
% % % Predicr
% % predictedLabels = predict(classifier, testFeatures);
% % confMat = confusionmat(testLabels, predictedLabels);
end
