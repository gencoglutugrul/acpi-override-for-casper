# Casper Nirvana Laptoplarında ACPI Sorunları ve ACPI Tablolarını Override Etmek
Ben de o hataya düştüm :( Casper laptop aldım... Heyecanla açtım windows yüklü geldiği için biraz bakındım hemen bir gnu/linux dağıtımı indirip flash belleğe yazdırdım. Bilgisayarı yeniden başlatıp biosa girdim ve flash belleği boot ettim. Ve satırlar dolusu hiç bilmediğim ACPI hatalarıyla karşılaştım. Bu güne kadar fazlaca araştırdım. Tam anlamıyla olmasa da büyük oranda çözüme ulaştım. Hala aşamadığım ciddi sorunlar var ancak yine de ciddi ilerleme kaydettim. Dolayısıyla bu rehberi hazırlamaya karar verdim.

## Önemli Not!
Öncelikle bu işlemlerin bilgisayarınıza zarar verebilme olasılığını unutmayın ve ne yaptığınızı bilerek hareket edin. (Bilgisayarınızın MODELİ AYNI OLSA BİLE!) Kesinlikle benim dosyalarımı kopyalayıp işlem yapmaya çalışmayın. Tüm adımları teker teker takip edin ve hepsini ANLAYARAK uygulayın. Ayrıca bu yönergeyi uygulamanız sonucunda oluşacak sorunlardan dolayı hiçbir sorumluluk kabul etmediğimi bilerek hareket etmelisiniz.

## Sistem Bilgilerim
Benim bilgisayarımın marka ve modeli Casper Nirvana NB F650, ancak diğer casper modellerinde de benzeri bir süreç izlenmesi gerektiğini tahmin ediyorum. Hatta tamamen aynı bile olabilir. Zaten Casper bu ACPI tablolarını kendisi baştan kodlamamış. Asus'un ACPI tablolarını alıp özelleştirmiş[1]. Dolayısıyla belki Asus cihazınızdaki soruna da çözüm olabilir.

[1]: Araştırmalarımda birebir aynı kod hatasının Asus biosunda da yapıldığını gördüm. Buradan yola çıkarak böyle bir varsayımda bulundum.

## Başlangıç
İlk olarak sorunu araştırdığımda ACPI özelliğini tamamen kapatarak laptopumu çalıştırabildiğimi farkettim. Bazı bioslar buna izin veriyor. Ama şaşırmayacaksınız ki casperın özelleştirdiği Asus biosu buna izin vermiyor. Dolayısıyla bunu linux kerneline parametreler girerek halletmem gerekti. ```acpi=off```, ```noapic```, ```acpi=hq``` gibi bir çok parametreyi denedikten sonra aşağıdaki kombinasyon benim için çalıştı.

```acpi=off noapic nolapic  pci=noacpi```
 
 Sonunda kurulum ekranına gelebilmiştim fakat touchpad, şarj/batarya bilgileri ve daha bir çok şeyde sorun vardı. Bir gariplik olduğu çok rahat anlaşılabiliyordu. O an sadece kurulumu tamamlamak için uğraştım ve UEFI ile kurulum yaptığımdan yine ACPI sorunlarından kaynaklı olarak kurulum grub-efi paketini yüklerken bir sıkıntı yaşıyordu. Dolayısıyla grub düzgün çalışmıyordu. Günlerce uğraştıktan sonra UEFI ile sistemi çalıştıramayacağımı anlayınca Legacy ve UEFI farklarını araştırmaya koyuldum. Sonra Legacy ile kurulum yapmanın okadar da zararı olmayacağını anladım ve Legacy ile aynı kernel parametreleriyle kurulumu yaptım. Başarıyla gnu/linux yüklemiştim. Fakat bu şarj/batarya veya touchpadi düzeltmedi. Fn tuşları da çalışmıyordu.

## ACPI'ı Anlamak
Bir çok kaynak okuduktan sonra sorunu aşağı yukarı anlamıştım. Basitçe anlatmak gerekirse ACPI Advanced Control and Power Interface yani Gelişmiş Yapılandırma ve Güç Arabiriminin kısaltması. Bu ACPI dediğimiz meret tablolarla bir cihazın nasıl yönetilmesi gerektiğini veya ne özellikler içerdiğini söylüyor. İşletim sistemi ve donanımın arasına girerek haberleşmelerini ve yönetimini sağlıyor. Örneğin işletim sistemi önce işlemci sıcaklığını ACPI'a soruyor. ACPI gidip işlemciye soruyor ve sonra işletim sistemine sıcaklığı söylüyor. İşletim sistemi eğer bu değerin çok sıcak olduğuna kanaat getirirse ACPI'a fanı açmasını söylüyor ve ACPI'da fanı açıyor. Bu ve bunun gibi bir çok işlemde ACPI aracı olarak görev alıyor. Hangi cihazın hangi çağrılara cevap vereceği ya da hangi özelliklere sahip olduğu ACPI tablolarında tutuluyor. Tablo dediysem aldanmayın bunlar birer kod bloğu. Bu kod blokları bazı işler için özelleşmiş kodlardan oluşmakta. Ki bu kodlar ACPI Source Language (ASL) denilen bir dil ile yazılıyor. Sözdizimi C diline benziyor. Bu arada ACPI'yı anladık fakat biraz havada kaldı. Bu ACPI nerde bulunuyor nerede çalışıyor gibi sorularınız olabilir. ACPI Tabloları BIOS Firmwareı içerisinde bulunur. BIOS üzerinde çalıştırılır. Yani ACPI Tablolarını değiştirme işi için ya BIOS'un kaynak kodlarına(geliştiriciler için hazırlanmış versiyonu da olur) sahip olmanız gerekiyor ya da iyi bir reverse engineer olmanız gerekiyor. Merak etmeyin ikisine de ihtiyacımız yok. ACPI hakkında daha fazla bilgi edinmek için arama motorlarını kullanabilirsiniz.

## Sorunu Anlamak
Sorun şu ki Casper geliştiricisi arkadaşlar mı desem yoksa bu ACPI tablolarını aldıkları yer mi desem bilemiyorum ama bunlardan biri bu tabloları berbat şekilde kodlamış. Şimdi sorulabilecek sorulardan birisi "Neden acpi windowsta sorun çıkarmazken gnu/linuxda çıkarıyor?" olabilir. Çünkü bu tabloları hazırlayan geliştiriciler bunu sadece windowsu düşünerek yapıyor. Pazarının geniş olmadığını düşünerek gnu/linuxa gereken değeri vermiyorlar. Ancak bunu yapan bir çok büyük marka var. Örneğin Lenovo ve Dell diyebilirim (tüm modellerinde değil tabii ki ancak çoğu modellerine gnu/linux desteği veriyorlar). Herneyse bu yüzden işletim sistemi donanımla haberleşmede sorunlar yaşıyor ve ortaya bu durum çıkıyor. Dolayısıyla sorunumuz ACPI Tablolarında bulununan saçma sapan buglar ve sadece windowsta çalışacak şekilde tasarlanmış kodlar...

## Sorunun Çözüm Yolları
Madem ki ACPI Tablolarında sıkıntı var ve bunları düzeltsek bile doğrudan değiştiremiyoruz bu durumda yapabileceğimiz tek şey çalıştırdığımız kernele BIOS'da bulunan ACPI Tabloları yerine benim sana vereceklerimi kullan demek. Bunu yapmanın 2 yolu var. İlki kerneli yeniden derlemek ki bu çok zahmetli bir iş, ikincisi ise kernele initrd parametresi olarak bir cpio arşivi içerisinde bu tabloları teslim etmek. Ancak bunlardan önce tablolardaki sorunları bulmamız gerekiyor. Eğer buraya kadar okuduklarınız havada kaldıysa korkmayın çünkü şimdi pratiğe geçiyoruz. ACPI tabloları diyip durdum, şimdi bu tabloları görme vakti geldi. GNU/Linuxu acpi ile başlatamadığımız için acpi ile başlayan Windows'u bu süreçte maalesef kullanmamız gerekecek. 
[https://www.acpica.org/downloads/binary-tools]() adresinden ASL kodlarını sökmek, test etmek, derlemek, decompile etmek için iASL Derleyicisi ve ACPI araçlarını indirmemiz gerekiyor. Daha sonra şu komutları çalıştırmamız gerekiyor.

```
$ acpidump.exe -o tables
$ acpixtract.exe -a tables
```
Bu noktadan sonrasını artık ister GNU/Linux üzerinde ister windows üzerinde halledebiliriz. Önemli olan tablolara ulaşmaktı. Şimdi bu işlemleri yaptığınız dizinde bir sürü dat dosyası oluşmuş olmalı. ```dsdt.dat```, ```ssdt1.dat```, ```ssdt2.dat```, ```facp.dat``` gibi... Bizim burada işimiz ssdt ve dsdt tablolarıyla. Her tablonun kendince bir işlevi ve özelleştiği bir alan var. Örneğin MSDM tablosunda Windows lisans kodunuzu bulabilirsiniz. DSDT ve SSDT ne iş yapar bunu araştırmayı size bırakıyorum. Şimdi bu dat dosyaları ikili(binary) dosya formatında. Bizim bunları decompile ederek kodlara dönüştürmemiz gerekmekte. Bunun için iasl komutunu kullanacağız.
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
$ iasl -ve ssdt7.dsl 

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

Artık tüm sorunları bulduk ve çözdük. Başka derlenmeyen bir dosya kalmadı. Şimdi bunları bir şekilde paketleyip bilgisayar açılırken işletim sistemine BIOS'da bulunan tablolar yerine benim sana verdiğim tabloları kullan dememiz gerekiyor. Bunun için birden fazla yöntem var bunlar;

- Initrd yöntemi
- Kernel ile birlikte derlemek

Bilindiği gibi kernel derlemek zor, zahmetli ve uzun bir süreç. Dolayısıyla basit olanı tercih edip initrd methodundan bahsedeceğim.

## Çözüm

Öncelikle initrd yöntemi uygulamak için seçtiğiniz dağıtımın kullandığı kernel derlenirken ```ACPI_TABLE_UPGRADE=y``` şeklinde configi aktif edilmiş olmalı. Bunu nasıl kontrol edebilirsiniz? Bu sistemden sisteme değişiklik gösterebilir. Bunun için şu kaynağı inceleyebilirsiniz: https://superuser.com/questions/287371/obtain-kernel-config-from-currently-running-linux-system

Belirttiğim configin sizde de aktif olduğundan emin olduktan sonra devam edin. Ben dağıtım olarak Manjaro kullanıyorum. Manjaro'da bu config varsayılan olarak ```y``` yani aktif geliyor. Dolayısıyla ne yapmanız gerektiğini bilmiyorsanız veya garantiye almak istiyorsanız Manjaro seçerek devam edebilirsiniz (durum buysa korkmanıza gerek yok çünkü manjaro son kullanıcıya hitap eden güzel bir gnu/linux dağıtımı). Ufak bir uyarıda bulunayım **yanılmıyorsam** (lütfen kontrol edin) Ubuntu'da bu config varsayılan olarak **aktif değil**. Dolayısıyla bu işlemler için Ubuntu kullanmanız yanıltıcı olabilir. İşlemleri doğru uyguladığınız halde çalışmayabilir. Ben illa ki Ubuntu kullanmak istiyorum diyorsanız bunun için yeniden kernel derlemeniz gerekebilir ki bu durumda initrd yöntemini tercih etmemizin bir anlamı kalmayacaktır.

Yukarıdaki adımları doğruladıysanız initrd yöntemini detaylıca inceleyebiliriz.

Aslında buraya uzunca initrd nasıl çalışıyor ve nerede ne aktif oluyor neden bizim acpi tablolarımız buradan da yüklenebiliyor bunu anlatacaktım fakat farkettim ki ben de tam olarak bunu bilmiyorum ve üstelik muhtemelen bu rehberi okuyanlar da bu "ekstra" bilgiye çok da hevesli olmayacaklar. Dolayısıyla initrd nasıl çalışıyor nasıl bizim acpi tablolarımız buradan yüklenebiliyor bunu merak edenler bolca google araştırması yapabilir veya araştırmaya verdiğim kaynaklardan başlayabilir.

Şimdi ilk yapmamız gereken şey başarıyla derlediğimiz acpi tablolarını dsdt dosyasında birleştirip tekrardan derlemek. Bunu yapmak oldukça basit. Yapmanız gereken tek şey tüm ssdt dosyalarınızın içindeki kodları kopyalıyıp dsdt içerisinde yerleştirmek. Aşağıda bir örneğini görüyorsunuz.

```
DefinitionBlock ("", "SSDT", 2, "CASPER", "ERA     ", 0x00001000)
{
    // buradan başlayıp
    OperationRegion (MENV, SystemMemory, 0x8CF74FD8, 0x000C)
    Field (MENV, AnyAcc, Lock, Preserve)
    {
        MERV,   32, 
        PTTB,   64
    }
    // en alttaki ve en üstteki iki süslü
    // parantez arasında
    // kalan tüm satırları kopyalıyoruz
}
```

```
    // ...
    // ...
    Method (WAK, 1, NotSerialized)
    {
    }
    // ...

    // en alt satıra
    // indikten sonra
    // en sondaki süslü parantezin üstüne
    // kopyaladığımız satırları yapıştıralım
    // isteğe bağlı olarak üstüne açıklama satırlarıyla
    // hangi ssdt dosyasının içeriği olduğunu
    // yazarsanız böylece içeriğini
    // değiştirmek istediğinizde
    // kolayca bulabilirsiniz

    /* SSDT1.dsl başlangıcı */
    // .........
    // ......
    // ...........
    /* SSDT1.dsl bitişi */


    /* SSDT2.dsl başlangıcı */
    OperationRegion (MENV, SystemMemory, 0x8CF74FD8, 0x000C)
    Field (MENV, AnyAcc, Lock, Preserve)
    {
        MERV,   32, 
        PTTB,   64
    }
    /* SSDT2.dsl bitişi */


    // ...
    // her şey bu süslü parantezin öncesine yapıştırılmalı
}
```

Önemli Not: Eğer bilgisayarınız casper nirvana markaysa ```ssdt7.dsl``` dosyasının içeriğini eklediğinizde sorun yaşabilirsiniz. Önce ekleyerek deneyin eğer sorun yaşarsanız ```ssdt7.dsl``` dosyasının içeriğini eklemeden geri kalan ssdt dosyalarının içeriğini ekleyin.

Evet bunu yaptınız ve şimdi sıra geldi derlemeye daha önce anlattığım gibi bu dosyayı derleyebilirsiniz. Benim tavsiyem orjinal dsdt.dsl dosyanızı saklayıp bu işlemleri yeni bir dosyada yapmanız. Örneğin dsdt-fixed.dsl veya dsdt-merged.dsl gibi...

```
$ iasl -ve dsdt-merged.dsl 

Intel ACPI Component Architecture
ASL+ Optimizing Compiler/Disassembler version 20201217
Copyright (c) 2000 - 2020 Intel Corporation

ASL Input:     dsdt-merged.dsl - 1917659 bytes  31043 keywords  60395 source lines
AML Output:    dsdt-merged.aml -  282069 bytes  25913 opcodes    5130 named objects

Compilation successful. 0 Errors, 256 Warnings, 718 Remarks, 1150 Optimizations, 2 Constants Folded
```

Şimdi başarıyla derledik artık her şey tamam tek yapmamız gereken linux kernelimize bu dosyayı vermek.
Bunun için önce bir klasör yapısı oluşturmalıyız. Eğer başka bir linux dağıtımı yüklü bilgisayarda çalışıyorsanız;
```
$ mkdir -p kernel/firmware/acpi
```
Komutunu çalıştırabilirsiniz. Ya da windows üzerinde bu işlemleri yapıyorsanız uygun bir yere önce ```kernel``` adında sonra bunun içine ```firmware``` adında bunun da içine ```acpi``` adında bir klasör oluşturmalısınız. Şimdi derlediğiniz ```dsdt-merged.aml``` dosyasını bu klasörün içine atıyoruz. Daha sonra ```kernel``` klasörünün olduğu dizine geliyoruz ve terminal açıyoruz. Şimdi çalıştırmamız gereken komut şu;
```
$ find kernel | cpio -H newc --create > acpi_override 
```
Eğer bir linux dağıtımındaysanız bu işlemi kolayca terminalinizde çalıştırabilirsiniz. Fakat windows üzerinde bu işlemleri gerçekleştiriyorsanız find ve cpio uygulamalarına ihtiyacınız var. Neyse ki bu uygulamalar özgür yazılım ve herkese açık. Buradan dilersiniz tüm GNU araçlarını kurabilir veya sadece find ve cpio uygulamalarını indirip kurabilirsiniz.

Hepsini incelemek için: http://gnuwin32.sourceforge.net/

find uygulaması için: http://gnuwin32.sourceforge.net/packages/findutils.htm

cpio uygulaması için: http://gnuwin32.sourceforge.net/packages/cpio.htm

Bunları kurduktan sonra windowsta da bu komutu çalıştırabilirsiniz. Bu komut çalıştıktan sonra bulunduğunuz dizinde ```acpi_override``` adında bir dosya oluşacak. Artık son düzlüğü de geçtik ve sadece bu dosyayı kernela verme işi kaldı.

Şimdi hemen bir GNU/Linux dağıtımını indirin ve flash belleğinize yazdırın. Daha sonra tüm bu dosyalarınızı mutlaka bir yere yedekleyin. Herhangi bir aksilik çıkarsa tüm bu işlemleri baştan yapmak istemeyiz değil mi?

Şimdi ```acpi_override``` dosyasını bilgisayarınızdaki en üst dizine kopyalayın. Örneğin windows kuruluysa C:\ veya D:\ dizinine kopyalayın. Veyahut bir başka flash bellek daha bulup onun içine kopyalayın.

Şimdi kurulum usbmizi takalım ve bilgisayarı yeniden başlatalım. Bilgisayar yeniden başladığında karşımıza grub ekranında yükleme seçeneğini düzenlemek için ```e``` tuşuna basalım.

Şimdi karşımıza çıkan editörde ```linux``` ile başlayan satırı bulalım. Bu satırın sonunda ```acpi_no_static_ssdt``` ve ```pci=noaer``` parametrelerini ekleyelim. ```acpi_no_static_ssdt``` parametresi ssdt tablolarının statik olarak yani bios içerisinde depolandığı yerden yüklenmesini engelliyor. Sadece dsdt dosyasını yüklüyor. Böylece bizim dsdt dosyasına aldığımız ssdt kodları başka bir şeyle çakışmadan veya göz ardı edilmeden çalışabilecek. Ben bu parametre olmadan bilgisayarımı çalıştırmayı başaramadım ancak bu parametre ile çalıştırmanın da en ufak bir eksisi dahi yok.

Daha sonra ```initrd``` ile başlayan satırı bulalım ve bu satırın hemen yanına ``` (dosyamızınbulunduğudisk,bölümü)/dosyamizin/konumu/acpi_override``` şeklinde acpi tablolarımızın olduğu arşivin konumunu verelim. Burada önemli nokta kesinlikle en ```initrd``` komutundan sonra ```acpi_override``` dosyamız gelmeli. Yani sıralamada ilk olmalı. İlk olmazsa çalışmaz!

Aşağıda her iki değişikliği yaptığım örneğe bakabilirsiniz.

Değiştirmeden önce;
```
...
...
linux  /boot/vmlinuz-x86_64  img_dev=$pqr img_loop=$isofile driver=$dri tz=utc lang=en_us keytable=us
initrd /boot/intel_ucode.img /boot/initramfs-x86_64.img

```

Değiştirdikten sonra;
```
...
...
linux  /boot/vmlinuz-x86_64  img_dev=$pqr img_loop=$isofile driver=$dri tz=utc lang=en_us keytable=us acpi_no_static_ssdt pci=noaer
initrd (hd1,msdos2)/acpi_override /boot/intel_ucode.img /boot/initramfs-x86_64.img

```

Şimdi ```F10``` tuşuna basarak sistemi boot edebiliriz. Bu işlem sonucunda GNU/Linux dağıtımınız başarıyla açılacak. Kurulum ekranına geçeceksiniz. Burada yapmanız gereken ilk şey kuruluma başlamadan önce ```acpi_override``` dosyamızı usb bellek veya harddiskimizden masaüstüne kopyalamak. Daha sonra kuruluma geçip gerekli adımları tamamlıyoruz. Kurulum tamamlandıktan sonra bilgisayarı yeniden başlatmadan önce ```acpi_override``` dosyasını GNU/Linux dağıtımımızı kurduğumuz disk bölümünü açıp oradan /boot/ klasörünün altına kopyalayalım. Şimdi yeniden başlatabiliriz.

Artık kurulum tamamlandı ve şimdi kurulum usbsini çıkarıp bilgisayarı tekrar başlattıktan sonra grub ekranında yine ```e``` tuşuna basarak boot seçeneklerini düzenleme ekranını açalım. Burada yine yukarıdaki gibi ```linux``` ve ```initrd``` ile başlayan yerlere ilgili değişiklikleri yapalım. Ancak bu sefer ```acpi_override``` dosyamızı ```/boot/acpi_override``` konumunda sakladığımız için konumu bu şekilde girelim. Örneğe bakabilirsiniz;

```
linux   /boot/vmlinuz-5.10-x86_64 root=UUID=... rw  quiet apparmor=1 security=apparmor resume=UUID=... udev.log_priority=3 acpi_no_static_ssdt pci=noaer
initrd  /boot/acpi_override /boot/intel-ucode.img /boot/initramfs-5.10-x86_64.img

```
Şimdi artık bilgisayarımız düzgün bir şekilde başlayacak ve başarıyla batarya gibi bileşenlerin değerlerini okuyabilecek ve bilgisayar kaynaklarını (gpu, cpu ...) istediğimiz gibi yönetebilecek ve güç tasarrufu yapabileceğiz.

Her seferinde böyle elle girmemek için gelin bu değişiklikleri kaydedelim. Öncelikle ```/etc/default/grub``` dosyasını aşağıdaki şekilde değiştirelim;

```
........
GRUB_CMDLINE_LINUX_DEFAULT="quiet apparmor=1 security=apparmor resume=UUID=.... udev.log_priority=3 acpi_no_static_ssdt pci=noaer"
........
```

Yapmanız gereken tek şey ```GRUB_CMDLINE_LINUX_DEFAULT``` değişkeninin sonuna ```acpi_no_static_ssdt pci=noaer``` kernel parametrelerini eklemek.

Şimdi son olarak ```acpi_override``` dosyamızı da ```initrd``` parametresi olarak girelim. Bunun için /etc/grub.d/10_linux dosyasını açalım ve aşağıdaki bölmeyi bulalım.

```
 if test -n "${initrd}" ; then
    # TRANSLATORS: ramdisk isn't identifier. Should be translated.
    message="$(gettext_printf "Loading initial ramdisk ...")"
    initrd_path=
    for i in ${initrd}; do
      initrd_path="${initrd_path} ${rel_dirname}/${i}"
    done
    if [ x"$quiet_boot" = x0 ]; then
      sed "s/^/$submenu_indentation/" << EOF
	echo	'$(echo "$message" | grub_quote)'
EOF
  fi
    sed "s/^/$submenu_indentation/" << EOF
	initrd	$(echo $initrd_path)
EOF
```

Burada ```initrd	$(echo $initrd_path)``` yazan yeri ```initrd	/boot/acpi_override $(echo $initrd_path)``` olarak değiştirelim ve kaydedilim.

Şimdi artık son olarak ```sudo update-grub``` komutunu çalıştırarak yaptığımız güncellemelerin ```grub.cfg``` dosyasına yazılmasını sağlayalım. Artık bilgisayarınızı her yeniden başlattığınızda hiçbir işlem yapmadan açabileceksiniz.

## Gerçek Hayat Sorunları
Şimdi tüm bunları yaptığınız halde bir şeyler ters gitmiş ve başaramamış olabilirsiniz. Gayet doğal çünkü karmaşık bir süreç. Üstelik her sistem için kendine özgü farklı sorunlar olabilir. Burada bu sorunları bulmak ve çözmek size kalıyor. Ancak yardım istemek için her zaman forumları kullanabilir, insanlara danışabilir veya bu repoya issue oluşturabilirsiniz.

Örnek olsun yukarıdaki sıraları takip ettiğimde benim sistemim tam olarak çalışmadı. Tek tek hatanın hangi ssdt dosyasından kaynaklandığını bulmak için tüm ssdt dosyalarını tek tek deneyerek ekledim. Yani yukarıdaki işlemlerin hepsini her bir ssdt dosyasını sırasıyla ekleyerek defalarca denedim. ```ssdt7.dsl```  dosyasını eklediğimde bu hatanın çıktığını farkettim. Üstelik ```ssdt7.dsl``` dosyasında herhangi bir syntax hatası olmadığı ve başarıyla derlendiği halde. Daha sonra ```ssdt7.dsl``` dosyasının içeriğini eklemeden oluşturduğum ```dsdt.dsl``` dosyasını derlediğimde ortaya çıkan dsdt tablosu harika bir şekilde çalıştı.

Hatayla karşılaştığınızda yapmanız gereken ilk şey hatanın ne olduğunu anlamak. Bunun için önce hata metnini arama motorlarında arayarak başlayabilirsiniz. Daha sonra forumlarda sorabilirsiniz. Hatayı anladıktan sonra, önce hatanın hangi şartlarda ortaya çıktığını bulup bu şartları giderek sadeleştirmelisiniz. Daha sonra hatanın tam olarak hangi noktadan kaynaklandığını saptamalısınız. Daha sonra çözüm kendiliğinden gelecektir. 

Benim örneğime baktalım; Önce hata olduğunu farkettim ve araştırdım daha sonra hatanın ssdt dosyalarının birinin içeriğinden kaynaklanabileceğini öğrendim. Daha sonra hangi ssdt dosyası olduğunu bulmak için tek tek ssdt dosyalarını ayırmak suretiyle değişik koşullar altında hatanın ortaya çıkıp çıkmadığını test ettim. ```ssdt7.dsl``` dosyasında çıktığını farkettim ve bu dosyayı çıkardığımda her şey kendiliğinden çözüldü.

Son olarak size en büyük önerim tüm bunları yaparken derli toplu çalışmanız. Çünkü her şeyin birbirine girmesi oldukça olası. Umarım en kısa zamanda bilgisayarınıza GNU/Linux yüklemeyi başarır ve windows illetinden kurtularak özgürlüğünüze kavuşursunuz.

Not: Bilgisayarının modeli benimkiyle aynı (```CASPER NIRVANA NB F650```) olanlar için ben tüm bu işlemleri bir bir yaptım ve src klasörü altında güzel bir şekilde sıraladım. Tüm bu adımları atlayıp ```src/final``` altında ihtiyacınız olan ```acpi_override``` dosyasını bulabilirsiniz. Böylece doğrudan son adıma atlayıp sorunlarınızı çözebilirsiniz. Ancak bunu yalnızca acpi tablolarının aynı olduğundan emin olduğunuzda yapın. Siz en iyisi yine baştan tüm adımları uygulayın ki hiç sorun yaşamayın.

## Bir Başka Sorun: Fn + Ses Tuşlarının Takılması
Tüm bu işleri yapmadan önce fn tuşlarından ses açma, ses kısma ve sessize alma tuşlarının acpi sorunları yüzünden takıldığını zannediyordum. Acpi sorunlarını çözdüğümde bu sorun hala duruyordu. Daha derin bir araştırmayla çözümünü buldum. Klavye doğru yapılandırılmamış. Çözümü aşağıda;

```
# Bu dosyayı aşağıdaki dizine kopyalayın
# /lib/udev/hwdb.d/99-casper-volume-keys-stuck-fix.hwdb 
# Eğer fn ses tuşlarına bastığınızda takılı kalıyorsa bu
# dosya sorununuzu fixleyecektir.
#
# Dosyayı kaydettikten sonra sırasıyla
#
# sudo systemd-hwdb update
#
# sudo udevadm trigger
#
# komutlarını sırasıyla çalıştırın.
# artık ses tuşlarınızı takılma olmadan kullanabilirsiniz.

evdev:atkbd:dmi:bvn*:bvr*:bd*:svn*:pn*:pvr*
 KEYBOARD_KEY_a0=!mute
 KEYBOARD_KEY_ae=!volumedown
 KEYBOARD_KEY_b0=!volumeup
```

Bu dosyanın oluşturulmuş halini ```src/fn``` klasörü içerisinde bulabilirsiniz.

## Kaynaklar ve İleri Okuma
https://rog.asus.com/forum/showthread.php?106165-Z370-e-BIOS-bug-that-I-have-fixed
https://01.org/linux-acpi/documentation/debug-how-isolate-linux-acpi-issues
https://01.org/linux-acpi/documentation/overriding-dsdt
https://www.kernel.org/doc/html/latest/admin-guide/acpi/initrd_table_override.html
https://wiki.archlinux.org/index.php/DSDT
https://wiki.debian.org/OverridingDSDT
https://wiki.ubuntu.com/DebuggingACPI
https://www.slideshare.net/suselab/acpi-debugging-from-linux-kernel
https://lwn.net/Articles/237085/