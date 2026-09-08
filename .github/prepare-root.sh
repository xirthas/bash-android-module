#!/system/bin/sh
set -e

# 1. АВТОПОВТОР СИСТЕМНОГО КОРНЯ В FAKE_ROOT
mkdir -p /data/local/tmp/fake_root

# Проходим по корню Android и создаем безопасные ссылки
for item in /.* /*; do
    name=$(basename "$item")
    # Пропускаем служебные точки и наши будущие ПК-папки
    if [ "$name" = "." ] || [ "$name" = ".." ] || \
       [ "$name" = "bin" ] || [ "$name" = "sbin" ] || \
       [ "$name" = "etc" ] || [ "$name" = "tmp" ] || \
       [ "$name" = "var" ] || [ "$name" = "usr" ] || \
       [ "$name" = "dev" ] || [ "$name" = "proc" ] || \
       [ "$name" = "sys" ]; then
        continue
    fi
    ln -sf "$item" "/data/local/tmp/fake_root/$name"
done

# 2. Создаем изолированную ПК-структуру
mkdir -p /data/local/tmp/fake_root/usr/bin
mkdir -p /data/local/tmp/fake_root/bin
mkdir -p /data/local/tmp/fake_root/sbin
mkdir -p /data/local/tmp/fake_root/etc
mkdir -p /data/local/tmp/fake_root/home
mkdir -p /data/local/tmp/fake_root/tmp
mkdir -p /data/local/tmp/fake_root/var

# Папки для монтирования ядра
mkdir -p /data/local/tmp/fake_root/dev
mkdir -p /data/local/tmp/fake_root/proc
mkdir -p /data/local/tmp/fake_root/sys

# 3. Выставляем права доступа
chmod 755 /data/local/tmp/fake_root/usr
chmod 755 /data/local/tmp/fake_root/usr/bin
chmod 755 /data/local/tmp/fake_root/etc
chmod 777 /data/local/tmp/fake_root/home
chmod 777 /data/local/tmp/fake_root/tmp
chmod 755 /data/local/tmp/fake_root/var

# 4. Монтируем виртуальные файловые системы ядра
mount -t devtmpfs udev /data/local/tmp/fake_root/dev || mount --bind /dev /data/local/tmp/fake_root/dev
mount -t proc proc /data/local/tmp/fake_root/proc
mount -t sysfs sysfs /data/local/tmp/fake_root/sys

# 5. Делаем симлинки bin и sbin внутри chroot (относительно usr/bin)
cd /data/local/tmp/fake_root
rm -rf bin sbin
ln -s usr/bin bin
ln -s usr/bin sbin

# 6. Генерируем passwd для root и shell (UID 2000)
echo 'root:x:0:0:root:/root:/bin/sh' > /data/local/tmp/fake_root/etc/passwd
echo 'shell:x:2000:2000:shell:/tmp:/bin/sh' >> /data/local/tmp/fake_root/etc/passwd
chmod 644 /data/local/tmp/fake_root/etc/passwd
