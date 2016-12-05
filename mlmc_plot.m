%
% utility to generate MLMC plots based on input text file
%
% mlmc_plot(filename,nvert)
%

function mlmc_plot(filename,nvert)

close all;

%
% read in data
%

fid = fopen([filename '.txt'],'r');

line = '    ';
while (length(line)<20) | (strcmp(line(1),'-')==0)
  line = [ fgetl(fid) '    ' ];
end

line = fgetl(fid);
l    = 1;
while (length(line)>10)
  data = sscanf(line,'%f');
  del1(l) = data(2);
  del2(l) = data(3);
  var1(l) = data(4);
  var2(l) = data(5);
  kur1(l) = data(6);
  chk1(l) = data(7);
  cost(l) = data(8);

  line = fgetl(fid);
  l    = l+1;
end

L = l-2;

line = '    ';
while (length(line)<20) | (strcmp(line(1),'-')==0)
  line = [ fgetl(fid) '    ' ];
end

line = fgetl(fid);
l    = 1;

while (length(line)>10)
  data = sscanf(line,'%f');
  Eps(l)       = data(1);
  mlmc_cost(l) = data(3);
  std_cost(l)  = data(4);
  len          = length(data)-5;
  ls(1:len,l)  = 0:len-1;
  Nls(1:len,l) = data(6:end);

  line = fgetl(fid);
  l    = l+1;
end

%
% plot figures
%

figs(1) = figure; 
pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[1.0 0.75*nvert]; set(gcf,'pos',pos);

set(0,'DefaultAxesColorOrder',[0 0 0]);
set(0,'DefaultAxesLineStyleOrder','-*|--*')

subplot(nvert,2,1)
plot(0:L,log2(var2),1:L,log2(var1(2:end)))
xlabel('level l'); ylabel('log_2 variance');
current = axis; axis([ 0 L current(3:4) ]);
legend('P_l','P_l- P_{l-1}','Location','SouthWest')

subplot(nvert,2,2)
plot(0:L,log2(abs(del2)),1:L,log2(abs(del1(2:end))))
xlabel('level l'); ylabel('log_2 |mean|');
current = axis; axis([ 0 L current(3:4) ]);
legend('P_l','P_l- P_{l-1}','Location','SouthWest')

if nvert==3
  subplot(3,2,3)
  %  plot(1:L,chk1(2:end),'--*')
  %  xlabel('level l'); ylabel('consistency check');
  plot(0:L,log2(cost(1:end)),'--*')
  xlabel('level l'); ylabel('log_2 cost per sample');
  current = axis; axis([ 0 L current(3:4) ]);

  subplot(3,2,4)
  plot(1:L,kur1(2:end),'--*')
  xlabel('level l'); ylabel('kurtosis');
  current = axis; axis([ 0 L current(3:4) ]);
end

if nvert==1
  figs(2) = figure;
  pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[1.0 0.75]; set(gcf,'pos',pos);
end


set(0,'DefaultAxesLineStyleOrder','--o|--x|--d|--*|--s');

subplot(nvert,2,2*nvert-1)
semilogy(ls, Nls)
xlabel('level l'); ylabel('N_l');
current = axis; axis([ 0 size(Nls,1)-1 current(3:4) ]);
for i=1:length(Eps)
  labels{i} = num2str(Eps(i));
end
legend(labels,'Location','NorthEast')

set(0,'DefaultAxesLineStyleOrder','-*|--*')

subplot(nvert,2,2*nvert)
loglog(Eps,Eps.^2.*std_cost(:)', Eps,Eps.^2.*mlmc_cost(:)')
xlabel('accuracy \epsilon'); ylabel('\epsilon^2 Cost');
current = axis; axis([ Eps(1) Eps(end) current(3:4) ]);
legend('Std MC','MLMC')
