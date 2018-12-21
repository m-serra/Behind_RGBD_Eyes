%%
%This is ramdisk on unix - to load files very fast!
% rambase1='/run/shm/baseseq';
% rambase2='/run/shm/seqtomatch';
% ramtrain='/run/shm/trainseq';
% if ~exist(rambase1),
%     unix(['mkdir ' rambase1]);
%     unix(['mkdir ' rambase2]);
%     unix(['mkdir ' ramtrain]);
% else,
%     try,
%     unix(['rm ' rambase1 '/*']);
%     unix(['rm ' rambase2 '/*']);
%     unix(['rm  ' ramtrain '/*']);
%     catch,
%     end;
% end
%Sequencias - se for para correr só uma define aqui!
%senao usa readseqs.m
%
%dirbase='/mnt/twindisk/piv/data/labseq/seq1';
%trainseq=dirbase;
%dirtarget='/mnt/twindisk/piv/data/labseq/seq2';

%unix(['cp ' dirbase '/* ' rambase1]);
%unix(['cp ' dirtarget '/* ' rambase2]);
%unix(['cp ' trainseq '/* ' ramtrain]);

%d1=dir([rambase1 '/*.jpg']);
%d2=dir([rambase2 '/*.jpg']);
%d3=dir([trainseq '/*.jpg']);

%% IMAGE DATASET, LIST OF FILES

base_data_dir='../Behind_RGBD_Eyes/datasets/lab1/';
d1=dir([base_data_dir 'depth1*']);
d2=dir([base_data_dir 'depth2*']);
r1=dir([base_data_dir 'rgb_image1_*']);
r2=dir([base_data_dir 'rgb_image2_*']);
base_data_dir=strcat('../',base_data_dir);
for i=1:length(d1)
    im1(i).rgb=[base_data_dir r1(i).name];
    im2(i).rgb=[base_data_dir r2(i).name];
    im1(i).depth=[base_data_dir d1(i).name];
    im2(i).depth=[base_data_dir d2(i).name];
end
%load calibration data
load cameraparametersAsus;
%WORKING DIRECTORY - location where all directories with programs 
basedir=pwd;
projs=dir(basedir);
% LOGFILE
outputdir='lab1/';
fichlog=['lab1/output.html'];
%PROTECT DATA AGAINST CLEAR inside students code
save dados2;
texto = {};
caminho = {};
%% RUN THE PROJECTS
try,%%%IF possible run in parallel
%    parfor i=3:length(projs),
    for i=3:length(projs),
        close all; %close all windows that were left open!!!!
        if projs(i).isdir&& ~strcmp(projs(i).name,'.')&& ~strcmp(projs(i).name , '..'),
            cd([basedir '/' projs(i).name]);
            fprintf('running project %s \n',pwd);
            if exist('track3D_part2.m'),
                corre='[objects, cam2toW] = track3D_part2( im1, im2,   cam_params);';
                    %YOUR CODE MUST RUN THIS PART
                    h=tic;
                    eval(corre);
                    tt=toc(h);
                    out=cell(2,1);
                    fprintf(' Run ok \n');
                    texto=[texto [{projs(i).name};{sprintf('OK - Correu ate ao fim em - %d Segundos',tt)}]];
                    out{1}=objects;
                    out{2}=cam2toW;
                    caminho=[caminho out];
            else
               texto=[texto [{projs(i).name};{sprintf('ERROR - File track3D_part2.m inexistant  ')}]];
               caminho=[caminho cell(3,1)];
                     
            end          
            cd(basedir)
        end
    end
catch
    cd(basedir)
    save dadoscrash
    fprintf('Deu asneira no loop \n');
    return;
end
save dados2
%% FOR ALL THOSE THAT RUN WELL SHOW OUTPUT
colors=nchoosek((0:.2:1),3);
load cameraparametersAsus.mat
for i=1:size(texto,2),
    fprintf('Project %s - %s \n',texto{1,i})
    if strcmp(texto{2,i}(1:2),'OK'),
       obj=caminho{1,i};
       objsinframe=zeros(length(obj),length(im1));
       for j=1:length(obj),
           for k=1:length(obj(j).frames_tracked),
               objsinframe(j,obj(j).frames_tracked(k))=1;
           end
       end
       R1=caminho{2,i}.R;
       T1=caminho{2,i}.T;
       R2=caminho{3,i}.R;
       T3=caminho{3,i}.T;       
       for j=1:length(im1),           
           load(im1(j).depth);
           xyz1=get_xyzasus(depth_array(:),[480 640],(1:640*480)', cam_params.Kdepth,1,0);
           load(im2(j).depth);
           xyz2=get_xyzasus(depth_array(:),[480 640],(1:640*480)', cam_params.Kdepth,1,0);
           xyz=[(R1*xyz1'+repmat(T1,[1,640*480]))';(R2*xyz2'+repmat(T2,[1,640*480]))'];
           pc=pointCloud([xyz(:,1) xyz(:,2) xyz(:,3)]);
           figure(1);
           showPointCloud(pc);
           view([.2 -.2 .05]);
           hold on;
           indsob=find(objsinframe(:,j));
           for k=1:length(indsob),
               ind=find(obj(indsob(k)).frames_tracked==j);
               combs=combnk((1:8),2)';
               xs=obj(indsob(k)).X(ind,:);
               ys=obj(indsob(k)).Y(ind,:);
               zs=obj(indsob(k)).Z(ind,:);
               line([xs(combs(1,:));xs(combs(2,:))],[ys(combs(1,:));ys(combs(2,:))],[zs(combs(1,:));zs(combs(2,:))],'LineWidth',2);
           end
           hold off;
           pause;
       end
    end
end
%CREATE WEBPAGE
log=fopen(fichlog,'w');
fprintf(log,'<!doctype html public "-//W3C//DTD HTML 4.0 //EN"> <html><head><title>PIV 2017- PART 1</title>');
fprintf(log,'<head><STYLE TYPE="text/css"> \n<!-- \n TD{font-family: Arial; font-size: 10pt;} \n ---> \n ');
fprintf(log,'</STYLE></head><body></head><body><table border=1>\n');

%%
nimgslinha=12; %imagens por cada linha no output
textT='';textI='';textJ='';
for i=1:length(T),
    textT=[textT ' <img src=' d3(i).name ' height=60 width=80> '];
    imwrite(imresize(imread(T{i}),[60 80]), [outdir '/' d3(i).name],'jpg');
end
for i=1:length(A),
    textI=[textI ' <img src=' d1(i).name ' height=60 width=80> '];
    imwrite(imresize(imread(A{i}),[60 80]), [outdir '/' d1(i).name],'jpg');
end
for i=1:length(B),
    textJ=[textJ ' <img src=' d2(i).name ' height=60 width=80> '];
    imwrite(imresize(imread(B{i}),[60 80]), [outdir '/' d2(i).name],'jpg');
end

fprintf(log,'<tr bgcolor=#FF8000><td >Treino %s</tr>\n',textT);
fprintf(log,'<tr bgcolor=#FF8000><td >Base %s</tr>\n',textI);
fprintf(log,'<tr bgcolor=#FF8000><td >Target %s</tr>\n',textJ);

for i=1:length(projs),
    if  ~isempty(texto{i}),
        fprintf(log,'<tr bgcolor=#0FFF00><td >%d - %s - %s</td></tr>\n',i,projs(i).name,texto{i});
        linhabase='';
        linhatarget='';
        web='';
        try,
            for j=1:size(caminho{i},1),
                if rem(j,nimgslinha)==0,
                    linhabase=[linhabase ' <img src=' d1(caminho{i}(j,1)).name ' height=60 width=80> '];
                    linhatarget=[linhatarget ' <img src='  d2(caminho{i}(j,2)).name ' height=60 width=80> '];
                    %fprintf(log,'<tr><td><table frame="box"><tr><td>%s</tr><tr><td>%s</table>',linhabase,linhatarget);
                    %fprintf(log,'<tr><td>%s</tr><tr><td>%s</tr>',linhabase,linhatarget);
                    web=[web '<tr><td><table frame="box"><tr><td>I<td>' linhabase '<tr><td>J<td>' linhatarget '</table>'];
                    linhabase='';linhatarget='';
                else
                    linhabase=[linhabase ' <img src=' d1(caminho{i}(j,1)).name ' height=60 width=80> '];
                    linhatarget=[linhatarget ' <img src='  d2(caminho{i}(j,2)).name  ' height=60 width=80> '];
                end
            end
            web=[web '<tr><td><table frame="box"><tr><td>I<td>' linhabase '<tr><td>J<td>' linhatarget '</table></tr>'];        fprintf(log,'<tr><td><table frame="box"><tr><td>I<td>%s</tr><tr><td>J<td>%s</table></tr>',linhabase,linhatarget);
        catch erro,
            web=[web sprintf('<tr><td><table frame="box"><tr><td>I<td>%s</tr><tr><td>J<td>%s<tr><td>ERRO NA SAIDA (dysplay da atriz M) - %s - %s</tr></table></tr>',linhabase,linhatarget,erro.identifier,erro.message)];
        end
        fprintf(log,web);
    end
end
cd(currdir);
fprintf(log,'</table></body></html>');
fclose(log);
fprintf('done')

