% Script to solve for the gravitational constant given a time vector and
% its assosciated y-positions
% 11/19/2019 ramanzuk

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex'); 

% load that data
whole_data = csvread('ball_trajectories.csv',1,0);
x_train = whole_data(:,1);
y_train = whole_data(:,2);
%training data is two columns; time, and -1/2time^2
x_train = [x_train -0.5*(x_train).^2];

%define the necessary parameters and empty matricies
learning_rate = 0.01;
n_epochs = 10000;
cost = zeros(1,size(x_train,1)*n_epochs);
y_est = zeros(1,size(x_train,1)*n_epochs);
weights = zeros(2,size(x_train,1)*n_epochs + 1);
weights(:,1) = rand(2,1)*30;

%train it
for epoch = 1:n_epochs
    for iter = 1:size(x_train,1)
        y_est((epoch -1)*size(x_train,1) + iter) = dot(x_train(iter,:), weights(:,(epoch -1)*size(x_train,1) + iter));
        cost((epoch -1)*size(x_train,1) + iter) = 0.5*(y_train(iter,:)-y_est((epoch -1)*size(x_train,1) + iter))^2;
        dc_dw = -x_train(iter,:)*(y_train(iter,:)-y_est((epoch -1)*size(x_train,1) + iter));
        weights(:, (epoch -1)*size(x_train,1) + iter +1) = weights(:, (epoch -1)*size(x_train,1) + iter) - learning_rate * transpose(dc_dw);
    end
end
% print out our final weights (the final one should be gravity)
weights(:,end)
%make a figure
simple_fig = figure; 
plot(weights(2,:),'LineWidth',2)
xlabel('Iteration','FontSize',16)
ylabel('Weight','FontSize',16)
title('One Neuron, with $t$ and $-\frac{1}{2}t^2$','FontSize',18)
set(gca,'linewidth',2)
 a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'fontsize',12)
 b = get(gca,'YTickLabel'); 
set(gca,'YTickLabel',b,'fontsize',12)

%okay, so that works
%% can we do it without squaring time?
% training data just the time column this time
x_train = whole_data(:,1);

learning_rate = 0.00001;
n_epochs = 150;
cost = zeros(1,size(x_train,1)*n_epochs);
y_est = zeros(1,size(x_train,1)*n_epochs);
weights = zeros(2,size(x_train,1)*n_epochs + 1);
bias = zeros(1,size(x_train,1)*n_epochs + 1);
weights(:,1) = rand(2,1)*30;
bias(:,1) = rand(1,1)*30;
%train it
for epoch = 1:n_epochs
    for iter = 1:size(y_train,1)
        y_est((epoch -1)*size(x_train,1) + iter) = x_train(iter,:)*weights(1,(epoch -1)*size(x_train,1) + iter)*weights(2,(epoch -1)*size(x_train,1) + iter) + bias(1,(epoch -1)*size(x_train,1) + iter);
        cost((epoch -1)*size(x_train,1) + iter) = 0.5*(y_train(iter,:)-y_est((epoch -1)*size(x_train,1) + iter))^2;
        dc_dw1 = -(y_train(iter,:)*x_train(iter,:) - y_est((epoch -1)*size(x_train,1) + iter))*weights(2,(epoch -1)*size(x_train,1) + iter)*x_train(iter,:);
        dc_dw2 = -(y_train(iter,:)*x_train(iter,:) - y_est((epoch -1)*size(x_train,1) + iter))*weights(1,(epoch -1)*size(x_train,1) + iter)*x_train(iter,:);
        dc_db = -(y_train(iter,:)*x_train(iter,:) - y_est((epoch -1)*size(x_train,1) + iter));
        weights(:, (epoch -1)*size(x_train,1) + iter +1) = weights(:, (epoch -1)*size(x_train,1) + iter) - learning_rate * [dc_dw1;dc_dw2];
        bias(:, (epoch -1)*size(x_train,1) + iter +1) = bias(:, (epoch -1)*size(x_train,1) + iter) - learning_rate * dc_db;
    end
    learning_rate = learning_rate*0.95;
end

%reshape our y-predictions throught training so each column represents a
%single trajectory
y_est = reshape(y_est,size(x_train,1),n_epochs);


%make a figure
two_neuron_fig = figure; 
two_neuron_sfig1 = subplot(2,1,1);
plot(weights','LineWidth',2)
legend('Neuron 1 Weight','Neron 2 Weight')
xlabel('Iteration','FontSize',16)
ylabel('Weight','FontSize',16)
title('Two consecutive neurons, just feed time','FontSize',18)
set(gca,'linewidth',2)
 a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'fontsize',12)
 b = get(gca,'YTickLabel'); 
set(gca,'YTickLabel',b,'fontsize',12)

two_neuron_sfig2 = subplot(2,1,2); 
plot(y_est)
xlabel('time','FontSize',16)
ylabel('height','FontSize',16)
title('evolution of predicted trajectory through training','FontSize',18)
set(gca,'linewidth',2)
 a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'fontsize',12)
 b = get(gca,'YTickLabel'); 
set(gca,'YTickLabel',b,'fontsize',12)
