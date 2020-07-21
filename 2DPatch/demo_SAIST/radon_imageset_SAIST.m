root            =   '~/scratch';
direct          =   'imageDataset';
statsDir        =   'imagedataset_result';
methodName      =   'saist';
format          =   '.mat';
datatype        =   '*.mat';
databaseList    =   {'Set5', ...
    'Set14', ...
    'SIPImisc', ...
    'kodak'};      
numDatabase     =   numel(databaseList);
NoiseLevel      =   [5; 10; 15; 20; 25; 50; 75; 100];
numNoiseLevel   =   numel(NoiseLevel);

for idxDatabase = 1 : numDatabase
    curDatabase     =   databaseList{idxDatabase};
    imList          =   dir(fullfile(root, direct, curDatabase, datatype));
    numImage        =   numel(imList);
    % output
    psnrTable       =   zeros(numImage, numNoiseLevel);
    ssimTable       =   zeros(numImage, numNoiseLevel);
    % output dir
    targetName          =   fullfile(root, direct, [curDatabase, '_', methodName]);
    sourceName          =   fullfile(root, direct, curDatabase);
    mkdir(targetName);          % output image
    statsName           =  	fullfile(root, statsDir, curDatabase);
    mkdir(statsName);           % output PSNR result
    for idxImage = 12 : numImage
        curData     =   imList(idxImage).name;
        load(fullfile(sourceName, curData), 'I7');       
        curName     =   curData(1:end - length(format));
        mkdir(fullfile(targetName, curName));
        for idxSigma = 1 : numNoiseLevel
            sigma   =   NoiseLevel(idxSigma);
            load(fullfile(sourceName, curName, ['sigma', num2str(sigma), format]), 'I1');
            %%%%%%%%%%%%%%%%% GHP denoising method %%%%%%%%%%%%%%%%%%%%%%%
            param   =   SAIST_param(sigma);
            param.I     =   I7;
            param.nim   =   I1; 
            [Xr, psnrXr, ssimXr] = LASSC_Denoising(param);
%             psnrXr      =   PSNR3D(Xr - I7);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            save(fullfile(targetName, curName, ['sigma', num2str(sigma), format]), ...
                'Xr', 'psnrXr', 'ssimXr', '-v7.3');
            psnrTable(idxImage, idxSigma) = psnrXr;
            ssimTable(idxImage, idxSigma) = ssimXr;
        end
        save(fullfile(targetName, [methodName, format]), ...
            'psnrTable', 'ssimTable', 'NoiseLevel', 'imList');
        save(fullfile(statsName, [curDatabase, '_', methodName,  format]), ...
            'psnrTable', 'ssimTable', 'NoiseLevel', 'imList');
    end

end

