const dbName = 'notes.db';
const dbVersion = 2;
const tableName = 'notes';
//-----------------------columns----------------
const colId = 'note_id';
const colText = 'note_text';
const colDate = 'created_date';
const colUpdatedDate = 'updated_date';
const colColor = 'noteColor';
//-----------------Sql statements
const createTableSql =
    'create table $tableName ($colId integer primary key autoincrement, $colText text, $colDate text)';

const createTableAfterDropSql =
    'create table $tableName ($colId integer primary key autoincrement, $colText text, $colDate text, $colUpdatedDate text, $colColor integer)';
const dropTableSql = 'drop table if exists $tableName';
