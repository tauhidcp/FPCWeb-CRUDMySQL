unit EventHandler;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, EncodeDecode, StrUtils, DOS, DBManagement;

const
  base_url = 'http://localhost/freepascal/';

type
  DataRec    = record
  name,value : string;
end;

procedure OnSimpan;
procedure OnTampil;
procedure Simpan(nama:string;alamat:string);
procedure Update(nama:string;alamat:string;idx:string);
procedure OnHapus;
procedure Hapus(idx:string);
procedure IsUpdate;
function isPOST:Boolean;
function isGET:Boolean;

var
nama,alamat,hasil,idx,p,aksi,eksekusi   : string;
i,kar_awal,kar_akhir                    : integer;
tampil                                  : TStrings;
data                                    : array of DataRec;
nrdata                                  : longint;
c                                       : char;
literal,aname                           : boolean;

implementation

procedure OnSimpan;
begin
  if isPOST then
  begin
  nrdata:=1;
  aname:=true;
   while not eof(input) do
     begin
     SetLength(data,5); // Jumlah Form Input Text
     literal:=false;
     read(c);
     if c='\' then
        begin
        literal:=true;
        read(c);
        end;
     if literal or ((c<>'=') and (c<>'&')) then
        with data[nrdata] do
           if aname then name:=name+c else value:=value+c
     else
        begin
        if c='&' then
            begin
            inc (nrdata);
            aname:=true;
            end
         else
            aname:=false;
         end;
     end;
   for i:=1 to nrdata do begin
   if (data[i].name='id')   and (data[i].value<>'') then idx := DecodeUrl(data[i].value);
   if (data[i].name='nama') and (data[i].value<>'') then nama := DecodeUrl(data[i].value);
   if (data[i].name='alamat') and (data[i].value<>'') then alamat := DecodeUrl(data[i].value);
   if (data[i].name='simpan') and (data[i].value<>'') then aksi := DecodeUrl(data[i].value);
   end;
   // Simpan
   if (nama<>'') and (alamat<>'') and (aksi='Simpan') then Simpan(nama,alamat);
   // Update
   if (nama<>'') and (alamat<>'') and (aksi='Perbarui') and (idx<>'') then Update(nama,alamat,idx);
   end;
end;

procedure OnTampil;
begin
 WriteLn('<table>');
 WriteLn('<tr><td>No</td><td>Nama</td><td>Alamat</td><td>Aksi</td></tr>');
 for i   := 0 to Length(AmbilData().no) do
 begin
    writeln('<tr><td>'+IntToStr(StrToInt(AmbilData().no[i])+1)+'</td>'+
            '<td>'+AmbilData().nama[i]+'</td>'+
            '<td>'+AmbilData().alamat[i]+'</td>'+
            '<td><a href="'+base_url+'?edit='+AmbilData().id[i]+'">Edit</a> '+
            '<a href="'+base_url+'?hapus='+AmbilData().id[i]+'" onclick="return confirm(''Yakin Mau Dihapus?'');">Hapus</a></td>'+
            '</tr>');
 end;
 WriteLn('</table>');
end;

procedure Simpan(nama:string;alamat:string);
begin
  if SimpanData(nama,alamat) then
     WriteLn('<span style="color:red">Data Berhasil Disimpan</span>');
end;

procedure Update(nama:string;alamat:string;idx:string);
begin
  if UpdateData(nama,alamat,idx) then
     WriteLn('<span style="color:red">Data Berhasil Diperbarui</span>');
end;

procedure OnHapus;
begin
  if isGET then
  begin
  p := getenv('QUERY_STRING');
  kar_awal := 0;
  kar_akhir:= 0;

  kar_awal := PosEx('=',p,1);
  hasil   := Copy(p,1,kar_awal-1);
  idx      := Copy(p,kar_awal+1,kar_awal+1);
  if (hasil='hapus') and (idx<>'') then
     Hapus(idx);
  end;
end;

procedure Hapus(idx: string);
begin
  if HapusData(idx) then
     WriteLn('<script>window.location="'+base_url+'"</script>');
end;

procedure IsUpdate;
begin
   eksekusi := 'Simpan';
   nama     := '';
   alamat   := '';

   if isGET then
   begin
   p        := getenv('QUERY_STRING');
   kar_awal := 0;
   kar_akhir:= 0;

   kar_awal := PosEx('=',p,1);
   hasil    := Copy(p,1,kar_awal-1);
   idx      := Copy(p,kar_awal+1,kar_awal+1);

   // Jika Edit
   if (hasil='edit') and (idx<>'') then
      begin
      tampil   := TStringList.Create;
      tampil   := GetById(idx);
      WriteLn('<input type="text" name="id" id="id" size="2px" value="'+idx+'" readonly/>');
      nama     := tampil.Values['nama'];
      alamat   := tampil.Values['alamat'];
      eksekusi := 'Perbarui';
      end;

   end;
end;

function isPOST: Boolean;
begin
Result := False; if (getenv('REQUEST_METHOD')='POST') then Result := True;
end;

function isGET: Boolean;
begin
Result := False; if (getenv('QUERY_STRING')<>'') then Result := True;
end;



end.

