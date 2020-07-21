
%%%%%%%%%%%%%%%%% loading directory %%%%%%%%%%%%%%%%%%%%%%%
method          =   'saist';
% root            =   'F:/scratch';
root            =   '~/scratch';
direct          =   'imageDataset';
inputFormat     =   '*.png';
% resultDir       =   'statsResult';
dataFormat      =   '.mat';
% datatype        =   '*.mat';
databaseList    =   {'urban100_SRF2seed'};
% numDatabase     =   numel(databaseList);
% NoiseLevel      = 	[15; 25; 30; 50; 70];
NoiseLevel      = 	[30; 50; 70];
numNoiseLevel   =   numel(NoiseLevel);
numImage    =   100;
numSigma    =   numNoiseLevel;
psnrOut     =   zeros(numImage, numSigma);
jobid   =   0;
targetFile  =   fullfile(root, direct, [databaseList{1}, '_', method], 'result.mat');
for idxImage     =  1 : numImage
    for idxSigma    =    1 : numSigma
        jobid = jobid + 1;
 
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
        % check if the result has been completed
        targetDir   =   fullfile(root, direct, [curDatabase, '_', method], curName);
        targetfile  =   fullfile(targetDir, ['sigma', num2str(sigma), dataFormat]);
        if exist(targetfile)
            load(targetfile, 'psnrXr');
        end
        psnrOut(idxImage, idxSigma) = psnrXr;
    end
end
save(targetFile, 'psnrOut', 'curDatabase', 'NoiseLevel', 'method');