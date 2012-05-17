rel_dist=0:0.01:0.5;
for i=1:length(rel_dist)
    prob_dist(i)=4*rel_dist(i)^3;
end
subplot(1,2,1)
plot(rel_dist, prob_dist)
axis([0 0.5 0 0.5])

rel_numb=0:0.01:1;
for i=1:length(rel_numb)
    prob_numb(i)=rel_numb(i)^3;
end
subplot(1,2,2)
plot(rel_numb, prob_numb)