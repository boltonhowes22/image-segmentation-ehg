function [signal, oh_wn, oh_curve , oh_square] = oneSignalCreator(signal_max, mu, sigma)

% one signal features


%randomize 
rng('shuffle');
num_signals = 1;
sig_type = randi([0 1],1,num_signals);
sig_length = randi([20 40],1, num_signals);            % Set singal length of signals
length_timeseries = 100;
entire_signal = sum(sig_length);

% Preallocate
signal = whiteNoiser(mu, sigma, length_timeseries);     % Signal
oh_curve = zeros(length(signal),1);                     % one hot curve
oh_square = zeros(length(signal),1);                    % one hot square
oh_wn = zeros(length(signal),1);                        % one hot white noise
total_length = 1; 


start_pos = randi([1 60], 1, 1); 
    
% Build the signal
if sig_type == 0
    %CURVE
    % Make curve, add to the signal
    y = curver(sig_length, signal_max);
    signal(start_pos:start_pos+length(y)-1) = y;

    % Add to the one hot
    oh_curve(start_pos:start_pos+length(y)-1) = ones(sig_length,1);
elseif sig_type == 1
    %SQUARE
    % Make square, add to the signal
    y = squarer(sig_length, signal_max);
    signal(start_pos:start_pos+length(y)-1) = y;

    % Add to the one hot
    oh_square(start_pos:start_pos+length(y)-1) = ones(sig_length,1);
else
    disp('ERROR: UNKNOWN SIGNAL TYPE')
end 

total_length = total_length+sig_length;
end






%%
function y = curver(length_sig_class, signal_max)
th = linspace( -pi/2, pi/2, length_sig_class);
R = signal_max;  %or whatever radius you want
x = R*sin(th)+1;
y = R*cos(th);
end


function y = squarer(length_sig_class, signal_max)
y1 = boxcar(length_sig_class);
y = y1*signal_max;
end

function y = whiteNoiser(mu, sigma, length_sig_class)
y = sigma *randn(1,length_sig_class)+mu;
end

