%filename = 'testImage.jpg';
%img = importdata(filename);
%image(img);


%importdata('filename')
filename = 'testData.txt';
format = '%f%f%f%s';
[n1, n2, n3, s1] = textread(filename, format);
dataSet = [n1 n2 n3];
