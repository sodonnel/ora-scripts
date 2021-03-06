-- &&1 is object

set echo off
set verify off
set pages 250
set lines 250


col data_type for a20
col column_name for a30
col partition_columns for a60

accept table prompt 'Table Name: '
accept schema prompt 'Schema: '

PROMPT TABLE INFORMATION

select a.column_name, 
       a.data_type, 
       a.data_length, 
       a.data_precision, 
       a.nullable, 
       case when b.column_name is not null then '*' else null end partitioned_column
from all_tab_columns a, 
     all_part_key_columns b 
where a.table_name = upper('&&table')
and a.owner = nvl(upper('&&schema'), a.owner)
and a.owner = b.owner(+)
and a.table_name = b.name(+)
and a.column_name = b.column_name(+);


PROMPT
PROMPT
PROMPT INDEXES

break on index_name skip 2 on report

select a.index_name, decode(b.uniqueness, 'NONUNIQUE', 'N', 'Y') uniq, b.partitioned, a.column_name, a.column_position, b.status
from all_ind_columns a, all_indexes b
where a.table_name = upper('&&table')
and a.table_owner = nvl(upper('&&schema'), a.table_owner)
and a.index_owner = b.owner
and a.index_name  = b.index_name
order by a.index_name asc, a.column_position asc;

set verify on

undefine table
undefine schema
