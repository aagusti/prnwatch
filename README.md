# prnwatch
PRN File Watcher/Web to Dot Matrix

prnwatch/web2dm digunakan untuk memantau dan mencetak file text dengan menggunakan RAW print.

1. Download file web2dm.sfx.exe yang ada di folder bin
2. Lakukan instalasi dengan double click file yang di download
3. Jalankan shortcut yang terbuat di desktop web2dm 

Ada 2 Fungsi Aplikasi

A. File Monitoring:

1. Aplikasi akan melakukan monitoring folder temporary 
2. Apabila ada file *.prn maka akan dilakukan pencetakan secara RAW print.

Konfigurasi Printer.

1. Install printer dengan menggunakan driver "Generic Text/Only"
2. Plih opsi "Print Direct to the printer" pada Printer Properties > Advance Setting
3. Set Printer "Generic Text/Only" menjadi default printer
4. Standarr Software Printer untuk Epson adalah IBM-PPDS
5. Character Table Menggunakan PC-850

Testing Cetak File.
1. "Open text file" untuk membuka file text dan meload ke dalam memo
2. "Print" digunakan untuk mncetak text yang terdapat pada memo.
 
Konfigurasi Aplikasi.

1. "Temporary Filder" menunjukan Folder yang dimonitor
2. Simpan File yang akan di cetak pada folder "Temporary Filder"
3. Aplikasi akan langsung mencetak 

Catatan:
Aplikasi ini masih ada bug apabila saat akan mencetak printer tidak dalam keadaan hidup
Solusinya Tutup Aplikasi dengan tombol Close atau dengan tanda silang.
Untuk Menghapus Printer Job yang tidak dapat dihapus gunakan File "delprintjob.cmd" dengan menggunakan run as administrator
Semoga membantu

Change Log
Versi 2
1. Penambahan Informasi Printer dan Kertas/Form Aktif
2. Penambahan Printer Properties 
   Berfungsi untuk menentukan printer dan kertas/form yang digunakan
3. Checklist Font Condensed untuk mencetak dengan CPI yang lebih besar (17/20CPI) 

Versi 1.
Initial Version
