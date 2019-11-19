%% How to train a single neuron to figure out the cost of groceries
% ACM 11.18.2019

% load trainging data from Ryan
[Tn,Ts,Tt] = xlsread('grocery_training_data.xlsx');

% true cost of groceries after each shop (rows)
y = Tn(:,end);

% amounts of each food (columns) during each shop (rows)
a = Tn(:,1:end-1);

% initialize a random set of weights (or prices for each item) and create the 
% neuron's estimate for the grocery bill total (the weighted sum).
w = rand(size(a,2),1);

% choose number of epochs (iterations) to run the model
n = 1000;

% set a learning rate (arbitrary step size toward minima in dCdw)
lr=0.00001;

% clear some variables to avoid errors with the loop
clear C ma

for i = 1:n
  % predict total grocery costs given amount data (a) and weightings from
  % previous step (w)
    ypred = a * w;
  % cost function from https://towardsdatascience.com/power-of-a-single-neuron-perceptron-c418ba445095
    C(i) = 0.5 * sum((y - ypred).^2);
  % mean accuracy
    ma(i) = mean(abs(y-ypred));
  % gradient (derivative of cost function wrt each weight), which we want
  % to be equal to zero
   dCdw = -a.' * (y - ypred);
  % new weights computed by taking small steps toward the dCdw minima
  % (which means the opposite direction of the gradient) -- thus, 'gradient
  % descent'
   w = w - lr*dCdw;
end

% Make a figure
figure (1)
clf
hold on
grid on
plot(1:1:n,C,'-b','LineWidth',2)
p2 = plot(find(ma<0.01,1),C(find(ma<0.01,1)),'bd','MarkerFaceColor','w','MarkerSize',12);
legend([p2],sprintf('Mean Absolute Error < $0.01 @epoch %i',find(ma<0.01,1)))
xlabel('Epoch')
ylabel(sprintf('Cost Function: %s','$\frac{1}{2}\sum_{i=1}^n(y_i - \hat{y_i})^2$'),'Interpreter','latex')
set(gca,'YScale','log','FontSize',14)
axis tight
hold off