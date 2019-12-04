%% script to find gravitational constant from ball tosses
% ACM 12.02.2019

%% load data
D = xlsread('ball_trajectories.xlsx');

x = D(:,1); %time
y = D(:,2); %true, measured height

%% setup two neurons, hoping one estimates gravity, and the other the initial velocity and launch angle
%because we know the equation should be h = 0.5*gt^2 + v0*t*sin(theta)
% %% https://en.wikipedia.org/wiki/Projectile_motion

% number of epochs
n = 5e6;

% set a learning rate (arbitrary step size toward minima in dCdw)
lr=0.000001;

%initialize weights for one neuron in each of two layers
w1 = rand(length(x),1);
w2 = rand(length(x),1);


%%
clear C ma

tic
for i = 1:n
 %for j = 1:length(x)
  % predict height given amount time has passed and weightings from
  % previous step (w). 
  
  % this is the output from the first layer, which hopefully will predict
  % gravity
    y1 = w1 .* x.^2;
  % now do the second layer, which hopefully will predict sin of
  % the launch angle
    y2 = w2 .* x;
  % the predicted ballistic height
    ypred(:,i) = y1 + y2;
  % cost function from https://towardsdatascience.com/power-of-a-single-neuron-perceptron-c418ba445095
    C(i) = 0.5 * sum((y - ypred(:,i)).^2);
  % mean accuracy
    ma(i) = mean(abs(y-ypred(:,i)));
  % gradient (derivative of cost function wrt each weight), which we want
  % to be equal to zero
   dCdw1 = (-x.^2)' * (y - ypred(:,i));
   dCdw2 = (-x)' * (y - ypred(:,i));
  % new weights computed by taking small steps toward the dCdw minima
  % (which means the opposite direction of the gradient) -- thus, 'gradient
  % descent'
%   if j<length(x)
    w1 = w1 - lr*dCdw1;
    w2 = w2 - lr*dCdw2;
%   elseif j==length(x)
%    w1(1,i+1) = w1(j,i) - lr*dCdw1(j,i);
%    w2(1,i+1) = w2(j,i) - lr*dCdw2(j,i);
%   end
%  end
end

tt = toc;

%% fit a curve the normal way
[p,S] = polyfit(x,y,2);

xx = linspace(min(x),max(x),1000);
yy = polyval(p,x);
 yyssr = sum((yy-y).^2);
yp = polyval([mean(w1) mean(w2) 0],x);
 ypssr = sum((yp-y).^2);

%% Make a figure
figure (1)
clf
subplot(1,2,1)
hold on
grid on
plot(1:1:n,C,'-b','LineWidth',2)
xlabel('Epoch')
ylabel(sprintf('Cost Function: %s','$\frac{1}{2}\sum_{i=1}^n(y_i - \hat{y_i})^2$'),'Interpreter','latex')
title(sprintf('Elapsed time = %3.0f seconds',tt))
set(gca,'YScale','log','FontSize',14)
axis tight
hold off

subplot(1,2,2)
hold on
grid on
pl2 = plot(x,yy,'-k','LineWidth',2);
pl3 = plot(x,yp,'--b','LineWidth',2);
pl1 = plot(x,y,'ro');
xlabel('time')
ylabel('standardized height of ball')
title('should be h = 0.5gt^2 + v_0sin(\theta)t')
legend([pl1,pl2,pl3],'Data',sprintf('Polyfit (SSR=%3.2f): h = %3.2ft^2 + %3.2ft + %3.2f',yyssr,p(1),p(2),p(3)),...
    sprintf('2-Layer NN (SSR=%3.2f): h = %3.2ft^2 + %3.2ft',ypssr,mean(w1),mean(w2)),'FontSize',14,'Location','SouthWest')
set(gca,'FontSize',14)
axis tight
hold off