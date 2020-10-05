# Casper Nirvana Laptoplarında ACPI Sorunları ve ACPI Tablolarını Override Etmek
Ben de o hataya düştüm :( Casper laptop aldım... Heyecanla açtım windows yüklü geldiği için biraz bakındım hemen bir gnu/linux dağıtımı indirip flash belleğe yazdırdım. Bilgisayarı yeniden başlatıp biosa girdim ve flash belleği boot ettim. Ve satırlar dolusu hiç bilmediğim ACPI hatalarıyla karşılaştım. Bu güne kadar fazlaca araştırdım. Tam anlamıyla olmasa da büyük oranda çözüme ulaştım. Hala aşamadığım ciddi sorunlar var ancak yine de ciddi ilerleme kaydettim. Dolayısıyla bu rehberi hazırlamaya karar verdim.

## Sistem Bilgilerim
Benim bilgisayarımın marka ve modeli Casper Nirvana NB F650, ancak diğer casper modellerinde de benzeri bir süreç izlenmesi gerektiğini tahmin ediyorum. Hatta tamamen aynı bile olabilir. Zaten Casper bu ACPI tablolarını kendisi baştan kodlamamış. Asus'un ACPI tablolarını alıp özelleştirmiş[1]. Dolayısıyla belki Asus cihazınızdaki soruna da çözüm olabilir.

[1]: Araştırmalarımda birebir aynı kod hatasının Asus biosunda da yapıldığını gördüm. Buradan yola çıkarak böyle bir varsayımda bulundum.

### Başlangıç
İlk olarak sorunu araştırdığımda ACPI özelliğini tamamen kapatarak laptopumu çalıştırabildiğimi farkettim. Bazı bioslar buna izin veriyor. Ama şaşırmayacaksınız ki casperın özelleştirdiği Asus biosu buna izin vermiyor. Dolayısıyla bunu linux kerneline parametreler girerek halletmem gerekti. ```acpi=off```, ```noapic```, ```acpi=hq``` gibi bir çok parametreyi denedikten sonra aşağıdaki kombinasyon benim için çalıştı.

```acpi=off noapic nolapic  pci=noacpi```
 
 Sonunda kurulum ekranına gelebilmiştim fakat touchpad, şarj/batarya bilgileri ve daha bir çok şeyde sorun vardı. Bir gariplik olduğu çok rahat anlaşılabiliyordu. O an sadece kurulumu tamamlamak için uğraştım ve UEFI ile kurulum yaptığımdan yine ACPI sorunlarından kaynaklı olarak kurulum grub-efi paketini yüklerken bir sıkıntı yaşıyordu. Dolayısıyla grub düzgün çalışmıyordu. Günlerce uğraştıktan sonra UEFI ile sistemi çalıştıramayacağımı anlayınca Legacy ve UEFI farklarını araştırmaya koyuldum. Sonra Legacy ile kurulum yapmanın okadar da zararı olmayacağını anladım ve Legacy ile aynı kernel parametreleriyle kurulumu yaptım. Başarıyla linux yüklemiştim. Fakat bu şarj/batarya veya touchpadi düzeltmedi. Fn tuşları da çalışmıyordu.

### ACPI'ı Anlamak
Bir çok kaynak okuduktan sonra sorunu aşağı yukarı anlamıştım. Basitçe anlatmak gerekirse ACPI Advanced Control and Power Interface yani Gelişmiş Yapılandırma ve Güç Arabiriminin kısaltması. Bu ACPI dediğimiz meret tablolarla bir cihazın nasıl yönetilmesi gerektiğini veya ne özellikler içerdiğini söylüyor. İşletim sistemi ve donanımın arasına girerek haberleşmelerini ve yönetimini sağlıyor. Örneğin işletim sistemi önce işlemci sıcaklığını ACPI'a soruyor. ACPI gidip işlemciye soruyor ve sonra işletim sistemine sıcaklığı söylüyor. İşletim sistemi eğer bu değerin çok sıcak olduğuna kanaat getirirse ACPI'a fanı açmasını söylüyor ve ACPI'da fanı açıyor. Bu ve bunun gibi bir çok işlemde ACPI aracı olarak görev alıyor. Hangi cihazın hangi çağrılara cevap vereceği ya da hangi özelliklere sahip olduğu ACPI tablolarında tutuluyor. Tablo dediysem aldanmayın bunlar birer kod bloğu. Bu kod blokları bazı işler için özelleşmiş kodlardan oluşmakta. Ki bu kodlar ACPI Source Language (ASL) denilen bir dil ile yazılıyor. Sözdizimi C diline benziyor. Bu arada ACPI'yı anladık fakat biraz havada kaldı. Bu ACPI nerde bulunuyor nerede çalışıyor gibi sorularınız olabilir. ACPI Tabloları BIOS Firmwareı içerisinde bulunur. BIOS üzerinde çalıştırılır. Yani ACPI Tablolarını değiştirme işi için ya BIOS'un kaynak kodlarına(geliştiriciler için hazırlanmış versiyonu da olur) sahip olmanız gerekiyor ya da iyi bir reverse engineer olmanız gerekiyor. Merak etmeyin ikisine de ihtiyacımız yok. ACPI hakkında daha fazla bilgi edinmek için arama motorlarını kullanabilirsiniz.

### Sorunu Anlamak
Sorun şu ki Casper geliştiricisi arkadaşlar mı desem yoksa bu ACPI tablolarını aldıkları yer mi desem bilemiyorum ama bunlardan biri bu tabloları berbat şekilde kodlamış. Şimdi sorulabilecek sorulardan birisi "Neden acpi windowsta sorun çıkarmazken linuxda çıkarıyor?" olabilir. Çünkü bu tabloları hazırlayan geliştiriciler bunu sadece windowsu düşünerek yapıyor. Pazarının geniş olmadığını düşünerek linuxa gereken değeri vermiyorlar. Ancak bunu yapan bir çok büyük marka var. Örneğin Lenovo ve Dell diyebilirim (tüm modellerinde değil tabii ki ancak çoğu modellerine linux desteği veriyorlar). Herneyse bu yüzden işletim sistemi donanımla haberleşmede sorunlar yaşıyor ve ortaya bu durum çıkıyor. Dolayısıyla sorunumuz ACPI Tablolarında bulununan saçma sapan buglar ve sadece windowsta çalışacak şekilde tasarlanmış kodlar...

### Sorunun Çözüm Yolları
Madem ki ACPI Tablolarında sıkıntı var ve bunları düzeltsek bile doğrudan değiştiremiyoruz bu durumda yapabileceğimiz tek şey çalıştırdığımız kernele BIOS'da bulunan ACPI Tabloları yerine benim sana vereceklerimi kullan demek. Bunu yapmanın 2 yolu var. İlki kerneli yeniden derlemek ki bu çok zahmetli bir iş, ikincisi ise kernele initrd parametresi olarak bir cpio arşivi içerisinde bu tabloları teslim etmek. Ancak bunlardan önce tablolardaki sorunları bulmamız gerekiyor. Eğer buraya kadar okuduklarınız havada kaldıysa korkmayın çünkü şimdi pratiğe geçiyoruz. ACPI tabloları diyip durdum, şimdi bu tabloları görme vakti geldi. Linuxu acpi ile başlatamadığımız için acpi ile başlayan Windows'u bu süreçte maalesef kullanmamız gerekecek. 
[https://www.acpica.org/downloads/binary-tools]() adresinden ASL kodlarını sökmek, test etmek, derlemek, decompile etmek için iASL Derleyicisi ve ACPI araçlarını indirmemiz gerekiyor. Daha sonra şu komutları çalıştırmamız gerekiyor.

```
$ acpidump -o tables
$ acpixtract -a tables
```
Şimdi bu işlemleri yaptığınız dizinde bir sürü dat dosyası oluşmuş olmalı. ```dsdt.dat```, ```ssdt1.dat```, ```ssdt2.dat```, ```facp.dat``` gibi... Bizim burada işimiz ssdt ve dsdt tablolarıyla. Her tablonun kendince bir işlevi ve özelleştiği bir alan var. Örneğin MSDM tablosunda Windows lisans kodunuzu bulabilirsiniz. DSDT ve SSDT ne iş yapar bunu araştırmayı size bırakıyorum. Şimdi bu dat dosyaları ikili(binary) dosya formatında. Bizim bunları decompile ederek kodlara dönüştürmemiz gerekmekte.


// Zamanla güncellenecektir









