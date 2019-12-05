%% Wrapper for oneSignalCreator
% Specify filenams
filename_data = 'week-02-chunks-data.csv';
filename_labels = 'week-02-chunks-labels.csv';

% Number of signals
num_signals = 5000;
mu = 0;
sigma = 0.5;
signal_max = 5;

% Preallocate Arrays
signal_array = zeros(100,num_signals);
oh_wn_array = zeros(100,num_signals);
oh_curve_array = zeros(100,num_signals);
oh_square_array = zeros(100,num_signals);

% Loop for making signal array
for n = 1:num_signals
    % Create the signal
    [signal, oh_wn, oh_curve , oh_square] = oneSignalCreator(signal_max, mu, sigma);
    
    % Save them to the array 
    signal_array(:,n) = signal';
    oh_wn_array(:,n) = oh_wn';
    oh_curve_array(:,n) = oh_curve';
    oh_square_array(:,n) = oh_square';
    
    % The one hot for the chunks
    oh_class(:,n) = [max(oh_curve), max(oh_square)]';
end

% Write the files
csvwrite(filename_data, signal_array)
csvwrite(filename_labels, oh_class)

%% Make the long signal

n_signals = 10000;
filename_data = 'week-02-multi-data.csv';
filename_labels = 'week-02-multi-labels.csv';
[signal, oh_wn, oh_curve, oh_square] = signalCreator(n_signals, signal_max, mu, sigma);

complete_oh = [oh_wn oh_curve oh_square];

% Write the files
csvwrite(filename_data, signal)
csvwrite(filename_labels, complete_oh)



%% Make some plots to show what the data look like

sig_length = size(signal_array,1);

figure(1)
for n = 1:6
    subplot(6,1,n)
    box off; grid off; hold on;
    plot(1:sig_length, signal_array(:,19+n), 'k')
    
    if n ~= 6
        set(gca, 'XTick', []);
    else
        a = get(gca, 'XTickLabel');
        set(gca, 'XTickLabel', a, 'fontsize', 12)
        xlabel('X', 'fontsize', 16)
    end
    
    set(gca, 'YTick', [])
    ylim([-2 6]);
end
sgtitle('Example Signals', 'Fontsize', 20)
hold off

%%

figure(2)
box on; 
plot(1:300, signal(201:500), 'k')

xlabel('X', 'fontsize', 16)
ylabel('Y', 'fontsize', 16)

a = get(gca, 'XTickLabel');
set(gca, 'XTickLabel', a, 'fontsize', 12)

ylim([-3 7]);