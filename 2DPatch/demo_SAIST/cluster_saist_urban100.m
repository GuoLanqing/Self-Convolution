function [psnrXr] = cluster_saist_urban100(jobid)
%%%%%%%%%%%%%%%%% loading directory %%%%%%%%%%%%%%%%%%%%%%%
method          =   'saist';
% root            =   'F:/scratch';
root            =   '~/scratch';
direct          =   'imageDataset';
inputFormat     =   '*.png';
% resultDir       =   'statsResult';
dataFormat      =   '.mat';
% datatype        =   '*.mat';
databaseList    =   {'urban100_SRF2seed'};       % 3 resolutions of Urbana100
% numDatabase     =   numel(databaseList);
% NoiseLevel      = 	[15; 25; 30; 50; 70];
NoiseLevel      = 	[30; 50; 70];
numNoiseLevel   =   numel(NoiseLevel);
% % translate jobID
% variableTuning.databaseList = databaseList;
% idxList = jobID_translate(jobid, variableTuning);
% (special case) assign each thread one image + one sigma
remaining       =   jobid;
idxDatabase     =   0;
while remaining > 0
    idxDatabase     =   idxDatabase + 1;
    curDatabase     =   databaseList{idxDatabase};
    imList          =   dir(fullfile(root, direct, curDatabase, inputFormat));
    numImage        =   numel(imList);
    if remaining > numImage * numNoiseLevel
        remaining   =   remaining - numImage * numNoiseLevel;
    else
        idxImage    =   ceil(remaining / numNoiseLevel);
        idxSigma    =   rem(remaining - 1, numNoiseLevel) + 1;
        break;
    end
end
curData             =   imList(idxImage).name;
curName             =   curData(1 : end - length(dataFormat));
sigma               =   NoiseLevel(idxSigma);
% clean data generation
I7 = double(imread(fullfile(root, direct, curDatabase, curData))); 
% load the noisy data
load(fullfile(root, direct, curDatabase, ...
    curName, ['sigma', num2str(sigma), dataFormat]), 'noisy');
% check if the result has been completed
targetDir   =   fullfile(root, direct, [curDatabase, '_', method], curName);
targetfile  =   fullfile(targetDir, ['sigma', num2str(sigma), dataFormat]);
if exist(targetfile)
    return;
else    
    noisy               =   double(noisy);
    %%%%%%%%%%%%%%%%% SAIST %%%%%%%%%%%%%%%%%%%%%%%%%
    param       =   SAIST_param(sigma);
    param.I     =   I7;
    param.nim   =   noisy;
    [Xr, psnrXr, ssimXr] = LASSC_Denoising(param);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mkdir(targetDir);    
    save(targetfile, 'NoiseLevel', 'databaseList', 'psnrXr', 'ssimXr', 'Xr');
end
end
