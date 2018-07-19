program website;

uses Classes, Sysutils, EventHandler;

begin
  Writeln('Content-type: text/html');
  Writeln;
  WriteLn('<html><body>');
  WriteLn('<title>FPC Web CRUD MySQL</title>');

  // Form Input
  WriteLn('<form method="post" action="'+base_url+'">');
  IsUpdate; // Handle Edit
  WriteLn('<input type="text" name="nama" id="nama" value="'+nama+'"/>');
  WriteLn('<input type="text" name="alamat" id="alamat" value="'+alamat+'"/>');
  WriteLn('<input type="submit" name="simpan" value="'+eksekusi+'">');
  WriteLn('</form>');

  // Handle Simpan & Update
  OnSimpan;
  // Handle Hapus
  OnHapus;

  // Tampilkan Data
  WriteLn('<hr>');
  OnTampil;

  WriteLn('</body></html>');
end.

