function struct2csv(s,fn,address)
% STRUCT2CSV(s,fn)
%
% Output a structure to a comma delimited file with column headers
%
%       s : any structure composed of one or more matrices and cell arrays
%      fn : file name
%
%      Given s:
%
%          s.Alpha = { 'First', 'Second';
%                      'Third', 'Fourth'};
%
%          s.Beta  = [[      1,       2;
%                            3,       4]];
%
%      STRUCT2CSV(s,'any.csv') will produce a file 'any.csv' containing:
%
%         "Alpha",        , "Beta",
%         "First","Second",      1,  2
%         "Third","Fourth",      3,  4
%
% Written by James Slegers, james.slegers_at_gmail.com
% Covered by the BSD License
%

if nargin<3||isempty(address)
    FID = fopen(fn,'a');
    headers = fieldnames(s);
    m = length(headers);
    
    l = '';
    for ii = 1:m
        sz(ii,:) = size(getfield(s,headers{ii}));
        if ii==m
           l = [l,headers{ii}]; % l = [l,'"',headers{ii},'"'];
        else
            l = [l,headers{ii},','];   % l = [l,'"',headers{ii},'",'];
        end
        if sz(ii,2)>1
            for jj = 2:sz(ii,2)
                l = [l,','];
            end
        end
    end
    l = [l,'\n'];
    fprintf(FID,l);
    n = max(sz(:,1));
    for ii = 1:n
        l = '';
        for jj = 1:m
            for kk = 1:sz(jj,2)
                if sz(jj,1)<ii
                    str = [','];
                else
                    c = getfield(s,headers{jj});
                    if isnumeric(c)
                        if jj==m
                            str = [num2str(c(ii,kk),'%.6f')];
                        else
                            str = [num2str(c(ii,kk),'%.6f'),','];
                        end
                    else
                       str = [c{ii,kk},',']; % str = ['"',c{ii,kk},'",'];
                    end
                end
                l = [l,str];
            end
        end
        l = [l,'\n'];
        fprintf(FID,l);
    end
    fclose(FID);
    
else
    FID = fopen(fn,'a');
    headers = fieldnames(s);
    m = length(headers);
    
    l=['# cfgfile =',address];
    fprintf(FID,l);
    l='\n';
    fprintf(FID,l);
    
    l = ',';% l = '"",';
    for ii = 1:m
        
        sz(ii,:) = size(getfield(s,headers{ii}));
        if ii==m
            l = [l,headers{ii}];    % l = [l,'"',headers{ii},'"'];
        else
            l = [l,headers{ii},','];   % l = [l,'"',headers{ii},'",'];
        end
        if sz(ii,2)>1
            for jj = 2:sz(ii,2)
                l = [l,','];
            end
        end
    end
    l = [l,'\n'];
    fprintf(FID,l);
    
    n = max(sz(:,1));
    
    for ii = 1:n
        l = [num2str(ii-1),','];
        for jj = 1:m
            for kk = 1:sz(jj,2)
                if sz(jj,1)<ii
                    str = [','];
                else
                    c = getfield(s,headers{jj});
                    if isnumeric(c)
                        if jj==m
                            str = [num2str(c(ii,kk),'%.6f')];
                        else
                            str = [num2str(c(ii,kk),'%.6f'),','];
                        end
                    else
                        str = [c{ii,kk},','];% str = ['"',c{ii,kk},'",'];
                    end
                end
                l = [l,str];
            end
            
        end
        l = [l,'\n'];
        fprintf(FID,l);
    end
    fclose(FID);
end
end
