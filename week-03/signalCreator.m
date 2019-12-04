function [signal, oh_wn, oh_curve , oh_square] = signalCreator(num_signals, signal_max, mu, sigma)

%randomize 
rng('shuffle');

sig_types = randi([0 4],1,num_signals);
sig_lengths = randi([20 40],1, num_signals);       % Set singal length of signals
entire_signal = sum(sig_lengths);

% Preallocate
signal = whiteNoiser(mu, sigma, entire_signal);     % Signal
oh_curve = zeros(length(signal),1);                 % one hot curve
oh_square = zeros(length(signal),1);                % one hot square
oh_wn = zeros(length(signal),1);                    % one hot white noise
total_length = 1;                                   % preallocate total length

for n = 1:num_signals
    
    % Early definitions for the loop
    y = 0;
    sig_length = sig_lengths(n);
    sig_type = sig_types(n);
    
    %signal_chunk = signal(total_length:total_length+sig_length-1);
    
    % Build the signal
    if sig_type == 0 || sig_type == 1 || sig_type == 2
        %WHITE NOISE, unchanged signal
        a = 1+1;
        
        % Add to the one hot
        oh_wn(total_length:total_length+sig_length-1) = ones(sig_length,1);
    elseif sig_type == 3
        %CURVE
        % Make curve, add to the signal
        y = curver(sig_length, signal_max);
        signal(total_length:total_length+sig_length-1) = y;
        
        % Add to the one hot
        oh_curve(total_length:total_length+sig_length-1) = ones(sig_length,1);
    elseif sig_type == 4
        %SQUARE
        % Make square, add to the signal
        y = squarer(sig_length, signal_max);
        signal(total_length:total_length+sig_length-1) = y;
        
        % Add to the one hot
        oh_square(total_length:total_length+sig_length-1) = ones(sig_length,1);
    else
        disp('ERROR: UNKNOWN SIGNAL TYPE')
        break
    end 
    
    total_length = total_length+sig_length;
end


oh_curve = logical(oh_curve);
oh_square = logical(oh_square);
oh_wn = logical(oh_wn);
%{
pl = 500;
cpr = oh_curve(1:pl);
spr = oh_square(1:pl);
wpr = oh_wn(1:pl);
sig_pr = signal(1:pl);
xpr = 1:pl;
%}
%{
figure(1)
grid on, hold on, box on  
plot(xpr(cpr==1), sig_pr(cpr==1),'o', 'MarkerEdgeColor', 'k')
plot(xpr(spr==1), sig_pr(spr ==1),'o', 'MarkerEdgeColor', 'b')
plot(xpr(wpr==1), sig_pr(wpr ==1),'o', 'MarkerEdgeColor', 'r')
ylim([-5,5])
ylabel('y')
xlabel('t')

%}
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

