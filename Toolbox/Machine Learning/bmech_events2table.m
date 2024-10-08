function table_event = bmech_events2table(fld,ch,event,subjects,Conditions)

% BMECH_EVENTS2TABLE(fld,ch,event,subjects,Conditions) extracts local events to 
% tabular form
% ARGUMENTS
%   fld         ...   string, folder to operate on
%   ch          ...   cell array of strings, channel names 
%   event       ...   cell array of strings, event names associated to each channel 
%   subjects    ...   string cell, subject name of all the subjects. 
%   Conditions  ...   string cell, all Conditions name. 
% 
% RETURNS
%   table_event ...  Table of events with subjects second last row and conditions last row.
%                    If event does not exisit it will be 999.
%
% see also bmech_line2table

fl=engine('path',fld,'ext','.zoo');
table_event=emptytable(fl,ch,event);
row=1;
for s=1:length(subjects)
    fls=fl(contains(fl,subjects{s}));
    for c=1:length(Conditions)
        flc=fls(contains(fls,Conditions{c}));
        for i=1:length(flc)
            data=zload(flc{i});
            disp(['extracting events for ', subjects{s},' ', Conditions{c},' trial ',num2str(i)])
            table_event=event_extract(table_event,data,row,ch,event);
            table_event.Subject(row)={subjects{s}};
            table_event.Conditions(row)={Conditions{c}};
            row=row+1;
        end
    end
end

function  table_event=event_extract(table_event,data,row,ch,event)
for ii=1:length(ch)
    for jj=1:length(event)
        event_name=[ch{ii},'_',event{jj}];
        ename=fieldnames(data.(ch{ii}).event);
        con=contains(ename,event{jj});
        if sum(con)>0
            table_event.(event_name)(row)=data.(ch{ii}).event.(event{jj})(3);
        else
            table_event.(event_name)(row)=999; %if event does not exisit
            disp(['event does not exist for ',ch{ii},' ',event{jj}]);
        end
    end
end

