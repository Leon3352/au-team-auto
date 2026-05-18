#!/bin/bash
set -e

# Пароль для SSH-подключений (root на srv, user на cli)
ROOT_PASS="P@ssw0rd"
CLI_USER="user"
CLI_PASS="P@ssw0rd"

echo "=== 1. Настройка ISP ==="
bash ./isp.sh

echo "=== 2. Ждем сеть 5 секунд ==="
sleep 5

echo "=== 3. Заливаем и запускаем hq-srv.sh ==="
sshpass -p "$ROOT_PASS" scp -o StrictHostKeyChecking=no ./hq-srv.sh root@192.168.1.10:/tmp/setup.sh
sshpass -p "$ROOT_PASS" ssh -o StrictHostKeyChecking=no root@192.168.1.10 "bash /tmp/setup.sh"

echo "=== 4. Заливаем и запускаем br-srv.sh ==="
sshpass -p "$ROOT_PASS" scp -o StrictHostKeyChecking=no ./br-srv.sh root@192.168.3.10:/tmp/setup.sh
sshpass -p "$ROOT_PASS" ssh -o StrictHostKeyChecking=no root@192.168.3.10 "bash /tmp/setup.sh"

echo "=== 5. Заливаем и запускаем cli.sh ==="
sshpass -p "$CLI_PASS" scp -o StrictHostKeyChecking=no ./cli.sh ${CLI_USER}@192.168.2.10:/tmp/setup.sh
sshpass -p "$CLI_PASS" ssh -o StrictHostKeyChecking=no ${CLI_USER}@192.168.2.10 "echo '$CLI_PASS' | sudo -S bash /tmp/setup.sh"

echo ""
echo "=== ГОТОВО ==="
echo "hq-srv, br-srv, cli настроены автоматически."
echo "Осталось только зайти на hq-rtr и br-rtr и вставить тексты команд."