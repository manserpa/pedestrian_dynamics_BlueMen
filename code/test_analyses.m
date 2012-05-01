clc

w = zeros(2,36);
a = w;
ft = a;
fw = ft;
fto = fw;


 for z = 2: 990
w(:,z-1) = pedM_cell{1,z}(velo,1);
nw(z) = norm(w(:,z-1));
a(:,z-1) = pedM_cell{1,z}(acc,1);
na(z) = norm(a(:,z-1));

ft(:,z-1) = 100 * pedM_cell{1,z}(ftarg,1);
nft(z) = norm(ft(:,z-1));
fw(:,z-1) = pedM_cell{1,z}(fwall,1);
nfw(z) = norm(fw(:,z-1));
fto(:,z-1) = pedM_cell{1,z}(ftot,1);
px(z) = pedM_cell{1,z}(pos(1),1);
py(z) = pedM_cell{1,z}(pos(2),1);
 end

 hold on
 plot(nft,'r')
 plot(nfw, 'b')
 legend('nft','nfw')
 
 figure
 hold on
 plot(nw, 'r')
 plot(na, 'b')
 legend('velocity', 'acceleartion')
 
 figure
 hold on
 plot(px , 'r')
 plot(py, 'b')
 legend('x-pos','y-pos')
 