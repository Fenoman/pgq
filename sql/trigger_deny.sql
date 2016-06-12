\set VERBOSITY 'terse'
set client_min_messages = 'warning';

create or replace function pgq.insert_event(queue_name text, ev_type text, ev_data text, ev_extra1 text, ev_extra2 text, ev_extra3 text, ev_extra4 text)
returns bigint as $$
begin
    raise warning 'insert_event(q=[%], t=[%], d=[%], 1=[%], 2=[%], 3=[%], 4=[%])',
        queue_name, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4;
    return 1;
end;
$$ language plpgsql;

-- create tables with data
create table logutriga_deny (dat1 text primary key);
create table sqltriga_deny (dat1 text primary key);
insert into logutriga_deny values ('a');
insert into sqltriga_deny values ('a');

-- create triggers
create trigger deny_trig after insert or update or delete on logutriga_deny
for each row execute procedure pgq.logutriga('logutriga', 'deny');
create trigger deny_trig after insert or update or delete on sqltriga_deny
for each row execute procedure pgq.sqltriga('sqltriga', 'deny');

-- see what happens
insert into logutriga_deny values ('b');
insert into sqltriga_deny values ('b');
update logutriga_deny set dat1 = 'c';
update sqltriga_deny set dat1 = 'c';
delete from logutriga_deny;
delete from sqltriga_deny;

-- restore
drop table logutriga_deny;
drop table sqltriga_deny;
\set ECHO none
\i functions/pgq.insert_event.sql

