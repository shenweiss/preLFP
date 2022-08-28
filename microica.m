function [eeg]=microica(eeg_mp);

    % hf_bad uses the HFO band pass filtered EEG mutual information
    % adjacency matrix, and graph theory (community) during episodes of artifact to define dissimar
    % electrodes. The bipolar montage is calculated for the dissimilar
    % electrodes recover cell structure after matlab engine

    metadata=[];
    paths=[];
    mp_toolbox = MonopolarDspToolbox; 
    error_status = 0; 
    error_msg = '';
    ripple.low = 80;
    ripple.high = 600;
    fripple.low = 200;
    fripple.high = 600;
    sampling_rate = 2000; %view if we can add it to metadata struct

    fprintf('Removing excess HF artifact electrodes \r');
    [metadata]=ez_hfbad_putou02(tall(eeg_mp),metadata); % Find MI of maximum artifact

    % Remove bad channels from monopolar montage
    chan_indexes = metadata.hf_bad_m_index;
    eegindex=[1:numel(eeg_mp(:,1))];
    eeg=eeg_mp;
    eeg_mp(chan_indexes,:)=[];
    eegindex(chan_indexes)=[];

    % cudaica_matlab function isolates muscle artifact producing artifactual
    % HFOs to the first independent component of the HFO band pass filtered
    % EEG. The first independent component is removed to reduce artifact, and
    % IC1 is also used to refine the artifact index on a millisecond time
    % scale.
    [hfo, ic1, EEG, error_flag] = ez_cudaica_ripple(eeg_mp, ripple.low, ripple.high, sampling_rate, paths);
    [eeg_data, eeg_data_no_notch] = mp_toolbox.notchFilter(eeg_mp);
    eeg_data = ez_eegfilter(eeg_data,0.01,80,2000);
    eeg_data_recomposed=eeg_data+ic1;
    eeg(eegindex,:)=eeg_data_recomposed;
    