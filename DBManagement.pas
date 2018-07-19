unit DBManagement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, mysql50conn;

const
HOSTNAME : string = 'localhost';
DATABASE : string = 'ujicoba';
USERNAME : string = 'root';
PASSWORD : string = '';

type
  TDataPersonal = record
  no,id,nama,alamat : Array of String;
end;

var
  query       : TSQLQuery;
  transaction : TSQLTransaction;
  data        : TStrings;
  personal    : TDataPersonal;
  conn        : TMySQL50Connection;

function Koneksi():TMySQL50Connection;
function AmbilData():TDataPersonal;
function SimpanData(nama:string;alamat:string):Boolean;
function HapusData(idx:string):Boolean;
function GetById(idx:string): TStrings;
function UpdateData(nama:string;alamat:string;idx:string):Boolean;

implementation

function Koneksi: TMySQL50Connection;
begin
  Result:=nil;
  conn := TMySQL50Connection.Create(nil);
  transaction := TSQLTransaction.Create(nil);
  try
    conn.HostName     := HOSTNAME;
    conn.UserName     := USERNAME;
    conn.Password     := PASSWORD;
    conn.DatabaseName := DATABASE;
    conn.Connected    := True;
    conn.Transaction  := transaction;
  except
    exit;
  end;
  Result:=conn;
end;

function AmbilData(): TDataPersonal;
var
  i : integer;
begin
  query := TSQLQuery.Create(nil);
  try
   query.sql.Clear;
   query.DataBase := Koneksi;
   query.SQL.Text := 'select * from percobaan';
   query.Open;
   query.First;
   SetLength(personal.no, query.RecordCount);
   SetLength(personal.id, query.RecordCount);
   SetLength(personal.nama, query.RecordCount);
   SetLength(personal.alamat, query.RecordCount);
   with query do begin
   for i := 0 to query.RecordCount-1 do begin
       personal.no[i]    :=IntToStr(i);
       personal.id[i]    :=FieldByName('id').AsString;
       personal.nama[i]  :=FieldByName('nama').AsString;
       personal.alamat[i]:=FieldByName('alamat').AsString;
   Next;
   end;
   end;
  except
    exit;
  end;
  Result:=personal;
end;

function SimpanData(nama:string;alamat:string): Boolean;
begin
  Result:=False;
  query := TSQLQuery.Create(nil);
  try
   query.sql.Clear;
   query.DataBase := Koneksi;
   query.SQL.Text := 'insert into percobaan (nama,alamat) values ("'+nama+'","'+alamat+'")';
   query.ExecSQL;
   transaction.Commit;
  except
    exit;
  end;
  Result:=True;
end;

function HapusData(idx:string): Boolean;
begin
  Result:=False;
  query := TSQLQuery.Create(nil);
  try
   query.sql.Clear;
   query.DataBase := Koneksi;
   query.SQL.Text := 'delete from percobaan where id="'+idx+'"';
   query.ExecSQL;
   transaction.Commit;
  except
    exit;
  end;
  Result:=True;
end;

function GetById(idx:string): TStrings;
begin
  Result:=nil;
  query := TSQLQuery.Create(nil);
  data  := TStringList.Create;
  try
   query.sql.Clear;
   query.DataBase := Koneksi;
   query.SQL.Text := 'select * from percobaan where id="'+idx+'"';
   query.Open;
   query.First;
   data.Values['nama']   := query.FieldByName('nama').AsString;
   data.Values['alamat'] := query.FieldByName('alamat').AsString;
  except
    exit;
  end;
  Result:=data;
end;

function UpdateData(nama: string; alamat: string; idx: string): Boolean;
begin
  Result:=False;
  query := TSQLQuery.Create(nil);
  try
   query.sql.Clear;
   query.DataBase := Koneksi;
   query.SQL.Text := 'update percobaan set nama="'+nama+'",alamat="'+alamat+'" where id="'+idx+'"';
   query.ExecSQL;
   transaction.Commit;
  except
    exit;
  end;
  Result:=True;
end;

end.

