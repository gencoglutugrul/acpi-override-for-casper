# Casper Nirvana Laptoplarında ACPI Sorunları ve ACPI Tablolarını Override Etmek
Ben de o hataya düştüm :( Casper laptop aldım... Heyecanla açtım windows yüklü geldiği için biraz bakındım hemen bir gnu/linux dağıtımı indirip flash belleğe yazdırdım. Bilgisayarı yeniden başlatıp biosa girdim ve flash belleği boot ettim. Ve satırlar dolusu hiç bilmediğim ACPI hatalarıyla karşılaştım. Bu güne kadar fazlaca araştırdım. Tam anlamıyla olmasa da büyük oranda çözüme ulaştım. Hala aşamadığım ciddi sorunlar var ancak yine de ciddi ilerleme kaydettim. Dolayısıyla bu rehberi hazırlamaya karar verdim.

## Sistem Bilgilerim
Benim bilgisayarımın marka ve modeli Casper Nirvana NB F650, ancak diğer casper modellerinde de benzeri bir süreç izlenmesi gerektiğini tahmin ediyorum. Hatta tamamen aynı bile olabilir. Zaten Casper bu ACPI tablolarını kendisi baştan kodlamamış. Asus'un ACPI tablolarını alıp özelleştirmiş[1]. Dolayısıyla belki Asus cihazınızdaki soruna da çözüm olabilir.

[1]: Araştırmalarımda birebir aynı kod hatasının Asus biosunda da yapıldığını gördüm. Buradan yola çıkarak böyle bir varsayımda bulundum.

## Başlangıç
İlk olarak sorunu araştırdığımda ACPI özelliğini tamamen kapatarak laptopumu çalıştırabildiğimi farkettim. Bazı bioslar buna izin veriyor. Ama şaşırmayacaksınız ki casperın özelleştirdiği Asus biosu buna izin vermiyor. Dolayısıyla bunu linux kerneline parametreler girerek halletmem gerekti. ```acpi=off```, ```noapic```, ```acpi=hq``` gibi bir çok parametreyi denedikten sonra aşağıdaki kombinasyon benim için çalıştı.

```acpi=off noapic nolapic  pci=noacpi```
 
 Sonunda kurulum ekranına gelebilmiştim fakat touchpad, şarj/batarya bilgileri ve daha bir çok şeyde sorun vardı. Bir gariplik olduğu çok rahat anlaşılabiliyordu. O an sadece kurulumu tamamlamak için uğraştım ve UEFI ile kurulum yaptığımdan yine ACPI sorunlarından kaynaklı olarak kurulum grub-efi paketini yüklerken bir sıkıntı yaşıyordu. Dolayısıyla grub düzgün çalışmıyordu. Günlerce uğraştıktan sonra UEFI ile sistemi çalıştıramayacağımı anlayınca Legacy ve UEFI farklarını araştırmaya koyuldum. Sonra Legacy ile kurulum yapmanın okadar da zararı olmayacağını anladım ve Legacy ile aynı kernel parametreleriyle kurulumu yaptım. Başarıyla linux yüklemiştim. Fakat bu şarj/batarya veya touchpadi düzeltmedi. Fn tuşları da çalışmıyordu.

## ACPI'ı Anlamak
Bir çok kaynak okuduktan sonra sorunu aşağı yukarı anlamıştım. Basitçe anlatmak gerekirse ACPI Advanced Control and Power Interface yani Gelişmiş Yapılandırma ve Güç Arabiriminin kısaltması. Bu ACPI dediğimiz meret tablolarla bir cihazın nasıl yönetilmesi gerektiğini veya ne özellikler içerdiğini söylüyor. İşletim sistemi ve donanımın arasına girerek haberleşmelerini ve yönetimini sağlıyor. Örneğin işletim sistemi önce işlemci sıcaklığını ACPI'a soruyor. ACPI gidip işlemciye soruyor ve sonra işletim sistemine sıcaklığı söylüyor. İşletim sistemi eğer bu değerin çok sıcak olduğuna kanaat getirirse ACPI'a fanı açmasını söylüyor ve ACPI'da fanı açıyor. Bu ve bunun gibi bir çok işlemde ACPI aracı olarak görev alıyor. Hangi cihazın hangi çağrılara cevap vereceği ya da hangi özelliklere sahip olduğu ACPI tablolarında tutuluyor. Tablo dediysem aldanmayın bunlar birer kod bloğu. Bu kod blokları bazı işler için özelleşmiş kodlardan oluşmakta. Ki bu kodlar ACPI Source Language (ASL) denilen bir dil ile yazılıyor. Sözdizimi C diline benziyor. Bu arada ACPI'yı anladık fakat biraz havada kaldı. Bu ACPI nerde bulunuyor nerede çalışıyor gibi sorularınız olabilir. ACPI Tabloları BIOS Firmwareı içerisinde bulunur. BIOS üzerinde çalıştırılır. Yani ACPI Tablolarını değiştirme işi için ya BIOS'un kaynak kodlarına(geliştiriciler için hazırlanmış versiyonu da olur) sahip olmanız gerekiyor ya da iyi bir reverse engineer olmanız gerekiyor. Merak etmeyin ikisine de ihtiyacımız yok. ACPI hakkında daha fazla bilgi edinmek için arama motorlarını kullanabilirsiniz.

## Sorunu Anlamak
Sorun şu ki Casper geliştiricisi arkadaşlar mı desem yoksa bu ACPI tablolarını aldıkları yer mi desem bilemiyorum ama bunlardan biri bu tabloları berbat şekilde kodlamış. Şimdi sorulabilecek sorulardan birisi "Neden acpi windowsta sorun çıkarmazken linuxda çıkarıyor?" olabilir. Çünkü bu tabloları hazırlayan geliştiriciler bunu sadece windowsu düşünerek yapıyor. Pazarının geniş olmadığını düşünerek linuxa gereken değeri vermiyorlar. Ancak bunu yapan bir çok büyük marka var. Örneğin Lenovo ve Dell diyebilirim (tüm modellerinde değil tabii ki ancak çoğu modellerine linux desteği veriyorlar). Herneyse bu yüzden işletim sistemi donanımla haberleşmede sorunlar yaşıyor ve ortaya bu durum çıkıyor. Dolayısıyla sorunumuz ACPI Tablolarında bulununan saçma sapan buglar ve sadece windowsta çalışacak şekilde tasarlanmış kodlar...

## Sorunun Çözüm Yolları
Madem ki ACPI Tablolarında sıkıntı var ve bunları düzeltsek bile doğrudan değiştiremiyoruz bu durumda yapabileceğimiz tek şey çalıştırdığımız kernele BIOS'da bulunan ACPI Tabloları yerine benim sana vereceklerimi kullan demek. Bunu yapmanın 2 yolu var. İlki kerneli yeniden derlemek ki bu çok zahmetli bir iş, ikincisi ise kernele initrd parametresi olarak bir cpio arşivi içerisinde bu tabloları teslim etmek. Ancak bunlardan önce tablolardaki sorunları bulmamız gerekiyor. Eğer buraya kadar okuduklarınız havada kaldıysa korkmayın çünkü şimdi pratiğe geçiyoruz. ACPI tabloları diyip durdum, şimdi bu tabloları görme vakti geldi. Linuxu acpi ile başlatamadığımız için acpi ile başlayan Windows'u bu süreçte maalesef kullanmamız gerekecek. 
[https://www.acpica.org/downloads/binary-tools]() adresinden ASL kodlarını sökmek, test etmek, derlemek, decompile etmek için iASL Derleyicisi ve ACPI araçlarını indirmemiz gerekiyor. Daha sonra şu komutları çalıştırmamız gerekiyor.

```
$ acpidump.exe -o tables
$ acpixtract.exe -a tables
```
Bu noktadan sonrasını artık ister linux üzerinde ister windows üzerinde halledebiliriz. Önemli olan tablolara ulaşmaktı. Şimdi bu işlemleri yaptığınız dizinde bir sürü dat dosyası oluşmuş olmalı. ```dsdt.dat```, ```ssdt1.dat```, ```ssdt2.dat```, ```facp.dat``` gibi... Bizim burada işimiz ssdt ve dsdt tablolarıyla. Her tablonun kendince bir işlevi ve özelleştiği bir alan var. Örneğin MSDM tablosunda Windows lisans kodunuzu bulabilirsiniz. DSDT ve SSDT ne iş yapar bunu araştırmayı size bırakıyorum. Şimdi bu dat dosyaları ikili(binary) dosya formatında. Bizim bunları decompile ederek kodlara dönüştürmemiz gerekmekte. Bunun için iasl komutunu kullanacağız.
```
$ iasl -d dsdt.dat 
$ iasl -d ssdt1.dat 
$ iasl -d ssdt2.dat 
$ iasl -d ssdt3.dat 
...
$ iasl -d ssdt[n].dat 
# [n] son dosya numarasıdır. 
# bende en son ssdt13 vardı. 
# Sizde değişiklik gösterebilir.
```
Bu işlemden sonra her dsdt ve ssdt dat dosyası için birer tane de dsl dosyası oluşmuş olduğunu göreceksiniz. O dsl dosyaları aradığımız ACPI tablosu dediğimiz kod bloklarının ta kendisi. Şimdi sıra geldi fixlemeye. Ama bundan önce bu komutları çalıştırırken karşınıza bazı hatalar çıkabilir. Örneğin ben ```dsdt.dat``` dosyasını decompile ederken oldukça uzun bir çıktı aldım. [dsdt.dat decompile hata çıktıları](dsdt.dat-decompiling-error-output.txt) linkinden aldığım çıktıyı inceleyebilirsiniz. Bu hatalar size ne tarz sorunlar olduğuna dair bilgiler verebilir veya faydasız olabilir. Bunun kararını sizin vermeniz gerekiyor. Ancak herhalükarda bu hatalara bakmak faydalı olacaktır.

## Sorunları Bulma
Şimdi yapmamız gereken şey tek tek tüm kodları okuyamayacağımız için tüm kodları tekrardan derlemek. Eğer kodların içerisinde bir bug, syntax hatası veya başka bir sorun varsa derleyici bize bu hataların hangi satırda olduğu gibi önemli bilgileri verecektir. Bir dsl dosyasını derlemek için;
```
$ iasl tabloAdi.dsl
```
Tüm dsl dosyaları için tek tek bu komutu çalıştırmalıyız ve çıktılarını dikkatle incelemeliyiz. Çıktılarda bizim için yüksek öncelik ```Error``` etiketli çıktılardır. ```Warning```, ```Remark``` veya ```Optimization``` etiketli çıktılar da bir okadar önemli olsa da şimdilik göz ardı edilebilirler. Dolayısıyla biz bu çıktıları görmemek için komutumuzu aşağıdaki şekilde değiştiriyoruz.
```
$ iasl -ve tabloAdi.dsl 

```
 Dosyanızın başarı ile derlenmesi için hiç ```Error``` etiketli çıktı olmaması gerekmektedir. Örneğin ```dsdt.dsl``` dosyasını derlediğimde şuna benzer bir çıktı aldım.
```
....
....

ASL Input:     dsdt.dsl - 1595560 bytes  25366 keywords  50258 source lines
AML Output:    dsdt.aml -  224658 bytes  21133 opcodes    4233 named objects

Compilation successful. 0 Errors, 150 Warnings, 517 Remarks, 423 Optimizations
```

Ben sırasıyla hepsini derlemeyi denediğimde ssdt7.dsl dosyasını derlerken hatayla karşılaştım. Aldığım hata;
```
 iasl -ve ssdt7.dsl 

Intel ACPI Component Architecture
ASL+ Optimizing Compiler/Disassembler version 20200717
Copyright (c) 2000 - 2020 Intel Corporation

Compiler aborting due to parser-detected syntax error(s)
ssdt7.dsl     86:                                 }
Error    6126 -                     syntax error ^ 

ssdt7.dsl    100:                             Case (0x02)
Error    6126 -                    syntax error ^ 

ssdt7.dsl    101:                             {
Error    6126 -                 syntax error ^ 

ssdt7.dsl    107:                                 If ((DFUD > Zero))
Error    6126 -                      syntax error ^ 

ssdt7.dsl    107:                                 If ((DFUD > Zero))
Error    6114 - Result is not used, operator has no effect ^ 

ssdt7.dsl    108:                                 {
Error    6126 -                     syntax error ^ 

ssdt7.dsl    112:                                 }
Error    6126 -                     syntax error ^ 

Input file:    ssdt7.dsl - Compilation aborted due to parser-detected syntax error(s)

Compilation failed. 7 Errors, 0 Warnings, 10 Remarks
No AML files were generated due to syntax error(s)
```
Basit bir syntax hatası gibi görünüyordu. 

```
Case (One)
{
    PGCE = DerefOf (Arg3 [Zero])
    PGCD = DerefOf (Arg3 [One])
    OLDV = \_SB.GGOV (0x02010016)
    \_SB.SGOV (0x02010016, PGCE)
    If ((PGCD > Zero))
    {
        Sleep (PGCD)

        // burada hata veriyor
        \_SB.GGOV (0x02010016)
        OLDV
    }

    If ((\_SB.GGOV (0x02010016) == One))
    {
        Sleep (0x96)
        If ((\_SB.GGOV (0x02010014) == One)){}
        Else
        {
            Notify (\_SB.PCI0.I2C0.DFUD, One) // Device Check
        }
    }

    Return (Zero)
}
```
kodlar bu şekildeydi. Hatayı başta bulamadım. Uzunca araştırma yaptıktan sonra https://rog.asus.com/forum/showthread.php?106165-Z370-e-BIOS-bug-that-I-have-fixed bu forumdaki yazıyla karşılaştım ve gerekli yönergeyi takip ettiğimde başarıyla derleyebildim. Kısaca linkte OLDV'nin bir parametre olduğu ve \\_SB.GGOV methodunun tek parametre aldığından ve ona benzeyen iki parametre alan \\_SB.SGOV methodu ile karıştırılmış olabileceğinden bahsedilmiş. Dolayısıyla düzeltildiğinde aşağıdaki şekilde oluyor;

```
Case (One)
{
    PGCE = DerefOf (Arg3 [Zero])
    PGCD = DerefOf (Arg3 [One])
    OLDV = \_SB.GGOV (0x02010016)
    \_SB.SGOV (0x02010016, PGCE)
    If ((PGCD > Zero))
    {
        Sleep (PGCD)

        // burada değişiklik yapıldı
        \_SB.SGOV (0x02010016, OLDV) 
    }

    If ((\_SB.GGOV (0x02010016) == One))
    {
        Sleep (0x96)
        If ((\_SB.GGOV (0x02010014) == One)){}
        Else
        {
            Notify (\_SB.PCI0.I2C0.DFUD, One) // Device Check
        }
    }

    Return (Zero)
}
```
