function [power]=CorrIndTestDepend(type,n,d,noise)
%[power]=CorrIndTestDepend(1:20,100,1)
%[power]=CorrIndTestDepend(1:20,100,1,0.2)

if nargin<4
    noise=1;
end
if nargin<3
    d=10;
end
if nargin<2
    n=100;
end
if nargin<1
    type=1:20;
end
% total=20;
power=zeros(max(type),1);
rep=20;
% K=10;
% warning('off','all');
for t=type
    for r=1:rep
%         pcorr=zeros(total,1);
        
        % type=1;
        % n=100;
        % d=10;
        % noise=0.1;
        
        [x,y]=CorrSampleGenerator(t,n,d,1, noise);
        [score,ind]=MGCGeometry(x,y);
%         [~, localCorr, ~]=MGCSampleStat(x,y);
        
        % [~, ~,~,localCorr]=MGCPermutationTest(x,y,rep);
        % localCorr=double(localCorr<0.05);
        %         localCorr=localCorr-mean(mean(localCorr));
        % var1=norm(localCorr,'fro');
        % localCorr=reshape(localCorr,size(localCorr,1)*size(localCorr,2),1);
        %
%         ind2=zeros(K*3,1);
%         for k=1:K
%             pcorr=zeros(total,1);
%             for j=1:total
% %                             [y]=CorrSampleGeneratorX(j,x,0);
%                 [x,y]=CorrSampleGenerator(j,n,d,1, 0.001);
%                 [~, localCorr2, ~]=MGCSampleStat(x,y);
%                 %     [~, ~,~,localCorr2]=MGCPermutationTest(x,y,rep);
%                 %     localCorr2=double(localCorr2<0.05);
%                 %             localCorr2=localCorr2-mean(mean(localCorr2));
%                 %     var2=norm(localCorr2,'fro');
%                 %     localCorr2=reshape(localCorr2,size(localCorr2,1)*size(localCorr2,2),1);
%                 %     pcorr(j)=sum(sum(localCorr.*localCorr2))/var1/var2;
%                 pcorr(j)=DCorr(localCorr,localCorr2);
%                 %     pcorr(j)=MGCSampleStat(localCorr,localCorr2);
%                 %     pcorr(j)=corr(localCorr,localCorr2,'Spearman');
%             end
%             [~,ind]=sort(pcorr,'descend');
%             ind2(k)=ind(1);
%             ind2(K+k)=ind(2);
%              ind2(2*K+k)=ind(3);
%         end
%         [~,ind2]=hist(ind2,unique(ind2));
        ind2=find(ind==t);
% mode(ind2)
%         if (mode(ind2)==t)
        if (ind2<=2)
            power(t)=power(t)+1/rep;
        end
    end
end

% fpath = mfilename('fullpath');
% fpath=strrep(fpath,'\','/');
% findex=strfind(fpath,'/');
% rootDir=fpath(1:findex(end-2));
% addpath(genpath(strcat(rootDir,'Code/')));
% pre1=strcat(rootDir,'Data/Results/'); % The folder to locate data
% pre2=strcat(rootDir,'Figures/Fig');% The folder to save figures

% MGC=[0,1,0];
% fontSize=18;
% plot(type,power,'.','color',MGC,'markersize',20)
% set(gca,'FontSize',fontSize);
% title('Accuracy of Classifying Dependency','FontSize',fontSize+7);
% xlim([1,20]);
% ylim([0,1]);
% xlabel('Simulation Type');
% ylabel('Accuracy')

% figNumber='1DPowerSummarySize';
% F.fname=strcat(pre2,figNumber);
% F.wh=[4.5 3]*2;
% print_fig(gcf,F)


% function [y]=CorrSampleGeneratorX(type,x,noise)
% %4,5,8,16,17
% [n,dim]=size(x);
% 
% eps=mvnrnd(0,1,n); % Gaussian noise added to Y
% 
% % High-dimensional decay
% A=ones(dim,1);
% %A=A./(ceil(dim*rand(dim,1))); %random decay
% for d=1:dim
%     A(d)=A(d)/d; %fixed decay
% end
% d=dim;
% 
% % % Generate x by uniform distribution first, which is the default distribution used by many types; store the weighted summation in xA.
% % x=unifrnd(-1,1,n,d);
% xA=x*A;
% % % Generate x independently by uniform if the null hypothesis is true, i.e., x is independent of y.
% % if dependent==0
% %     x=unifrnd(-1,1,n,d);
% % end
% 
% switch type % In total 20 types of dependency + the type 0 outlier model
%     case 1 %Linear
%         y=xA+1*noise*eps;
%     case 2 %Exponential
% %         x=unifrnd(0,3,n,d);
%         y=exp(x*A)+10*noise*eps;
% %         if dependent==0
% %             x=unifrnd(0,3,n,d);
% %         end
%     case 3 %Cubic
%         y=128*(xA-1/3).^3+48*(xA-1/3).^2-12*(xA-1/3)+80*noise*eps;
%     case 4 %Joint Normal; note that dim should be no more than 10 as the covariance matrix for dim>10 is no longer positive semi-definite
%         rho=1/(d*2);
%         cov1=[eye(d) rho*ones(d)];
%         cov2=[rho*ones(d) eye(d)];
%         covT=[cov1' cov2'];
%         x=mvnrnd(zeros(n,2*d),covT,n);
%         y=x(:,d+1:2*d)+0.5*noise*repmat(eps,1,d);
% %         if dependent==0
% %             x=mvnrnd(zeros(n,2*d),covT,n);
% %         end
%         x=x(:,1:d);
%     case 5 %Step Function
%         if dim>1
%             noise=1;
%         end
%         y=(xA>0)+1*noise*eps;
%     case 6 %Quadratic
%         y=(xA).^2+0.5*noise*eps;
%     case 7 %W Shape
%         y=4*( ( xA.^2 - 1/2 ).^2 + unifrnd(0,1,n,d)*A/500 )+0.5*noise*eps;
%     case 9 %Uncorrelated Binomial
%         if d>1
%             noise=1;
%         end
% %         x=binornd(1,0.5,n,d)+0.5*noise*mvnrnd(zeros(n,d),eye(d),n);
%         y=(binornd(1,0.5,n,1)*2-1);
%         y=x*A.*y+0.5*noise*eps;
% %         if dependent==0
% %             x=binornd(1,0.5,n,d)+0.5*noise*mvnrnd(zeros(n,d),eye(d),n);
% %         end
%     case 10 %Log(X^2)
% %         x=mvnrnd(zeros(n, d),eye(d));
%         y=log(x.^2)+3*noise*repmat(eps,1,d);
% %         if dependent==0
% %             x=mvnrnd(zeros(n, d),eye(d));
% %         end
%     case 11 %Fourth root
%         y=abs(xA).^(0.25)+noise/4*eps;
%     case {8,16,17} %Circle & Ecllipse & Spiral
%         if d>1
%             noise=1;
%         end
%         cc=0.4;
%         if type==16
%             rx=ones(n,d);
%         end
%         if type==17
%             rx=5*ones(n,d);
%         end
% 
%         if type==8
%             rx=unifrnd(0,5,n,1);
%             ry=rx;
%             rx=repmat(rx,1,d);
%             z=rx;
%         else
%             z=unifrnd(-1,1,n,d);
%             ry=ones(n,1);
%         end
%         x(:,1)=cos(z(:,1)*pi);
%         for i=1:d-1;
%             x(:,i+1)=x(:,i).*cos(z(:,i+1)*pi);
%             x(:,i)=x(:,i).*sin(z(:,i+1)*pi);
%         end
%         x=rx.*x;
%         y=ry.*sin(z(:,1)*pi);
%         if type==8
%             y=y+cc*(dim)*noise*mvnrnd(zeros(n, 1),eye(1));
%         else
%             x=x+cc*noise*rx.*mvnrnd(zeros(n, d),eye(d));
%         end
% %         if dependent==0
% %             if type==8
% %                 rx=unifrnd(0,5,n,1);
% %                 rx=repmat(rx,1,d);
% %                 z=rx;
% %             else
% %                 z=unifrnd(-1,1,n,d);
% %             end
% %             x(:,1)=cos(z(:,1)*pi);
% %             for i=1:d-1;
% %                 x(:,i+1)=x(:,i).*cos(z(:,i+1)*pi);
% %                 x(:,i)=x(:,i).*sin(z(:,i+1)*pi);
% %             end
% %             x=rx.*x;
% %             if type==8
% %             else
% %                 x=x+cc*noise*rx.*mvnrnd(zeros(n, d),eye(d));
% %             end
% %         end
%     case {12,13} %Sine 1/2 & 1/8
% %         x=repmat(unifrnd(-1,1,n,1),1,d);
% %         if noise>0 || d>1
% %             x=x+0.02*(d)*mvnrnd(zeros(n,d),eye(d),n);
% %         end
%         if type==12
%             theta=4;cc=1;
%         else
%             theta=16;cc=0.5;
%         end
%         y=sin(theta*pi*x)+cc*noise*repmat(eps,1,d);
% %         if dependent==0
% %             x=repmat(unifrnd(-1,1,n,1),1,d);
% %             if noise>0 || d>1
% %                 x=x+0.02*(d)*mvnrnd(zeros(n,d),eye(d),n);
% %             end
% %         end
%     case {14,18} %Square & Diamond
%         u=repmat(unifrnd(-1,1,n,1),1,d);
%         v=repmat(unifrnd(-1,1,n,1),1,d);
%         if type==14
%             theta=-pi/8;
%         else
%             theta=-pi/4;
%         end
%         eps=0.05*(d)*mvnrnd(zeros(n,d),eye(d),n);
% %         x=u*cos(theta)+v*sin(theta)+eps;
%         y=-u*sin(theta)+v*cos(theta);
% %         if dependent==0
% %             u=repmat(unifrnd(-1,1,n,1),1,d);
% %             v=repmat(unifrnd(-1,1,n,1),1,d);
% %             eps=0.05*(d)*mvnrnd(zeros(n,d),eye(d),n);
% %             x=u*cos(theta)+v*sin(theta)+eps;
% %         end
%     case 15 %Two Parabolas
%         y=( xA.^2  + 2*noise*unifrnd(0,1,n,1)).*(binornd(1,0.5,n,1)-0.5);
%     case 19 %Multiplicative Noise
% %         x=mvnrnd(zeros(n, d),eye(d));
%         y=mvnrnd(zeros(n, d),eye(d));
%         y=x.*y;
% %         if dependent==0
% %             x=mvnrnd(zeros(n, d),eye(d));
% %         end
%     case 20 %Independent clouds
% %         x=mvnrnd(zeros(n,d),eye(d),n)/3+(binornd(1,0.5,n,d)-0.5)*2;
%         y=mvnrnd(zeros(n,d),eye(d),n)/3+(binornd(1,0.5,n,d)-0.5)*2;
% end