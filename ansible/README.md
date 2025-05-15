Перед запуском плейбука делаем скан хостов и записываем информацию о ключах

ssh-keyscan -H "Your Bastion IP" >> ~/.ssh/known_hosts

Далее вручную конектимся 1 раз, чтобы не было предупреждения ансибла.
ssh -o StrictHostKeyChecking=accept-new ubuntu@"Your Bastion IP" 'exit'


