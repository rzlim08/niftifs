
for i = 1:size(c,1)
d = batch_parfor(fs, @get_scan, c(i).subject_runs(:,2))';
f = figure;
for j = 1:size(d,1)
    subplot(2,2,j);
    ts = mean(d{j,1},2);
    plot(ts);
end
saveas(f, ['~/niftifs/p' num2str(i) '.jpg']);
end